import 'package:kanban_board/core/constants/app_keys.dart';
import 'package:kanban_board/core/services/preference_storage.dart';
import 'package:kanban_board/core/services/service_locator.dart';
import 'package:kanban_board/features/kanban_board/data/models/task_model.dart';
import 'package:kanban_board/file_export.dart';
import 'package:uuid/v4.dart';

import '../../cubit/task_management_cubit.dart';
import 'components/create_task_header.dart';
import 'components/create_task_save_button.dart';
import 'components/task_description_input.dart';
import 'components/task_status_selector.dart';
import 'components/task_title_input.dart';

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
      final projectId = locator<PreferenceStorage>().getString(
        AppKeys.defaultProjectKey,
      );

      final taskData = TaskModel(
        projectId: projectId,
        content: cubit.taskTitle,
        description: cubit.taskContent,
        priority: cubit.selectedStatus.index + 1,
        labels: [UuidV4().generate()],
      );

      await cubit.createTask(taskData);
    }
  }
}
