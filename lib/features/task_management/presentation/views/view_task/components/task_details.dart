import 'package:kanban_board/core/constants/app_strings.dart';
import 'package:kanban_board/features/task_management/presentation/views/view_task/components/task_timer.dart';
import 'package:kanban_board/file_export.dart';

import '../../../../../kanban_board/domain/entities/task.dart';
import '../../../cubit/task_management_cubit.dart';
import '../../../cubit/timer_cubit.dart';
import '../../create_task/components/task_description_input.dart';
import '../../create_task/components/task_title_input.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({
    required this.titleController,
    required this.descriptionController,
    required this.task,
    required this.taskFormKey,
    super.key,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final Task task;
  final GlobalKey<FormState> taskFormKey;

  @override
  Widget build(BuildContext context) {
    final taskManagementCubit = context.read<TaskManagementCubit>();
    return Form(
      key: taskFormKey,
      child: Column(
        children: [
          const SizedBox(height: 16),
          TaskTitleInput(textEditingController: titleController),
          const SizedBox(height: 16),
          TaskDescriptionInput(textEditingController: descriptionController),
          const SizedBox(height: 30),
          BlocProvider(
            create: (context) => TimerCubit(),
            child: TaskTimer(
              onTimeElapsed: (duration) =>
                  taskManagementCubit.taskDuration = duration.inMinutes,
            ),
          ),
          const SizedBox(height: 30),
          BlocBuilder<TaskManagementCubit, TaskManagementState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () => state is TaskManagementLoading
                    ? null
                    : _onUpdateTask(taskManagementCubit, task),
                child: Text(
                  AppStrings.update,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.purple3,
                  ),
                ),
              );
            },
          ),
          const Divider(height: 20),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _onUpdateTask(TaskManagementCubit cubit, Task task) async {
    if (taskFormKey.currentState!.validate()) {
      taskFormKey.currentState!.save();
      final duration = (task.duration?.amount ?? 0) + (cubit.taskDuration ?? 0);

      task = task.copyWith(
        content: titleController.text,
        description: descriptionController.text,
        durationInMinutes: duration == 0 ? null : duration,
        durationUnit: duration == 0 ? null : 'minute',
      );
      await cubit.updateTask(task);
    }
  }
}
