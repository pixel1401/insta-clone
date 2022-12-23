import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String? postId,
      creatorUid,
      username,
      description,
      postImageUrl,
      userProfileUrl;
  final List<String>? likes;
  final num? totalLikes, totalComments;
  final Timestamp? createAt;

  PostEntity(
      {this.postId,
      this.creatorUid,
      this.username,
      this.description,
      this.postImageUrl,
      this.userProfileUrl,
      this.likes,
      this.totalLikes,
      this.totalComments,
      this.createAt});
  @override
  // TODO: implement props
  List<Object?> get props => [
      postId,
      creatorUid,
      username,
      description,
      postImageUrl,
      userProfileUrl,
      likes,
      totalLikes,
      totalComments,
      createAt
  ];
}
