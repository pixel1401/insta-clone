import 'dart:io';
import 'dart:typed_data';

import 'package:insta_clone/features/domain/entities/user/user_entity.dart';
import 'package:insta_clone/features/domain/repository/firebase_repository.dart';

class UploadImageToStorageUseCase {
  final FirebaseRepository repository;

  UploadImageToStorageUseCase({required this.repository});

  Future<String> call({File? file, required bool isPost, required String childName , Uint8List? imageWeb}) {
    return repository.uploadImageToStorage(file : file, isPost : isPost, childName : childName , imageWeb: imageWeb);
  }
}
