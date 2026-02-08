import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/features/task_management/data/models/comment_model.dart';

void main() {
  group(
    'Comment Model',
    () {
      test(
        'Comment  model takes Object and return Json',
        () {
          CommentModel comment = CommentModel(content: "content", taskId: "1");
          Map<String, dynamic> json = {"content": "content", "task_id": "1"};
          var toJson = comment.toJson();
          expect(toJson, json);
        },
      );
      test(
        'Comment  model takes json and return object',
        () {
          final CommentModel comment = CommentModel(content: "content", taskId: "1");
          Map<String, dynamic> json = {"content": "content", "task_id": "1"};
          var formJson = CommentModel.fromJson(json);
          expect(formJson, comment);
        },
      );
    },
  );
}
