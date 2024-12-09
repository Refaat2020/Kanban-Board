import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';

void main() {
  group(
    'Task Model',
    () {
      test(
        'Task  model takes Object and return Json',
        () {
          Task task = Task(content: "content", description: "description");
          Map<String, dynamic> json = {
            "content": "content",
            "description": "description"
          };
          var toJson = task.toJson();
          expect(toJson, json);
        },
      );
      test(
        'Task  model takes json and return object',
        () {
          final Task task =
              Task(content: "content", description: "description");
          Map<String, dynamic> json = {
            "content": "content",
            "description": "description"
          };
          var formJson = Task.fromJson(json);
          expect(formJson, task);
        },
      );
    },
  );
}
