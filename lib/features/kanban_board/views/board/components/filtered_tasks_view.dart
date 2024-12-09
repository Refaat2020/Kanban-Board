import 'package:kanban_board/features/kanban_board/data/models/kanban_column_data.dart';
import 'package:kanban_board/features/kanban_board/views/board/components/kanban_column.dart';
import 'package:kanban_board/file_export.dart';

class FilteredTasksView extends StatelessWidget {
  final List<KanbanColumnData> filteredTasks;
  const FilteredTasksView({required this.filteredTasks, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: filteredTasks.map(
          (columnData) {
            return KanbanColumn(kanbanColumnData: columnData);
          },
        ).toList(),
      ),
    );
  }
}
