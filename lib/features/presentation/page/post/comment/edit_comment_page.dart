import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:insta_clone/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:insta_clone/injection_container.dart' as di;

import 'widgets/edit_comment_main_widget.dart';

class EditCommentPage extends StatelessWidget {
  final CommentEntity comment;

  const EditCommentPage({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentCubit>(
      create: (context) => di.sl<CommentCubit>(),
      child: EditCommentMainWidget(comment: comment),
    );
  }
}