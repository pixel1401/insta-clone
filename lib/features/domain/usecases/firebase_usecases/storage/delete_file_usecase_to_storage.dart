import 'dart:io';
import 'package:insta_clone/features/domain/repository/firebase_repository.dart';

class DeleteFileToStorageUseCase {
  final FirebaseRepository repository;

  DeleteFileToStorageUseCase({required this.repository});

  Future<void> call({required String fileUrl}) {
    return repository.deleteFileToStorage(fileUrl: fileUrl );
  }
}
