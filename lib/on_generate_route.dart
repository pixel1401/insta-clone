import 'package:flutter/material.dart';
import 'package:insta_clone/consts.dart';
import 'package:insta_clone/features/domain/entities/app_entity.dart';
import 'package:insta_clone/features/domain/entities/posts/posts_entity.dart';
import 'package:insta_clone/features/domain/entities/user/user_entity.dart';
import 'package:insta_clone/features/presentation/page/post/upload_post_page.dart';

import 'features/presentation/page/credential/sign_in_page.dart';
import 'features/presentation/page/credential/sign_up_page.dart';
import 'features/presentation/page/post/comment/comment_page.dart';
import 'features/presentation/page/post/update_post_page.dart';
import 'features/presentation/page/profile/edit_profile_page.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments ;

    switch (settings.name) {
      case PageConst.editProfilePage:
        {
          if (args is UserEntity) {
            return routeBuilder(EditProfilePage(userEntity: args));
          } else {
            return routeBuilder(NoPageFound());
          }
        }
      case PageConst.updatePostPage:
        {
          return routeBuilder(UpdatePostPage());
        }
       case PageConst.uploadPostPage:
        {
          final arguments = args as Map;
           if (args['post'] is PostEntity) {
            return routeBuilder(UploadPostPage(user: args['user'] ?? null , postUpdate  : args['post'] ?? null ));
          } else {
            return routeBuilder(NoPageFound());
          }
        } 
      case PageConst.commentPage:

        {
          if(args is AppEntity) {
            return routeBuilder(CommentPage(appEntity: args,));
          }else {
            return routeBuilder(NoPageFound());
          }
        }
      case PageConst.signInPage:
        {
          return routeBuilder(SignInPage());
        }
      case PageConst.signInPage:
        {
          return routeBuilder(SignInPage());
        }
      case PageConst.signUpPage:
        {
          return routeBuilder(SignUpPage());
        }
      default:
        {
          NoPageFound();
        }
    }
  }
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page not found"),
      ),
      body: Center(
        child: Text("Page not found"),
      ),
    );
  }
}
