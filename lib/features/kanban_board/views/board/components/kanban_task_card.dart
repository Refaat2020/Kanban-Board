import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/task_management/views/view_task/view_task_screen.dart';
import 'package:kanban_board/file_export.dart';

class KanbanTaskCard extends StatelessWidget {
  final Task task;

  const KanbanTaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Draggable<Task>(
      data: task,
      feedback: Material(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            color: context.theme.cardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(task.content ?? ""),
          ),
        ),
      ),
      child: InkWell(
        onTap: () => GoRouter.of(context)
            .pushNamed(ViewTaskScreen.routeName, extra: task),
        child: Container(
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
            ],
          ),
        ),
      ),
    );
  }
}
