import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/consts.dart';
import 'package:insta_clone/features/domain/entities/user/user_entity.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/storage/delete_file_usecase_to_storage.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/storage/upload_image_usecase_to_storage.dart';
import 'package:insta_clone/features/presentation/cubit/user/user_cubit.dart';
import 'package:insta_clone/features/presentation/page/profile/widget/profile_form_widget.dart';
import 'package:insta_clone/features/presentation/widgets/profile_widget.dart';
import 'package:insta_clone/injection_container.dart' as di;
import 'package:flutter/foundation.dart' show kIsWeb;

class EditProfilePage extends StatefulWidget {
  final UserEntity userEntity;

  const EditProfilePage({Key? key, required this.userEntity}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController? _nameController;
  TextEditingController? _usernameController;
  TextEditingController? _websiteController;
  TextEditingController? _bioController;

  bool _isUploading = false;

  File? _image;

  Uint8List? _imageWeb;

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
    super.initState();
    _nameController = TextEditingController(text: widget.userEntity.name);
    _usernameController =
        TextEditingController(text: widget.userEntity.username);
    _websiteController = TextEditingController(text: widget.userEntity.website);
    _bioController = TextEditingController(text: widget.userEntity.bio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: Text("Edit Profile"),
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.close,
              size: 32,
            )),
        actions: [
          GestureDetector(
            onTap: () => _uploadUserProfileDate(),
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.done,
                color: blueColor,
                size: 32,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: profileWidget(
                        imageUrl: widget.userEntity.profileUrl,
                        image: _image,
                        imageWeb: _imageWeb),
                  ),
                ),
              ),
              sizeVer(15),
              GestureDetector(
                onTap: () => selectImage(),
                child: Center(
                  child: Text(
                    "Change profile photo",
                    style: TextStyle(
                        color: blueColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              sizeVer(15),
              ProfileFormWidget(
                title: "Name",
                controller: _nameController,
              ),
              sizeVer(15),
              ProfileFormWidget(
                title: "Username",
                controller: _usernameController,
              ),
              sizeVer(15),
              ProfileFormWidget(
                title: "Website",
                controller: _websiteController,
              ),
              sizeVer(15),
              ProfileFormWidget(
                title: "Bio",
                controller: _bioController,
              ),
              sizeVer(10),
              _isUploading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Please Wait...',
                          style: TextStyle(color: Colors.white),
                        ),
                        sizeHor(10),
                        CircularProgressIndicator()
                      ],
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  _uploadUserProfileDate() {
    if (_image != null || _imageWeb != null) {
      setState(() {
        _isUploading = true;
      });
      di
          .sl<UploadImageToStorageUseCase>()
          .call(
              file: _image,
              isPost: false,
              childName: FirebaseConst.profileImage,
              imageWeb: _imageWeb)
          .then((profileUrl) {
        _updateUserProfile(profileUrl);
        // di.sl<DeleteFileToStorageUseCase>().call(fileUrl: widget.userEntity.profileUrl ?? '');
      });
    } else {
      return _updateUserProfile('');
    }
  }

  _updateUserProfile(String? imageUrl) {
    if (_isUploading == false) {
      setState(() {
        _isUploading = true;
      });
    }

    BlocProvider.of<UserCubit>(context)
        .updateUser(
            user: UserEntity(
                uid: widget.userEntity.uid,
                username: _usernameController!.text,
                name: _nameController!.text,
                website: _websiteController!.text,
                bio: _bioController!.text,
                profileUrl: imageUrl))
        .then((value) => {_clear()});
  }

  _clear() {
    setState(() {
      _isUploading = false;
      _nameController!.clear();
      _usernameController!.clear();
      _websiteController!.clear();
      _bioController!.clear();
    });

    Navigator.pop(context);
  }
}
