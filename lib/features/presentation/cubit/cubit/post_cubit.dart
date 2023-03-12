import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:insta_clone/features/domain/entities/posts/posts_entity.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/posts/create_post_usecases.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/posts/delete_post_usecases.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/posts/like_post_usecases.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/posts/read_post_usecases.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/posts/update_post_usecases.dart';
part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final ReadPostsUseCase readPostsUseCase;
  final UpdatePostsUseCase updatePostsUseCase;
  final DeletePostsUseCase deletePostsUseCase;
  final CreatePostsUseCase createPostsUseCase;
  final LikePostsUseCase likePostsUseCase;
  PostCubit(
      {required this.readPostsUseCase,
      required this.updatePostsUseCase,
      required this.deletePostsUseCase,
      required this.createPostsUseCase,
      required this.likePostsUseCase})
      : super(PostInitial());

  Future<void> getPosts({required PostEntity post}) async {
    emit(PostLoading());
    try {
      final streamResponse = readPostsUseCase.call(post);
      streamResponse.listen((posts) {
        emit(PostLoaded(posts: posts));
      });
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> updatePost({required PostEntity post}) async {
    emit(PostLoading());
    try {
      await updatePostsUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> deletePost({required PostEntity post}) async {
    emit(PostLoading());
    try {
      await deletePostsUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> createPost({required PostEntity post}) async {
    emit(PostLoading());
    try {
      await createPostsUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> likePost({required PostEntity post}) async {
    emit(PostLoading());
    try {
      await likePostsUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }
}
