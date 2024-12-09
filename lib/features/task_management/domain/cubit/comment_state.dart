part of 'comment_cubit.dart';

@immutable
abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentsEmpty extends CommentState {}

class CommentLoaded extends CommentState {}

class CommentAdding extends CommentState {}

class CommentError extends CommentState {
  final String? errorMessage;

  CommentError({this.errorMessage});
}
