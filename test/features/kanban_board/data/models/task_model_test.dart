import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/features/kanban_board/data/models/task_model.dart';
import 'package:kanban_board/features/kanban_board/domain/entities/task.dart';

void main() {
  group(
    'Task Model',
    () {
      test(
        'Task  model takes Object and return Json',
        () {
          TaskModel task = TaskModel(content: "content", description: "description");
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
          final TaskModel task =
          TaskModel(content: "content", description: "description");
          Map<String, dynamic> json = {
            "content": "content",
            "description": "description"
          };
          var formJson = TaskModel.fromJson(json);
          expect(formJson, task);
        },
      );
    },
  );
}
