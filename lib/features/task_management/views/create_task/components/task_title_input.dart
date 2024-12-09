import 'package:kanban_board/common/widgets/regular_text_field.dart';
import 'package:kanban_board/file_export.dart';

class TaskTitleInput extends StatelessWidget {
  const TaskTitleInput({this.onSaved, this.textEditingController, super.key});
  final String Function(String?)? onSaved;
  final TextEditingController? textEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Task Title", style: context.textTheme.bodyLarge),
        const SizedBox(height: 10),
        RegularTextField(
          labelColor: AppColors.white,
          controller: textEditingController,
          hintText: "Enter Task Title",
          enableBorderColor: context.theme.dividerColor,
          validator: (value) {
            if ((value ?? "").isEmpty) {
              return "Please enter valid title";
            }
            return null;
          },
          onSaved: onSaved,
        ),
      ],
    );
  }
}
