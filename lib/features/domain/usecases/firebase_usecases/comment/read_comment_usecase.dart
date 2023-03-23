import 'package:insta_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:insta_clone/features/domain/repository/firebase_repository.dart';

class ReadCommentUseCase {
  final FirebaseRepository repository;

  ReadCommentUseCase({required this.repository});

  Stream<List<CommentEntity>> call(String postId) {
    return repository.readComments(postId);
  }
}