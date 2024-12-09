import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/task_management/domain/cubit/task_management_cubit.dart';
import 'package:kanban_board/file_export.dart';

class TaskStatusSelector extends StatelessWidget {
  const TaskStatusSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final taskStatus = context.watch<TaskManagementCubit>();
    return Row(
      children: [
        Text("Status:", style: context.textTheme.bodyLarge),
        const SizedBox(width: 16),
        DropdownButton<TaskStatus>(
          value: taskStatus.selectedStatus,
          items: TaskStatus.values.map((status) {
            return DropdownMenuItem<TaskStatus>(
              value: status,
              child: Text(status.name),
            );
          }).toList(),
          onChanged: (newStatus) {
            taskStatus.selectTaskStatus(newStatus!);
          },
        ),
      ],
    );
  }
}
