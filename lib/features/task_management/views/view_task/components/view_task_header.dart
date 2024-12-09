import 'package:kanban_board/file_export.dart';

class ViewTaskHeader extends StatelessWidget {
  const ViewTaskHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Task Details",
          style: context.theme.textTheme.titleLarge,
        ),
        Spacer(),
        TextButton(
          onPressed: () => GoRouter.of(context).pop(),
          child: Text(
            "Cancel",
            style:
                context.textTheme.titleLarge?.copyWith(color: AppColors.red1),
          ),
        )
      ],
    );
  }
}
