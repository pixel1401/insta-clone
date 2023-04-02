

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/consts.dart';
import 'package:insta_clone/features/domain/entities/app_entity.dart';
import 'package:insta_clone/features/domain/entities/posts/posts_entity.dart';
import 'package:insta_clone/features/domain/entities/user/user_entity.dart';
import 'package:insta_clone/features/domain/usecases/firebase_usecases/user/get_current_uid_user_usecase.dart';
import 'package:insta_clone/features/presentation/cubit/post/post_cubit.dart';
import 'package:insta_clone/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:insta_clone/features/presentation/cubit/user/user_cubit.dart';
import 'package:insta_clone/features/presentation/page/post/widgets/like_animation_widget.dart';
import 'package:insta_clone/features/presentation/widgets/profile_widget.dart';
import 'package:insta_clone/injection_container.dart' as di;
import 'package:intl/intl.dart';

class SinglePostCardWidget extends StatefulWidget {
  final PostEntity post;
  const SinglePostCardWidget({Key? key, required this.post }) : super(key: key);

  @override
  State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
}

class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {

  String _currentUid = "";

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  bool _isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child:
                        profileWidget(imageUrl: widget.post.userProfileUrl ),
                  ),
                    ),
                    sizeHor(10),
                    Text(
                      widget.post.username ?? '',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                if(widget.post.creatorUid == _currentUid)  GestureDetector(
                    onTap: ()  {
                      _openBottomModalSheet(context, widget.post);
                    }
                    ,
                    child: Icon(
                      Icons.more_vert,
                      color: primaryColor,
                    ))
              ],
            ),
            sizeVer(10),
            GestureDetector(
              onDoubleTap: () {
                _likePost();
                setState(() {
                  _isLikeAnimating = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: 
                  [
                    Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.30,
                    color: secondaryColor,
                    child:profileWidget(imageUrl: widget.post.postImageUrl),
                  ),
                  AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: _isLikeAnimating? 1 : 0,
                      child: LikeAnimationWidget(
                       duration: Duration(milliseconds: 200),
                      isLikeAnimating: _isLikeAnimating,
                      onLikeFinish: () {
                         setState(() {
                           _isLikeAnimating = false;
                         });
                      },
                      child: Icon(Icons.favorite, size: 100, color: Colors.red,)),
                    )
                ],
              ),
            ),
            sizeVer(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    GestureDetector(onTap: _likePost,child: Icon(widget.post.likes!.contains(_currentUid)?Icons.favorite : Icons.favorite_outline, color: widget.post.likes!.contains(_currentUid)? Colors.red : primaryColor,)),
                    sizeHor(10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PageConst.commentPage , arguments: AppEntity(uid: _currentUid, postId: widget.post.postId , postEntity: widget.post ));
                      },
                      child: Icon(
                        Icons.message,
                        color: primaryColor,
                      ),
                    ),
                    sizeHor(10),
                    GestureDetector(
                      onTap: () {
                        
                      },
                      child: Icon(
                        Icons.send,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.bookmark_border,
                  color: primaryColor,
                )
              ],
            ),
            sizeVer(10),
                Text('${widget.post.totalLikes} likes' , style: TextStyle(color: primaryColor , fontWeight: FontWeight.bold),),
            sizeVer(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.post.username ?? "Username",
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
                sizeHor(10),
                Text(
                  widget.post.description ?? "some description",
                  style: TextStyle(color: primaryColor),
                ),
              ],
            ),
            sizeVer(10),
            GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PageConst.commentPage , arguments: AppEntity(uid: _currentUid, postId: widget.post.postId , postEntity: widget.post ));
                  // Navigator.push(context,MaterialPageRoute(builder: (context) => CommentPage()));
                },
                child: Text(
                  "View all ${widget.post.totalComments} comments",
                  style: TextStyle(color: darkGreyColor),
                )),
            sizeVer(10),
            Text(
                DateFormat('dd/MMM/yyy').format(widget.post.createAt!.toDate()) ,
              style: TextStyle(color: darkGreyColor),
            ),
          ],
        ),
      );
  }

  _openBottomModalSheet(BuildContext context, PostEntity post) {
    return showModalBottomSheet(context: context, builder: (context) {
      return Container(
            height: 150,
            decoration: BoxDecoration(color: backGroundColor.withOpacity(.8)),
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "More Options",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      thickness: 1,
                      color: secondaryColor,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: _deletePost,
                        child: Text(
                          "Delete Post",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: primaryColor),
                        ),
                      ),
                    ),
                    sizeVer(7),
                    Divider(
                      thickness: 1,
                      color: secondaryColor,
                    ),
                    sizeVer(7),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, PageConst.uploadPostPage, arguments: {'post' : widget.post , 'user' : context.read<GetSingleUserCubit>().state.user });

                          // Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePostPage()));

                        },
                        child: Text(
                          "Update Post",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: primaryColor),
                        ),
                      ),
                    ),
                    sizeVer(7),
                  ],
                ),
              ),
            ),
          );
    });
  }

  _deletePost() {
    BlocProvider.of<PostCubit>(context).deletePost(post: widget.post);
  }

  _likePost() {
    BlocProvider.of<PostCubit>(context).likePost(post: PostEntity(
      postId: widget.post.postId
    ));
  }
}