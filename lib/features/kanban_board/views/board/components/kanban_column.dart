import 'package:kanban_board/features/kanban_board/data/models/kanban_column_data.dart';
import 'package:kanban_board/features/kanban_board/views/board/components/kanban_task_drag_target.dart';
import 'package:kanban_board/file_export.dart';

class KanbanColumn extends StatelessWidget {
  final KanbanColumnData kanbanColumnData;

  const KanbanColumn({
    super.key,
    required this.kanbanColumnData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width / 1.7,
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: kanbanColumnData.columnColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Text(
              kanbanColumnData.columnName,
              style: context.textTheme.titleLarge,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: KanbanTaskDragTarget(
              columnId: kanbanColumnData.columnId,
              tasks: kanbanColumnData.tasks,
            ),
          )
        ],
      ),
    );
  }
}
