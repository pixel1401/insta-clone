import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/comment/create_comment_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/comment/dalete_comment_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/comment/like_comment_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/comment/read_comment_usecase.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/comment/update_comment_usecase.dart';

part 'comment_state.dart';


class CommentCubit extends Cubit<CommentState> {

  final CreateCommentUseCase createCommentUseCase;
  final ReadCommentUseCase readCommentUseCase;
  final UpdateCommentUseCase updateCommentUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;

  final LikeCommentUseCase likeCommentUseCase;


  CommentCubit({required this.createCommentUseCase, required this.readCommentUseCase, required this.updateCommentUseCase, required this.deleteCommentUseCase, required this.likeCommentUseCase}) : super(CommentInitial());

  Future<void> createComment ({required CommentEntity comment}) async {
    // emit(CommentLoading());
    try {
      await createCommentUseCase.call(comment);
    } catch (e) {
      emit(CommentFailure());
    }
  }


  Future<void> readComment({required String postId}) async {
    emit(CommentLoading());
    try {
      var comments = readCommentUseCase.call(postId);
      comments.listen((event) { 
          Future<void>.delayed(const Duration(milliseconds: 50));
          emit(CommentSuccess(comments: event));
      });
    } catch (e) {
      emit(CommentFailure());
    }
  }


  Future<void> updateComment ({required CommentEntity comment}) async {
    try {
      await updateCommentUseCase.call(comment);
    } catch (e) {
      emit(CommentFailure());
    }
  }


  Future<void> deleteComment ({required CommentEntity comment}) async {
    try {
      await deleteCommentUseCase.call(comment);
    } catch (e) {
      emit(CommentFailure());
    }
  }


  Future<void> likeComment ({required CommentEntity comment}) async {
    try {
      await likeCommentUseCase.call(comment);
    } catch (e) {
      emit(CommentFailure());
    }
  }  


}
