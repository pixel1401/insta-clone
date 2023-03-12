import 'package:insta_clone/features/domain/entities/posts/posts_entity.dart';
import 'package:insta_clone/features/domain/repository/firebase_repository.dart';

class CreatePostsUseCase {
  final FirebaseRepository repository;

  CreatePostsUseCase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.createPost(post);
  }
}
