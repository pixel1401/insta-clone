import 'package:insta_clone/features/domain/entities/user/user_entity.dart';
import 'package:insta_clone/features/domain/repository/firebase_repository.dart';

class SignUpUserUseCase {
  final FirebaseRepository repository;
  SignUpUserUseCase({required this.repository});

  Future<void> call(UserEntity userEntity) {
    return repository.signUpUser(userEntity);
  }
}
