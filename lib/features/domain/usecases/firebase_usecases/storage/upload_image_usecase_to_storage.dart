import 'dart:io';

import 'package:insta_clone/features/domain/entities/user/user_entity.dart';
import 'package:insta_clone/features/domain/repository/firebase_repository.dart';

class UploadImageToStorageUseCase {
  final FirebaseRepository repository;

  UploadImageToStorageUseCase({required this.repository});

  Future<String> call(File file , bool isPost , String childName) {
    return repository.uploadImageToStorage(file, isPost, childName);
  }
}
