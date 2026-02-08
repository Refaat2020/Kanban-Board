
import 'package:kanban_board/file_export.dart';

import '../../../../kanban_board/domain/entities/task.dart';
import '../../cubit/comment_cubit.dart';
import 'components/comments_section.dart';
import 'components/task_details.dart';
import 'components/view_task_header.dart';

class ViewTaskScreen extends StatefulWidget {
  const ViewTaskScreen({required this.task, super.key});

  static const routePath = "/ViewTaskScreen";
  static const routeName = "/ViewTaskScreen";
  final Task task;

  @override
  State<ViewTaskScreen> createState() => _ViewTaskScreenState();
}

class _ViewTaskScreenState extends State<ViewTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController commentController;
  late final GlobalKey<FormState> taskFormKey;
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.content ?? '');
    descriptionController =
        TextEditingController(text: widget.task.description ?? '');
    commentController = TextEditingController();
    taskFormKey = GlobalKey<FormState>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommentCubit>().fetchComments(widget.task.id ?? "");
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ViewTaskHeader(),
            TaskDetails(
              titleController: titleController,
              descriptionController: descriptionController,
              task: widget.task,
              taskFormKey: taskFormKey,
            ),
            CommentsSection(
              commentController: commentController,
              taskId: widget.task.id ?? "",
            )
          ],
        ),
      ),
    );
  }
}
