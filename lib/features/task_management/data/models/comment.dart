import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable(includeIfNull: false)
class Comment {
  final String? content;
  final String? id;
  @JsonKey(name: 'project_id')
  final String? projectId;
  @JsonKey(name: 'task_id')
  final String? taskId;

  Comment({this.content, this.id, this.projectId, this.taskId});

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
