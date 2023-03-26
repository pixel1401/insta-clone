

import 'package:insta_clone/features/domain/entities/posts/posts_entity.dart';
import 'package:insta_clone/features/domain/entities/user/user_entity.dart';

class AppEntity {

  final UserEntity? currentUser;
  final PostEntity? postEntity;

  final String? uid;
  final String? postId;

  AppEntity({this.currentUser, this.postEntity, this.uid, this.postId});
}