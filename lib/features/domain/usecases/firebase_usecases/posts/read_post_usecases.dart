import 'package:insta_clone/features/domain/entities/posts/posts_entity.dart';
import 'package:insta_clone/features/domain/repository/firebase_repository.dart';

class ReadPostsUseCase {
  final FirebaseRepository repository;

  ReadPostsUseCase({required this.repository});

  Stream<List<PostEntity>> call(PostEntity post) {
    return repository.readPost(post);
  }
}
