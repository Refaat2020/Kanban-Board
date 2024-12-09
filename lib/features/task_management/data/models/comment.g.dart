// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      content: json['content'] as String?,
      id: json['id'] as String?,
      projectId: json['project_id'] as String?,
      taskId: json['task_id'] as String?,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      if (instance.content case final value?) 'content': value,
      if (instance.id case final value?) 'id': value,
      if (instance.projectId case final value?) 'project_id': value,
      if (instance.taskId case final value?) 'task_id': value,
    };
