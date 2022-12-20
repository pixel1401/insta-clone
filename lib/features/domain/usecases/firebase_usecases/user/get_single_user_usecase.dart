import 'package:insta_clone/features/domain/repository/firebase_repository.dart';

class GetSingleUserUseCase {
  final FirebaseRepository repository;
  GetSingleUserUseCase({required this.repository});

  Stream call(String uid) {
    return repository.getSingleUser(uid);
  }
}
