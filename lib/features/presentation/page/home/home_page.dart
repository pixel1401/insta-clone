import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/consts.dart';
import 'package:insta_clone/features/domain/entities/posts/posts_entity.dart';
import 'package:insta_clone/features/presentation/cubit/post/post_cubit.dart';
import 'package:insta_clone/features/presentation/page/home/widgets/single_post_card_widget.dart';
import 'package:insta_clone/features/presentation/page/post/comment/comment_page.dart';
import 'package:insta_clone/features/presentation/page/post/update_post_page.dart';
import 'package:insta_clone/injection_container.dart' as di;


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: SvgPicture.asset(
          "assets/ic_instagram.svg",
          color: primaryColor,
          height: 32,
        ),
        actions: [
          
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(
              Icons.messenger_outline_outlined,
              color: primaryColor,
            ),
          )
        ],
      ),
      body: BlocProvider(
        create: (BuildContext context) => di.sl<PostCubit>()..getPosts(post: PostEntity()),
        child: BlocBuilder<PostCubit, PostState>(
           builder: (context, postState) {
            if (postState is PostLoading) {
              return Center(child: CircularProgressIndicator(),);
            }
            if (postState is PostFailure) {
              toast("Some Failure occured while creating the post");
            }
            if (postState is PostLoaded) {
              return postState.posts.isEmpty? _noPostsYetWidget() : ListView.builder(
                itemCount: postState.posts.length,
                itemBuilder: (context, index) {
                  final post = postState.posts[index];
                  return BlocProvider(
                    create: (context) => di.sl<PostCubit>(),
                    child: SinglePostCardWidget(post: post ),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator(),);
          },
          ),
        )
    );
  }
}
_noPostsYetWidget() {
    return Center(child: Text("No Posts Yet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),);
  }