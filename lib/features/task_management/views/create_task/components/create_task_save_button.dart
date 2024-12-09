import 'package:kanban_board/features/kanban_board/views/board/board_screen.dart';
import 'package:kanban_board/features/task_management/domain/cubit/task_management_cubit.dart';
import 'package:kanban_board/file_export.dart';

class CreateTaskSaveButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function(TaskManagementCubit) onPressed;

  const CreateTaskSaveButton({
    super.key,
    required this.formKey,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskManagementCubit, TaskManagementState>(
      listener: (context, state) {
        if (state is TaskManagementDone) {
          GoRouter.of(context).pushReplacementNamed(BoardScreen.routeName);
        }
      },
      builder: (context, state) {
        return FloatingActionButton(
          onPressed: () => onPressed(context.read<TaskManagementCubit>()),
          shape: const CircleBorder(),
          backgroundColor:
              state is TaskManagementLoading ? AppColors.orangeMute : null,
          child: Icon(
            state is TaskManagementLoading
                ? Icons.alarm
                : Icons.done_outline_outlined,
          ),
        );
      },
    );
  }
}
