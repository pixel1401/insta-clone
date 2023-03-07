import 'dart:io';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? uid, username, name, bio, website, email, profileUrl;
  final List? followers, following;
  final num? totalFollowers, totalFollowing, totalPosts;

  // will not going to store in DB
  final File? imageFile;
  final String? password, otherUid;

  UserEntity(
      {
      this.imageFile,  
      this.uid,
      this.username,
      this.name,
      this.bio,
      this.website,
      this.email,
      this.profileUrl,
      this.followers,
      this.following,
      this.totalFollowers,
      this.totalFollowing,
      this.password,
      this.otherUid,
      this.totalPosts});

  @override
  List<Object?> get props => [
        imageFile,  
        uid,
        username,
        name,
        bio,
        website,
        email,
        profileUrl,
        followers,
        following,
        totalFollowers,
        totalFollowing,
        password,
        otherUid
      ];
}
