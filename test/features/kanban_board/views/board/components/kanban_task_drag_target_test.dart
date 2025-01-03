import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/kanban_board/views/board/components/kanban_task_card.dart';
import 'package:kanban_board/features/kanban_board/views/board/components/kanban_task_drag_target.dart';

void main() {
  group(
    'Kanban task drag target Tests',
    () {
      final List<Task> tasks = [];
      final columnId = 0;

      testWidgets(
        'renders DragTarget check the widget type',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: KanbanTaskDragTarget(
                  tasks: tasks,
                  columnId: columnId,
                ),
              ),
            ),
          );

          //verify the widget type
          expect(find.byType(DragTarget<Task>), findsOneWidget);
        },
      );

      testWidgets(
        'renders Draggable check the text',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: KanbanTaskDragTarget(
                  tasks: tasks,
                  columnId: columnId,
                ),
              ),
            ),
          );

          expect(find.byType(KanbanTaskCard), findsNWidgets(tasks.length));
        },
      );
    },
  );
}
