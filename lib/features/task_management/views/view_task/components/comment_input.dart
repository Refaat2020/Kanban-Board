import 'package:kanban_board/common/widgets/regular_text_field.dart';
import 'package:kanban_board/file_export.dart';

class CommentInput extends StatelessWidget {
  const CommentInput({this.onSaved, this.textEditingController, super.key});
  final String Function(String?)? onSaved;
  final TextEditingController? textEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Comment", style: context.textTheme.bodyLarge),
        const SizedBox(height: 10),
        RegularTextField(
          labelColor: AppColors.white,
          hintText: "Enter a comment",
          controller: textEditingController,
          description: true,
          enableBorderColor: context.theme.dividerColor,
          onSaved: onSaved,
        ),
      ],
    );
  }
}
