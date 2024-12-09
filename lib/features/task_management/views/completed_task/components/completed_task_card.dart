import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/file_export.dart';

class CompletedTaskCard extends StatelessWidget {
  const CompletedTaskCard({required this.task, super.key});
  final Task task;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //title
          Text(
            task.content ?? "",
            style: context.textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 16,
          ),
          //description
          if ((task.description ?? "").isNotEmpty)
            Text(
              task.description!,
              style: context.textTheme.bodyMedium,
            ),
          const SizedBox(
            height: 16,
          ),
          if (task.duration != null)
            Text(
              "Time Spent :${task.duration!.amount} Minutes",
              style: context.textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }
}
