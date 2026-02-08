// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
  id: json['id'] as String?,
  content: json['content'] as String?,
  description: json['description'] as String?,
  dueString: json['due_string'] as String?,
  duration: json['duration'] == null
      ? null
      : DurationDataModel.fromJson(json['duration'] as Map<String, dynamic>),
  isCompleted: json['is_completed'] as bool?,
  order: (json['order'] as num?)?.toInt(),
  priority: (json['priority'] as num?)?.toInt(),
  projectId: json['project_id'] as String?,
  sectionId: (json['section_id'] as num?)?.toInt(),
  labels: (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
)..localId = json['localId'] as String?;

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
  'id': ?instance.id,
  'localId': ?instance.localId,
  'content': ?instance.content,
  'description': ?instance.description,
  'section_id': ?instance.sectionId,
  'order': ?instance.order,
  'priority': ?instance.priority,
  'project_id': ?instance.projectId,
  'due_string': ?instance.dueString,
  'is_completed': ?instance.isCompleted,
  'duration': ?instance.durationInMinutes,
  'duration_unit': ?instance.durationUnit,
  'labels': ?instance.labels,
};
