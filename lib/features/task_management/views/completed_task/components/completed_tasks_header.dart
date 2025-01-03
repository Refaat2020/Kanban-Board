import 'package:kanban_board/core/constants/app_strings.dart';
import 'package:kanban_board/file_export.dart';

class CompletedTasksHeader extends StatelessWidget {
  const CompletedTasksHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppStrings.completedTask,
          style: context.theme.textTheme.titleLarge,
        ),
        Spacer(),
        TextButton(
          onPressed: () => GoRouter.of(context).pop(),
          child: Text(
            AppStrings.cancel,
            style:
                context.textTheme.titleLarge?.copyWith(color: AppColors.red1),
          ),
        )
      ],
    );
  }
}
