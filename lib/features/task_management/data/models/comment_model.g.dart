// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
  id: json['id'] as String?,
  content: json['content'] as String?,
  projectId: json['project_id'] as String?,
  taskId: json['task_id'] as String?,
);

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'content': ?instance.content,
      'project_id': ?instance.projectId,
      'task_id': ?instance.taskId,
    };
