part of 'comment_cubit.dart';

abstract class CommentState extends Equatable {
  const CommentState();
}

class CommentInitial extends CommentState {
  @override
  List<Object> get props => [];
}

class CommentLoading extends CommentState {
  @override
  List<Object> get props => [];
}

class CommentSuccess extends CommentState {
  final List<CommentEntity> comments;
  CommentSuccess({required this.comments });
  @override
  List<Object> get props => [comments]; 
}

class CommentFailure extends CommentState {
  @override
  List<Object> get props => [];
}
