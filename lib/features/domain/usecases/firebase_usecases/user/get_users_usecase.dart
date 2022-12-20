import 'package:insta_clone/features/domain/entities/user/user_entity.dart';
import 'package:insta_clone/features/domain/repository/firebase_repository.dart';

class GetUsersUseCase {
  final FirebaseRepository repository;
  GetUsersUseCase({required this.repository});

  call(UserEntity user) {
    return repository.getUsers(user);
  }
}
