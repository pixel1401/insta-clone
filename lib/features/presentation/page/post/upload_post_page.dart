import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/consts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:insta_clone/features/domain/entities/posts/posts_entity.dart';
import 'package:insta_clone/features/domain/entities/user/user_entity.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/storage/upload_image_usecase_to_storage.dart';
import 'package:insta_clone/features/presentation/cubit/post/post_cubit.dart';
import 'package:insta_clone/features/presentation/cubit/user/user_cubit.dart';
import 'package:insta_clone/features/presentation/widgets/profile_widget.dart';
import 'package:insta_clone/injection_container.dart' as di;
import 'package:uuid/uuid.dart';

class UploadPostPage extends StatefulWidget {
  final UserEntity user;
  final PostEntity? postUpdate;

  const UploadPostPage({Key? key, required this.user, this.postUpdate})
      : super(key: key);

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  TextEditingController description = TextEditingController();

  bool _isUploading = false;

  File? _image;
  Uint8List? _imageWeb;
  String? _imageUploadPost;

  Future selectImage() async {
    try {
      if (kIsWeb) {
        FilePickerResult? result = await FilePicker.platform.pickFiles();

        if (result != null) {
          Uint8List? file = result.files.single.bytes;
          setState(() {
            _imageWeb = file;
          });
        } else {
          toast('Some error pick file');
          return;
        }
      } else {
        final pickedFile =
            await ImagePicker.platform.getImage(source: ImageSource.gallery);

        setState(() {
          if (pickedFile != null) {
            _image = File(pickedFile.path);
          } else {
            print('not image selected');
          }
        });
      }
    } catch (err) {
      toast('Some error occured ${err}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.postUpdate != null) {
      description.text = widget.postUpdate?.description ?? '';
      _imageUploadPost = widget.postUpdate?.postImageUrl ?? '';
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    description.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_image != null || _imageWeb != null || _imageUploadPost != null) {
      return initPost();
    } else {
      return Scaffold(
          backgroundColor: backGroundColor,
          body: Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(.3),
                  shape: BoxShape.circle),
              child: Center(
                child: GestureDetector(
                    onTap: () => selectImage(),
                    child: Icon(
                      Icons.upload,
                      color: primaryColor,
                      size: 40,
                    )),
              ),
            ),
          ));
    }
  }

  Widget initPost() {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        leading: IconButton(
            onPressed: () {
              _clear();
              if (widget.postUpdate != null) {
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.close)),
        actions: [
          IconButton(
              onPressed: () async {
                await _uploadOrUpdatePostDate();
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => selectImage(),
                child: showImage(),
              ),
              sizeVer(15),
              TextFormField(
                controller: description,
                maxLines: 5,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter your text here',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                ),
              ),
              sizeVer(15),
              if (_isUploading)
                Center(
                  child: CircularProgressIndicator(),
                )
            ],
          ),
        ),
      ),
    );
  }

  showImage() {
    Widget? imageWidget;
    if (_image != null) {
      imageWidget = Image.file(
        _image!,
        fit: BoxFit.cover,
      );
    } else if (_imageWeb != null) {
      imageWidget = Image.memory(
        _imageWeb!,
        fit: BoxFit.cover,
      );
    } else if (_imageUploadPost != null) {
      imageWidget = profileWidget(imageUrl: _imageUploadPost);
    } else {
      imageWidget = Image.asset(
        'assets/profile_default.png',
        fit: BoxFit.cover,
      );
    }

    return Container(
      height: 300,
      child: imageWidget,
    );
  }

  // UPLOAD
  _uploadOrUpdatePostDate() {
    setState(() {
      _isUploading = true;
    });

    if (_image != null || _imageWeb != null) {
      di
          .sl<UploadImageToStorageUseCase>()
          .call(
              file: _image,
              isPost: false,
              childName: FirebaseConst.postImage,
              imageWeb: _imageWeb)
          .then((profileUrl) {
            if(widget.postUpdate == null) {
              _uploadPost(profileUrl);
            }else {
              _updatePost(profileUrl);
            }
        toast('Upload Post');
      });
    } else if (_imageUploadPost != null && widget.postUpdate != null) {
      _updatePost(widget.postUpdate?.postImageUrl ?? '');
    } else {
      toast('Post image don"t upload');
    }
  }

  _uploadPost(String imageUrl) {
    if (_isUploading == false) {
      setState(() {
        _isUploading = true;
      });
    }

    BlocProvider.of<PostCubit>(context)
        .createPost(
            post: PostEntity(
                description: description.text,
                postImageUrl: imageUrl,
                creatorUid: widget.user.uid,
                postId: Uuid().v1(),
                username: widget.user.username,
                userProfileUrl: widget.user.profileUrl,
                totalComments: 0,
                totalLikes: 0,
                likes: [],
                createAt: Timestamp.now()))
        .then((value) => {_clear()});
  }

  _updatePost(String imageUrl) {
    if (_isUploading == false) {
      setState(() {
        _isUploading = true;
      });
    }

    BlocProvider.of<PostCubit>(context)
        .updatePost(
            post: PostEntity(
                description: description.text,
                postImageUrl: imageUrl,
                creatorUid: widget.user.uid,
                postId: widget.postUpdate?.postId,
                username: widget.user.username,
                userProfileUrl: widget.user.profileUrl,
                totalComments: widget.postUpdate?.totalComments,
                totalLikes: widget.postUpdate?.totalLikes,
                likes: widget.postUpdate?.likes,
                createAt: widget.postUpdate?.createAt))
        .then((value) {
      Navigator.pop(context);
    });
  }

  _clear() {
    setState(() {
      _isUploading = false;
      _image = null;
      _imageWeb = null;
      _imageUploadPost = null;
    });
  }
}
