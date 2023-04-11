import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:insta_clone/consts.dart';
import 'package:insta_clone/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:insta_clone/features/data/models/comment/comment_model.dart';
import 'package:insta_clone/features/data/models/posts/posts_model.dart';
import 'package:insta_clone/features/data/models/replay/replay_model.dart';
import 'package:insta_clone/features/data/models/user/user_model.dart';
import 'package:insta_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:insta_clone/features/domain/entities/posts/posts_entity.dart';
import 'package:insta_clone/features/domain/entities/user/user_entity.dart';
import 'package:insta_clone/features/domain/replay/replay_entity.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  FirebaseRemoteDataSourceImpl(
      {required this.firebaseAuth,
      required this.firebaseFirestore,
      required this.firebaseStorage});

  @override
  Future<void> createUserWithImage(UserEntity user, String profileUrl) async {
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

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> signUpUser(UserEntity user) async {
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
                    imageWeb: user.imageWeb)
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


  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConst.users)
        .where("uid", isEqualTo: otherUid)
        .limit(1);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }


    @override
  Future<void> followUnFollowUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    final myDocRef = await userCollection.doc(user.uid).get();
    final otherUserDocRef = await userCollection.doc(user.otherUid).get();

    if (myDocRef.exists && otherUserDocRef.exists) {
      List myFollowingList = myDocRef.get("following");
      List otherUserFollowersList = otherUserDocRef.get("followers");

      // My Following List
      if (myFollowingList.contains(user.otherUid)) {
        userCollection.doc(user.uid).update({
          "following": FieldValue.arrayRemove([user.otherUid])
        }).then((value) {
          final userCollection =
              firebaseFirestore.collection(FirebaseConst.users).doc(user.uid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowing = value.get('totalFollowing');
              userCollection.update({"totalFollowing": totalFollowing - 1});
              return;
            }
          });
        });
      } else {
        userCollection.doc(user.uid).update({
          "following": FieldValue.arrayUnion([user.otherUid])
        }).then((value) {
          final userCollection =
              firebaseFirestore.collection(FirebaseConst.users).doc(user.uid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowing = value.get('totalFollowing');
              userCollection.update({"totalFollowing": totalFollowing + 1});
              return;
            }
          });
        });
      }

      // Other User Following List
      if (otherUserFollowersList.contains(user.uid)) {
        userCollection.doc(user.otherUid).update({
          "followers": FieldValue.arrayRemove([user.uid])
        }).then((value) {
          final userCollection = firebaseFirestore
              .collection(FirebaseConst.users)
              .doc(user.otherUid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowers = value.get('totalFollowers');
              userCollection.update({"totalFollowers": totalFollowers - 1});
              return;
            }
          });
        });
      } else {
        userCollection.doc(user.otherUid).update({
          "followers": FieldValue.arrayUnion([user.uid])
        }).then((value) {
          final userCollection = firebaseFirestore
              .collection(FirebaseConst.users)
              .doc(user.otherUid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowers = value.get('totalFollowers');
              userCollection.update({"totalFollowers": totalFollowers + 1});
              return;
            }
          });
        });
      }
    }
  }



  // !POSTS
  @override
  Future<void> createPost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);

    final currentUid = await getCurrentUid();

    final postModel = PostsModel(
            postId: post.postId,
            creatorUid: post.creatorUid,
            username: post.username,
            description: post.description,
            postImageUrl: post.postImageUrl,
            userProfileUrl: post.userProfileUrl,
            totalLikes: 0,
            likes: [],
            totalComments: 0,
            createAt: post.createAt)
        .toJson();

    postCollection.doc(post.postId).get().then((value) {
      if (!value.exists) {
        postCollection.doc(post.postId).set(postModel).then((newPost)  {
          final userCollection = firebaseFirestore.collection(FirebaseConst.users).doc(post.creatorUid);

          userCollection.get().then((currentUser) {
            if(currentUser.exists) {
              final totalPosts = currentUser.get('totalPosts');
              userCollection.update({"totalPosts" : totalPosts +  1});
              return;
            }
          });

          return;
        } );
      } else {
        postCollection.doc(post.postId).update(postModel);
      }
    }).catchError((e) {
      print('Error craete post ${e} ');
    });
  }

  @override
  Future<void> deletePost(PostEntity post) async {
    final postsCollection = firebaseFirestore.collection(FirebaseConst.posts);

    try {
      postsCollection.doc(post.postId).delete().then((newPost)  {
          final userCollection = firebaseFirestore.collection(FirebaseConst.users).doc(post.creatorUid);
          print('${post.creatorUid}  HELLO FERBS');
          print(post);
          userCollection.get().then((currentUser) {
            print(currentUser.exists);
            if(currentUser.exists) {
              final totalPosts = currentUser.get('totalPosts');
              userCollection.update({"totalPosts" : totalPosts -  1});
              toast('print deleted');
              return;
            }
          });

          this.deleteFileToStorage(fileUrl: post.postImageUrl ?? '');

        } );
    } catch (e) {
      toast('Eror deleted');
      print('DElete error post  ${e}');
    }
  }

  @override
  Future<void> likePost(PostEntity post) async {
    final postsCollection = firebaseFirestore.collection(FirebaseConst.posts);

    final currentUid = await getCurrentUid();

    final currentPost = await postsCollection.doc(post.postId).get();

    if (currentPost.exists) {
      List likes = currentPost.get("likes");
      final totalLikes = currentPost.get("totalLikes");
      if (likes.contains(currentUid)) {
        postsCollection.doc(post.postId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
          "totalLikes": totalLikes - 1
        }).catchError(() => print('Remove Likes post Eror'));
      } else {
        postsCollection.doc(post.postId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totalLikes": totalLikes + 1
        }).catchError((e) => print('Add likes post Erorr'));
      }
    }
  }

  @override
  Stream<List<PostEntity>> readPost(PostEntity post) {
    final postsCollection = firebaseFirestore.collection(FirebaseConst.posts);
    return postsCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostsModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts).orderBy("createAt", descending: true).where("postId", isEqualTo: postId);
    return postCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => PostsModel.fromSnapshot(e)).toList() );
  }


  @override
  Future<void> updatePost(PostEntity post) async {
    final postsCollection = firebaseFirestore.collection(FirebaseConst.posts);

    Map<String, dynamic> postInfo = Map();

    if (post.description != '' && post.description != null)
      postInfo['description'] = post.description;

    if (post.postImageUrl != '' && post.postImageUrl != null)
      postInfo['postImageUrl'] = post.postImageUrl;

    postsCollection.doc(post.postId).update(postInfo).then((value) {
      
    }).catchError((e) {
      print('Update Post error ${e}');

      toast('Post dont update');
    });
  }


  // COULD STORAGE
  @override
  Future<String> uploadImageToStorage(
      {File? file,
      required bool isPost,
      required String childName,
      Uint8List? imageWeb}) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);

    if (isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }

    final UploadTask uploadTask;

    if (kIsWeb) {
      uploadTask = ref.putData(
        imageWeb!,
        SettableMetadata(contentType: 'image/jpeg'),
      );
    } else {
      uploadTask = ref.putFile(file!);
    }

    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return await imageUrl;
  }

  @override
  Future<void> deleteFileToStorage({required String fileUrl}) async {
    if(fileUrl.isEmpty) return;
    try {
      firebaseStorage.refFromURL(fileUrl).delete();
    } catch (e) {
      print('DONT delete fileStorage $fileUrl');
    }
  }



  // COMMENT
  @override
  Future<void> createComment(CommentEntity comment) async {
    final commentCollection =
        firebaseFirestore.collection(FirebaseConst.posts).doc(comment.postId).collection(FirebaseConst.comment);

      final postCollection = firebaseFirestore.collection(FirebaseConst.posts);
    

    final commentModel = CommentModel(
            postId: comment.postId,
            creatorUid: comment.creatorUid,
            description: comment.description,
            userProfileUrl: comment.userProfileUrl,
            username: comment.username,
            likes: comment.likes,
            createAt: comment.createAt,
            commentId: comment.commentId,
            totalReplays: comment.totalReplays)
        .toJson();

    commentCollection.doc(comment.commentId).get().then((currentCommet)  {
      if(!currentCommet.exists) {
        commentCollection.doc(comment.commentId).set(commentModel).then((setCommet) {
            final postCollection = firebaseFirestore.collection(FirebaseConst.posts);
            postCollection.doc(comment.postId).get().then((post) {
              if(post.exists) {
                final totalComments = post.get('totalComments');
                postCollection.doc(comment.postId).update({
                  "totalComments": totalComments + 1 
                });
                return;
              }
            } );
        });
      }
    }).catchError((onError) {

    }); 
  }

  @override
  Future<void> deleteComment(CommentEntity comment) async {
    final commentCollection =
        firebaseFirestore.collection(FirebaseConst.posts).doc(comment.postId).collection(FirebaseConst.comment);

    try{
      commentCollection.doc(comment.commentId).delete();

      final postCollection = firebaseFirestore.collection(FirebaseConst.posts);
      postCollection.doc(comment.postId).get().then((post) {
        if(post.exists) {
          final totalComments = post.get('totalComments');
          postCollection.doc(comment.postId).update({
            "totalComments" : totalComments - 1
          });
        }
      });

    }catch (e) {
      toast('Dont delete comment');
    }
    
  }

  @override
  Future<void> likeComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore.collection(FirebaseConst.posts).doc(comment.postId).collection(FirebaseConst.comment);


    final currentUid = await getCurrentUid();

    final currentComment = await commentCollection.doc(comment.commentId).get();

    if (currentComment.exists) {
      List likes = currentComment.get("likes");
      if (likes.contains(currentUid)) {
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
        }).catchError(() => print('Remove Likes comment Eror'));
      } else {
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
        }).catchError((e) => print('Add likes comment Erorr'));
      }
    }
  }

  @override
  Stream<List<CommentEntity>> readComments(String postId) {
    final commentCollection =
        firebaseFirestore.collection(FirebaseConst.posts).doc(postId).collection(FirebaseConst.comment);

    return commentCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) =>    CommentModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateComment(CommentEntity comment) async {
    final commentCollection =
        firebaseFirestore.collection(FirebaseConst.posts).doc(comment.postId).collection(FirebaseConst.comment);

    Map<String, dynamic> commentInfo = Map();

    if (comment.description != '' && comment.description != null)
      commentInfo['description'] = comment.description;

    commentCollection.doc(comment.commentId).update(commentInfo).catchError((e) {
      toast('DONT UPDATE COMMENT');
    });

  }





  // ! REPLAY
    @override
  Future<void> createReplay(ReplayEntity replay) async {
    final replayCollection = firebaseFirestore.collection(FirebaseConst.posts).doc(replay.postId).collection(FirebaseConst.comment).doc(replay.commentId).collection(FirebaseConst.replay);

    final newReplay = ReplayModel(
        userProfileUrl: replay.userProfileUrl,
        username: replay.username,
        replayId: replay.replayId,
        commentId: replay.commentId,
        postId: replay.postId,
        likes: [],
        description: replay.description,
        creatorUid: replay.creatorUid,
        createAt: replay.createAt
    ).toJson();


    try {

      final replayDocRef = await replayCollection.doc(replay.replayId).get();

      if (!replayDocRef.exists) {
        replayCollection.doc(replay.replayId).set(newReplay).then((value) {
          final commentCollection = firebaseFirestore.collection(FirebaseConst.posts).doc(replay.postId).collection(FirebaseConst.comment).doc(replay.commentId);

          commentCollection.get().then((value) {
            if (value.exists) {
              final totalReplays = value.get('totalReplays');
              commentCollection.update({"totalReplays": totalReplays + 1});
              return;
            }
          });
        });
      } else {
        replayCollection.doc(replay.replayId).update(newReplay);
      }

    } catch (e) {
      print("some error occured $e");
    }

  }

  @override
  Future<void> deleteReplay(ReplayEntity replay) async {
    final replayCollection = firebaseFirestore.collection(FirebaseConst.posts).doc(replay.postId).collection(FirebaseConst.comment).doc(replay.commentId).collection(FirebaseConst.replay);

    try {
      replayCollection.doc(replay.replayId).delete().then((value) {
        final commentCollection = firebaseFirestore.collection(FirebaseConst.posts).doc(replay.postId).collection(FirebaseConst.comment).doc(replay.commentId);

        commentCollection.get().then((value) {
          if (value.exists) {
            final totalReplays = value.get('totalReplays');
            commentCollection.update({"totalReplays": totalReplays - 1});
            return;
          }
        });
      });
    } catch(e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> likeReplay(ReplayEntity replay) async {
    final replayCollection = firebaseFirestore.collection(FirebaseConst.posts).doc(replay.postId).collection(FirebaseConst.comment).doc(replay.commentId).collection(FirebaseConst.replay);

    final currentUid = await getCurrentUid();

    final replayRef = await replayCollection.doc(replay.replayId).get();

    if (replayRef.exists) {
      List likes = replayRef.get("likes");
      if (likes.contains(currentUid)) {
        replayCollection.doc(replay.replayId).update({
          "likes": FieldValue.arrayRemove([currentUid])
        });
      } else {
        replayCollection.doc(replay.replayId).update({
          "likes": FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<ReplayEntity>> readReplays(ReplayEntity replay) {
    final replayCollection = firebaseFirestore.collection(FirebaseConst.posts).doc(replay.postId).collection(FirebaseConst.comment).doc(replay.commentId).collection(FirebaseConst.replay);
    return replayCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => ReplayModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateReplay(ReplayEntity replay) async {
    final replayCollection = firebaseFirestore.collection(FirebaseConst.posts).doc(replay.postId).collection(FirebaseConst.comment).doc(replay.commentId).collection(FirebaseConst.replay);

    Map<String, dynamic> replayInfo = Map();

    if (replay.description != "" && replay.description != null) replayInfo['description'] = replay.description;

    replayCollection.doc(replay.replayId).update(replayInfo);
  }
}
