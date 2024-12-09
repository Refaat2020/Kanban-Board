import 'package:kanban_board/core/constants/app_keys.dart';
import 'package:kanban_board/core/services/preference_storage.dart';
import 'package:kanban_board/core/services/service_locator.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/task_management/domain/cubit/task_management_cubit.dart';
import 'package:kanban_board/features/task_management/views/create_task/components/create_task_header.dart';
import 'package:kanban_board/features/task_management/views/create_task/components/create_task_save_button.dart';
import 'package:kanban_board/features/task_management/views/create_task/components/task_description_input.dart';
import 'package:kanban_board/features/task_management/views/create_task/components/task_status_selector.dart';
import 'package:kanban_board/features/task_management/views/create_task/components/task_title_input.dart';
import 'package:kanban_board/file_export.dart';

class CreateTaskScreen extends StatefulWidget {
  static const routePath = "/CreateTaskScreen";
  static const routeName = "/CreateTaskScreen";

  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    final taskManagerCubit = context.watch<TaskManagementCubit>();
    return Scaffold(
      floatingActionButton: CreateTaskSaveButton(
        formKey: formKey,
        onPressed: _onSaveTask,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //header
              const CreateTaskHeader(),
              const SizedBox(height: 20),
              TaskTitleInput(
                onSaved: (title) {
                  return taskManagerCubit.taskTitle = title!;
                },
              ),
              const SizedBox(height: 16),
              TaskDescriptionInput(
                onSaved: (description) {
                  return taskManagerCubit.taskContent = description!;
                },
              ),
              const SizedBox(height: 16),
              const TaskStatusSelector(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _onSaveTask(TaskManagementCubit cubit) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final projectId =
          locator<PreferenceStorage>().getString(AppKeys.defaultProjectKey);

      final taskData = Task(
        projectId: projectId,
        content: cubit.taskTitle,
        description: cubit.taskContent,
        priority: cubit.selectedStatus.index + 1,
      );

      await cubit.createTask(taskData);
    }
  }
}
