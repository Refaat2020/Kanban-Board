import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/features/kanban_board/data/models/kanban_column_data.dart';
import 'package:kanban_board/features/kanban_board/presentation/views/board/components/filtered_tasks_view.dart';
import 'package:kanban_board/features/kanban_board/presentation/views/board/components/kanban_column.dart';

void main() {
  group(
    'FilteredTasksView Widget Tests',
    () {
      final filteredTasks = [
        KanbanColumnData(
          columnId: 1,
          columnName: 'TO DO',
          columnColor: Colors.blue,
          tasks: [],
        ),
        KanbanColumnData(
          columnId: 2,
          columnName: 'In-Progress',
          columnColor: Colors.redAccent,
          tasks: [],
        ),
      ];

      testWidgets(
        'renders correctly with provided data',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: FilteredTasksView(
                  filteredTasks: filteredTasks,
                ),
              ),
            ),
          );

          expect(find.byType(KanbanColumn), findsWidgets);
        },
      );

      testWidgets(
        'check Row and padding ',
        (WidgetTester tester) async {
          final List<KanbanColumnData> emptyColumnData = [];

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: FilteredTasksView(filteredTasks: emptyColumnData),
              ),
            ),
          );

          final scrollViewFinder = find.byType(SingleChildScrollView);

          final scrollViewWidget =
              tester.widget<SingleChildScrollView>(scrollViewFinder);
          final padding = scrollViewWidget.padding as EdgeInsets;

          expect(
            padding,
            const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 10,
            ),
          );

          expect(
            find.byType(Row),
            findsOneWidget,
          );
        },
      );
    },
  );
}
