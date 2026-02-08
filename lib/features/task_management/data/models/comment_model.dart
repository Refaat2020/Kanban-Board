import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/comment.dart';

part 'comment_model.g.dart';

@JsonSerializable(includeIfNull: false,)
class CommentModel extends Comment {
  const CommentModel({
     super.id,
     super.content,
    @JsonKey(name: 'project_id') super.projectId,
    @JsonKey(name: 'task_id') super.taskId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Comment && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory CommentModel.fromEntity(Comment comment) {
    return CommentModel(
      id: comment.id,
      content: comment.content,
      projectId: comment.projectId,
      taskId: comment.taskId,
    );
  }

  Comment toEntity() {
    return Comment(
      id: id ?? '',
      content: content ?? '',
      projectId: projectId ?? '',
      taskId: taskId
    );
  }
}