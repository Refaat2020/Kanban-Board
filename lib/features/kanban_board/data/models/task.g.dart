// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String?,
      content: json['content'] as String?,
      description: json['description'] as String?,
      sectionId: (json['section_id'] as num?)?.toInt(),
      order: (json['order'] as num?)?.toInt(),
      priority: (json['priority'] as num?)?.toInt(),
      projectId: json['project_id'] as String?,
      dueString: json['due_string'] as String?,
      isCompleted: json['is_completed'] as bool?,
      duration: json['duration'] == null
          ? null
          : DurationData.fromJson(json['duration'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      if (instance.content case final value?) 'content': value,
      if (instance.description case final value?) 'description': value,
      if (instance.sectionId case final value?) 'section_id': value,
      if (instance.order case final value?) 'order': value,
      if (instance.priority case final value?) 'priority': value,
      if (instance.projectId case final value?) 'project_id': value,
      if (instance.dueString case final value?) 'due_string': value,
      if (instance.isCompleted case final value?) 'is_completed': value,
      if (instance.durationInMinutes case final value?) 'duration': value,
      if (instance.durationUnit case final value?) 'duration_unit': value,
    };
