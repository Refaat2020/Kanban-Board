import 'package:kanban_board/core/constants/app_strings.dart';
import 'package:kanban_board/file_export.dart';

class CreateTaskHeader extends StatelessWidget {
  const CreateTaskHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppStrings.addTask,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: AppColors.purple3,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => GoRouter.of(context).pop(),
          child: Text(
            AppStrings.cancel,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.red1,
            ),
          ),
        ),
      ],
    );
  }
}
