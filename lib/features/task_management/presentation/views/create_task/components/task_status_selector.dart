import 'package:kanban_board/core/constants/app_strings.dart';
import 'package:kanban_board/file_export.dart';

import '../../../../../kanban_board/domain/entities/task.dart';
import '../../../cubit/task_management_cubit.dart';

class TaskStatusSelector extends StatelessWidget {
  const TaskStatusSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final taskStatus = context.watch<TaskManagementCubit>();
    return Row(
      children: [
        Text(AppStrings.status, style: context.textTheme.bodyLarge),
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
