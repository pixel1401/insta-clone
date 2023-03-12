import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/features/domain/entities/posts/posts_entity.dart';

class PostsModel extends PostEntity {
  final String? postId,
      creatorUid,
      username,
      description,
      postImageUrl,
      userProfileUrl;
  final List<String>? likes;
  final num? totalLikes, totalComments;
  final Timestamp? createAt;

  PostsModel({
    required this.postId,
    required this.creatorUid,
    required this.username,
    required this.description,
    required this.postImageUrl,
    required this.userProfileUrl,
    required this.totalLikes,
    required this.likes,
    required this.totalComments,
    required this.createAt,
  }) : super(
            postId: postId,
            creatorUid: creatorUid,
            username: username,
            description: description,
            postImageUrl: postImageUrl,
            userProfileUrl: userProfileUrl,
            totalLikes: totalLikes,
            likes: likes,
            totalComments: totalComments,
            createAt: createAt);

  factory PostsModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostsModel(
        postId: snapshot['postId'],
        creatorUid: snapshot['creatorUid'],
        username: snapshot['username'],
        description: snapshot['description'],
        postImageUrl: snapshot['postImageUrl'],
        userProfileUrl: snapshot['userProfileUrl'],
        totalLikes: snapshot['totalLikes'],
        likes: snapshot['likes'],
        totalComments: snapshot['totalComments'],
        createAt: snapshot['createAt']);
  }

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'creatorUid': creatorUid,
        'username': username,
        'description': description,
        'postImageUrl': postImageUrl,
        'userProfileUrl': userProfileUrl,
        'totalLikes': totalLikes,
        'likes': likes,
        'totalComments': totalComments,
        'createAt': createAt
      };
}
