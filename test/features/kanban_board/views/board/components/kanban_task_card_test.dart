import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';
import 'package:kanban_board/features/kanban_board/views/board/components/kanban_task_card.dart';

void main() {
  group(
    'Kanban task card Widget Tests',
    () {
      final task = Task(
        id: '1',
        description: 'description',
        content: 'test',
      );

      testWidgets(
        'renders Draggable check the widget type',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: KanbanTaskCard(
                  task: task,
                ),
              ),
            ),
          );
          final draggableFinder = find.byType(Draggable<Task>);

          final draggableWidget =
              tester.widget<Draggable<Task>>(draggableFinder);
          final taskObject = draggableWidget.data as Task;
          //verify the type of object
          expect(taskObject, isA<Task>());
          //verify the description
          expect(find.text('description'), findsOneWidget);
          //verify the widget type
          expect(find.byType(Draggable<Task>), findsOneWidget);
        },
      );

      testWidgets(
        'renders Draggable check the text',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: KanbanTaskCard(
                  task: task,
                ),
              ),
            ),
          );

          //verify the description
          expect(find.text('description'), findsOneWidget);
          expect(find.text('test'), findsOneWidget);
        },
      );

      testWidgets(
        'renders Draggable data type',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: KanbanTaskCard(
                  task: task,
                ),
              ),
            ),
          );
          final draggableFinder = find.byType(Draggable<Task>);

          final draggableWidget =
              tester.widget<Draggable<Task>>(draggableFinder);
          final taskObject = draggableWidget.data as Task;
          //verify the type of object
          expect(taskObject, isA<Task>());
        },
      );
    },
  );
}
