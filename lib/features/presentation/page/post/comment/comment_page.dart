import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/consts.dart';
import 'package:insta_clone/features/domain/entities/app_entity.dart';
import 'package:insta_clone/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:insta_clone/features/presentation/cubit/post/get_single_post/get_single_post_cubit.dart';
import 'package:insta_clone/features/presentation/cubit/post/post_cubit.dart';
import 'package:insta_clone/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:insta_clone/features/presentation/page/post/comment/widgets/comment_main_widget.dart';

import '../../../widgets/form_container_widget.dart';

import 'package:insta_clone/injection_container.dart' as di;


class CommentPage extends StatelessWidget {
  final AppEntity appEntity;

  const CommentPage({Key? key, required this.appEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommentCubit>(
          create: (context) => di.sl<CommentCubit>(),
        ),
        BlocProvider<GetSingleUserCubit>(
          create: (context) => di.sl<GetSingleUserCubit>(),
        ),

        BlocProvider<GetSinglePostCubit>(
          create: (context) => di.sl<GetSinglePostCubit>(),
        ),
      ],
      child: CommentMainWidget(appEntity: appEntity),
    );
  }
}