import 'package:kanban_board/common/widgets/empty_state_widget.dart';
import 'package:kanban_board/common/widgets/error_state.dart';
import 'package:kanban_board/common/widgets/loading_state.dart';
import 'package:kanban_board/core/constants/app_strings.dart';
import 'package:kanban_board/features/task_management/data/models/comment.dart';
import 'package:kanban_board/features/task_management/domain/cubit/comment_cubit.dart';
import 'package:kanban_board/features/task_management/views/view_task/components/comment_card.dart';
import 'package:kanban_board/features/task_management/views/view_task/components/comment_input.dart';
import 'package:kanban_board/file_export.dart';

class CommentsSection extends StatelessWidget {
  final TextEditingController commentController;
  final String taskId;

  const CommentsSection(
      {required this.commentController, required this.taskId, super.key});

  @override
  Widget build(BuildContext context) {
    final commentCubit = context.watch<CommentCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.comments,
          style: context.textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 30,
        ),
        CommentInput(
          textEditingController: commentController,
        ),
        const SizedBox(
          height: 16,
        ),
        Center(
          child: ElevatedButton(
            onPressed: () => _onCreateComment(commentCubit, taskId),
            child: Text(
              AppStrings.addComment,
              style: context.textTheme.bodyLarge?.copyWith(
                color: AppColors.purple3,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          AppStrings.allComments,
          style: context.textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 16,
        ),
        BlocBuilder<CommentCubit, CommentState>(
          builder: (context, state) {
            if (state is CommentLoading) {
              return const LoadingState();
            } else if (state is CommentError) {
              return ErrorState(
                state.errorMessage ?? '',
              );
            } else if (state is CommentsEmpty) {
              return EmptyStateWidget(
                message: Text(
                  AppStrings.noCommentsFound,
                  style: context.textTheme.bodyLarge,
                ),
              );
            }
            return SizedBox(
              height: MediaQuery.sizeOf(context).height / 3,
              child: ListView.builder(
                itemCount: commentCubit.listOfComments.length,
                itemBuilder: (context, index) {
                  final comment = commentCubit.listOfComments[index].content;
                  return CommentCard(
                    commentContent: comment ?? "",
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }

  void _onCreateComment(CommentCubit cubit, String taskID) async {
    if (commentController.text.isNotEmpty) {
      final comment = Comment(
        taskId: taskID,
        content: commentController.text,
      );
      await cubit.addComment(comment);
      commentController.clear();
    }
  }
}
