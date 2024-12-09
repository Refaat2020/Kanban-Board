import 'package:kanban_board/file_export.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({required this.commentContent, super.key});
  final String commentContent;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            8,
          ),
        ),
        color: context.theme.cardColor,
        border: Border.all(color: AppColors.emptyBarColor),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(9, 30, 66, 0).withOpacity(.5),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Text(
        commentContent,
        style: context.textTheme.bodyLarge,
      ),
    );
  }
}
