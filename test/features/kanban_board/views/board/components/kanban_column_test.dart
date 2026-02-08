import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/features/kanban_board/data/models/kanban_column_data.dart';
import 'package:kanban_board/features/kanban_board/domain/entities/task.dart';
import 'package:kanban_board/features/kanban_board/presentation/views/board/components/kanban_column.dart';
import 'package:kanban_board/features/kanban_board/presentation/views/board/components/kanban_task_drag_target.dart';

void main() {
  group(
    'KanbanColumn Widget Tests',
    () {
      final dummyKanbanColumnData = KanbanColumnData(
        columnId: 1,
        columnName: 'To Do',
        columnColor: Colors.blue,
        tasks: [
          Task(id: 'task1', content: 'Task 1'),
          Task(id: 'task2', content: 'Task 2'),
        ],
      );

      testWidgets(
        'renders correctly with provided data',
        (WidgetTester tester) async {
          // Build the KanbanColumn widget
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: KanbanColumn(kanbanColumnData: dummyKanbanColumnData),
              ),
            ),
          );

          expect(find.text('To Do'), findsOneWidget);
          final container = tester.widget<Container>(find
              .descendant(
                  of: find.byType(Container), matching: find.byType(Container))
              .first);
          expect((container.decoration as BoxDecoration).color, Colors.blue);

          expect(find.byType(KanbanTaskDragTarget), findsOneWidget);
        },
      );

      testWidgets(
        'handles empty tasks gracefully',
        (WidgetTester tester) async {
          final emptyColumnData = KanbanColumnData(
            columnId: 2,
            columnName: 'Empty Column',
            columnColor: Colors.green,
            tasks: [],
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: KanbanColumn(kanbanColumnData: emptyColumnData),
              ),
            ),
          );

          expect(find.text('Empty Column'), findsOneWidget);

          expect(find.byType(KanbanTaskDragTarget), findsOneWidget);
        },
      );
    },
  );
}
