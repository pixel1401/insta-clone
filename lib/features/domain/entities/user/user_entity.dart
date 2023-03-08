import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class UserEntity extends Equatable {
  final String? uid, username, name, bio, website, email, profileUrl;
  final List? followers, following;
  final num? totalFollowers, totalFollowing, totalPosts;

  // will not going to store in DB
  final File? imageFile;
  final Uint8List? imageWeb;
  final String? password, otherUid;

  UserEntity(
      {
      this.imageFile,  
      this.imageWeb,
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
        imageWeb,
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
