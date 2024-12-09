import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/kanban_board/views/board/components/kanban_task_card.dart';
import 'package:kanban_board/features/task_management/domain/cubit/task_management_cubit.dart';
import 'package:kanban_board/file_export.dart';

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
      final updatedTask =
          Task(id: task.id, priority: columnId, isCompleted: isCompleted);
      await cubit.updateTask(updatedTask);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to move task: $e')),
      );
    }
  }
}
