import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/features/domain/entities/user/user_entity.dart';

class UserModel extends UserEntity {
  final String? uid, username, name, bio, website, email, profileUrl;
  final List? followers, following;
  final num? totalFollowers, totalFollowing   , totalPosts;
  UserModel(
      {this.uid,
      this.username,
      this.name,
      this.bio,
      this.website,
      this.email,
      this.profileUrl,
      this.followers,
      this.following,
      this.totalFollowers,
      this.totalPosts ,
      this.totalFollowing}) : super(
         uid: uid,
          totalFollowing: totalFollowing,
          followers: followers,
          totalFollowers: totalFollowers,
          username: username,
          profileUrl: profileUrl,
          website: website,
          following: following,
          bio: bio,   
          name: name,
          email: email,
          totalPosts: totalPosts,
      );



    factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      email: snapshot['email'],
      name: snapshot['name'],
      bio: snapshot['bio'],
      username: snapshot['username'],
      totalFollowers: snapshot['totalFollowers'],
      totalFollowing: snapshot['totalFollowing'],
      totalPosts: snapshot['totalPosts'],
      uid: snapshot['uid'],
      website: snapshot['website'],
      profileUrl: snapshot['profileUrl'],
      followers: List.from(snap.get("followers")),
      following: List.from(snap.get("following")),
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "name": name,
        "username": username,
        "totalFollowers": totalFollowers,
        "totalFollowing": totalFollowing,
        "totalPosts": totalPosts,
        "website": website,
        "profileUrl": profileUrl,
        "followers": followers,
        "following": following,
      };


      
}
