import 'package:kanban_board/file_export.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key, required this.message, this.imageHeight});

  final Widget message;
  final double? imageHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.pageview_rounded,
            size: 30,
          ),
          SizedBox(height: 30),
          message,
        ],
      ),
    );
  }
}
