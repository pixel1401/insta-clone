import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? uid, username, name, bio, website, email, profileUrl;
  final List? followers, following;
  final num? totalFollowers, totalFollowing;

  // will not going to store in DB
  final String? password, otherUid;

  UserEntity(this.uid, this.username, this.name, this.bio, this.website, this.email, this.profileUrl, this.followers, this.following, this.totalFollowers, this.totalFollowing, this.password, this.otherUid);

  @override
  List<Object?> get props => [
    uid , username , name , bio , website , email , profileUrl,followers , following , totalFollowers , totalFollowing , password , otherUid
  ];
}
