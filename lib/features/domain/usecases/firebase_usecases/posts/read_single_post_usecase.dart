import 'package:insta_clone/features/domain/entities/posts/posts_entity.dart';
import 'package:insta_clone/features/domain/repository/firebase_repository.dart';

class ReadSinglePostUseCase {
  final FirebaseRepository repository;

  ReadSinglePostUseCase({required this.repository});

  Stream<List<PostEntity>> call(String postId) {
    return repository.readSinglePost(postId);
  }
}