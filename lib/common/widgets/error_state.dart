import 'package:flutter/material.dart';
import 'package:kanban_board/core/constants/app_colors.dart';
import 'package:kanban_board/core/extensions/theme_extensions.dart';

class ErrorState extends StatelessWidget {
  const ErrorState(this.errorText, {super.key});
  final String errorText;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        errorText,
        style: context.textTheme.titleLarge?.copyWith(color: AppColors.red1),
      ),
    );
  }
}
