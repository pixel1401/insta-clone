import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/consts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({Key? key}) : super(key: key);

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  TextEditingController description = TextEditingController();

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
  void dispose() {
    super.dispose();
    description.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_image != null || _imageWeb != null) {
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
              setState(() {
                _image = null;
                _imageWeb = null;
              });
            },
            icon: Icon(Icons.close)),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.check))],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              showImage(),
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
}
