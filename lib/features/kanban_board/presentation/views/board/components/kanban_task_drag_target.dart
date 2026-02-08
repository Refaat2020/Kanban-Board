import 'package:kanban_board/file_export.dart';

import '../../../../../task_management/presentation/cubit/task_management_cubit.dart';
import '../../../../domain/entities/task.dart';
import 'kanban_task_card.dart';

class KanbanTaskDragTarget extends StatelessWidget {
  final int columnId;
  final List<Task> tasks;
  const KanbanTaskDragTarget({
    super.key,
    required this.columnId,
    required this.tasks,
  });
  @override
  Widget build(BuildContext context) {
    return DragTarget<Task>(
      onAcceptWithDetails: (details) {
        _handleTaskDrop(context, details.data);
      },
      builder: (context, candidateData, rejectedData) {
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return KanbanTaskCard(task: tasks[index]);
          },
        );
      },
    );
  }

  void _handleTaskDrop(BuildContext context, Task task) async {
    final cubit = context.read<TaskManagementCubit>();
    try {
      final bool isCompleted = columnId == 3 ? true : false;
      task = task.copyWith(priority: columnId, isCompleted: isCompleted);
      await cubit.updateTask(task);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to move task: $e')));
    }
  }
}
