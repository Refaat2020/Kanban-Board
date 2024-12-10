import 'package:kanban_board/common/widgets/empty_state_widget.dart';
import 'package:kanban_board/core/constants/app_strings.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/task_management/views/completed_task/components/completed_task_card.dart';
import 'package:kanban_board/features/task_management/views/completed_task/components/completed_tasks_header.dart';
import 'package:kanban_board/file_export.dart';

class HistoryScreen extends StatelessWidget {
  static const routePath = "/HistoryScreen";
  static const routeName = "/HistoryScreen";
  const HistoryScreen(this.completedTasks, {super.key});
  final List<Task> completedTasks;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Column(
          children: [
            CompletedTasksHeader(),
            completedTasks.isNotEmpty
                ? ListView.builder(
                    itemCount: completedTasks.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final task = completedTasks[index];
                      return CompletedTaskCard(
                        task: task,
                      );
                    },
                  )
                : EmptyStateWidget(
                    message: Text(
                      AppStrings.noTasksFound,
                      style: context.textTheme.titleLarge,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
