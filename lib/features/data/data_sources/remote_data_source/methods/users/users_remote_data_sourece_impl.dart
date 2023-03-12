

import 'dart:typed_data';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta_clone/consts.dart';
import 'package:insta_clone/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:insta_clone/features/data/models/user/user_model.dart';
import 'package:insta_clone/features/domain/entities/user/user_entity.dart';
import 'package:insta_clone/features/domain/entities/posts/posts_entity.dart';

class  UsersRemoteDataSourceImpl   {

  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;


  UsersRemoteDataSourceImpl(
      {required this.firebaseAuth,
      required this.firebaseFirestore,
      required this.firebaseStorage});

  

  Future<void> createUserWithImage( UserEntity user,  String profileUrl ) async {
    try {
      final userCollection = firebaseFirestore.collection(FirebaseConst.users);

      final uid = await getCurrentUid();

      await userCollection.doc(uid).get().then((userDoc) async {
        final newUser = UserModel(
                uid: uid,
                name: user.name ?? '',
                email: user.email ?? '',
                bio: user.bio ?? '',
                following: user.following ?? [],
                website: user.website ?? '',
                profileUrl: profileUrl,
                username: user.username ?? '',
                totalFollowers: user.totalFollowers ?? 0,
                followers: user.followers ?? [],
                totalFollowing: user.totalFollowing ?? 0,
                totalPosts: user.totalPosts ?? 0)
            .toJson();

        if (!userDoc.exists) {
          await userCollection.doc(uid).set(newUser);
        } else {
          await userCollection.doc(uid).update(newUser);
        }
      }).catchError((error) {
        toast("Some error occur");
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> createUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    final uid = await getCurrentUid();

    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
              uid: uid,
              name: user.name ?? '',
              email: user.email ?? '',
              bio: user.bio ?? '',
              following: user.following ?? [],
              website: user.website ?? '',
              profileUrl: user.profileUrl ?? '',
              username: user.username ?? '',
              totalFollowers: user.totalFollowers ?? 0,
              followers: user.followers ?? [],
              totalFollowing: user.totalFollowing ?? 0,
              totalPosts: user.totalPosts ?? 0)
          .toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      toast("Some error occur");
    });
  }

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConst.users)
        .where("uid", isEqualTo: uid)
        .limit(1);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> signInUser(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: user.email!, password: user.password!);
      } else {
        print("fields cannot be empty");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        toast("user not found");
      } else if (e.code == "wrong-password") {
        toast("Invalid email or password");
      }
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> signUpUser(UserEntity user , Future<String> Function({
  File? file,
  required bool isPost,
  required String childName,
  Uint8List? imageWeb,
}) uploadImageToStorage) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
              email: user.email ?? '', password: user.password ?? '')
          .then((value) async {
        if (value.user?.uid != null) {
          if (user.imageFile != null || user.imageWeb != null) {
            uploadImageToStorage(
                    file: user.imageFile,
                    isPost: false,
                    childName: FirebaseConst.profileImage,
                    imageWeb: user.imageWeb
                    
                    )
                .then((profileUrl) {
              createUserWithImage(user, profileUrl);
            });
          } else {
            await createUserWithImage(user, '');
          }
        }
      });
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        toast("email is already taken");
      } else {
        toast("something went wrong");
      }
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    Map<String, dynamic> userInformation = Map();

    if (user.username != "" && user.username != null)
      userInformation['username'] = user.username;

    if (user.website != "" && user.website != null)
      userInformation['website'] = user.website;

    if (user.profileUrl != "" && user.profileUrl != null)
      userInformation['profileUrl'] = user.profileUrl;

    if (user.bio != "" && user.bio != null) userInformation['bio'] = user.bio;

    if (user.name != "" && user.name != null)
      userInformation['name'] = user.name;

    if (user.totalFollowing != null)
      userInformation['totalFollowing'] = user.totalFollowing;

    if (user.totalFollowers != null)
      userInformation['totalFollowers'] = user.totalFollowers;

    if (user.totalPosts != null)
      userInformation['totalPosts'] = user.totalPosts;

    userCollection.doc(user.uid).update(userInformation);
  }
  
}