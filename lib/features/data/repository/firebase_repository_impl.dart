import 'dart:io';
import 'dart:typed_data';

import 'package:insta_clone/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:insta_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:insta_clone/features/domain/entities/posts/posts_entity.dart';
import 'package:insta_clone/features/domain/entities/user/user_entity.dart';
import 'package:insta_clone/features/domain/replay/replay_entity.dart';
import 'package:insta_clone/features/domain/repository/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource remoteDataSource;

  FirebaseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createUser(UserEntity user) async =>
      remoteDataSource.createUser(user);
  @override
  Future<String> getCurrentUid() async => remoteDataSource.getCurrentUid();

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) =>
      remoteDataSource.getSingleUser(uid);

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) =>
      remoteDataSource.getUsers(user);

  @override
  Future<bool> isSignIn() async => remoteDataSource.isSignIn();

  @override
  Future<void> signInUser(UserEntity user) async =>
      remoteDataSource.signInUser(user);

  @override
  Future<void> signOut() async => remoteDataSource.signOut();

  @override
  Future<void> signUpUser(UserEntity user) async =>
      remoteDataSource.signUpUser(user);

  @override
  Future<void> updateUser(UserEntity user) async =>
      remoteDataSource.updateUser(user);

  
  // STORAGE
  @override
  Future<String> uploadImageToStorage(
      {File? file,
      required bool isPost,
      required String childName,
      Uint8List? imageWeb}) {
    // TODO: implement uploadImageToStorage
    return remoteDataSource.uploadImageToStorage(
        file: file, isPost: isPost, childName: childName, imageWeb: imageWeb);
  }

  @override
  Future<void> deleteFileToStorage({required String fileUrl}) {
    return remoteDataSource.deleteFileToStorage(fileUrl: fileUrl);
  }


  @override
  Future<void> createPost(PostEntity post) async =>
      remoteDataSource.createPost(post);

  @override
  Future<void> deletePost(PostEntity post) async =>
      remoteDataSource.deletePost(post);

  @override
  Future<void> likePost(PostEntity post) async =>
      remoteDataSource.likePost(post);

  @override
  Stream<List<PostEntity>> readPost(PostEntity post) {
    return remoteDataSource.readPost(post);
  }
  

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) => remoteDataSource.readSinglePost(postId);

  @override
  Future<void> updatePost(PostEntity post) async =>
      remoteDataSource.updatePost(post);



  // COMMENT
  @override
  Future<void> createComment(CommentEntity comment) {
    return remoteDataSource.createComment(comment);
  }

  @override
  Future<void> deleteComment(CommentEntity comment) {
    // TODO: implement deleteComment
    return remoteDataSource.deleteComment(comment);
  }

  @override
  Future<void> likeComment(CommentEntity comment) {
    return remoteDataSource.likeComment(comment);
  }

  @override
  Stream<List<CommentEntity>> readComments(String postId) {
   return remoteDataSource.readComments(postId);
  }

  @override
  Future<void> updateComment(CommentEntity comment) {
    return remoteDataSource.updateComment(comment);
  }



  // REPLAY
  @override
  Future<void> createReplay(ReplayEntity replay) async => remoteDataSource.createReplay(replay);

  @override
  Future<void> deleteReplay(ReplayEntity replay) async => remoteDataSource.deleteReplay(replay);

  @override
  Future<void> likeReplay(ReplayEntity replay) async => remoteDataSource.likeReplay(replay);

  @override
  Stream<List<ReplayEntity>> readReplays(ReplayEntity replay) => remoteDataSource.readReplays(replay);

  @override
  Future<void> updateReplay(ReplayEntity replay) async => remoteDataSource.updateReplay(replay);
  
  

}
