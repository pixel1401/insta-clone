import 'package:insta_clone/features/domain/entities/user/user_entity.dart';
import 'package:insta_clone/features/domain/repository/firebase_repository.dart';

class GetSingleUserUseCase {
  final FirebaseRepository repository;
  GetSingleUserUseCase({required this.repository});

  Stream<List<UserEntity>> call(String uid) {
    return repository.getSingleUser(uid);
  }
}
