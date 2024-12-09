import 'package:kanban_board/features/kanban_board/data/models/duration.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

enum TaskStatus {
  todo,
  inProgress,
  done,
}

@JsonSerializable(includeIfNull: false)
class Task {
  @JsonKey(includeToJson: false)
  final String? id;
  final String? content;
  final String? description;
  @JsonKey(name: 'section_id')
  final int? sectionId;
  final int? order;
  final int? priority;
  @JsonKey(name: 'project_id')
  final String? projectId;
  @JsonKey(name: 'due_string')
  final String? dueString;
  @JsonKey(name: 'is_completed')
  final bool? isCompleted;
  @JsonKey(includeToJson: false)
  final DurationData? duration;
  @JsonKey(includeToJson: true, includeFromJson: false, name: 'duration')
  final int? durationInMinutes;
  @JsonKey(includeToJson: true, includeFromJson: false, name: 'duration_unit')
  final String? durationUnit;

  Task({
    this.id,
    this.content,
    this.description,
    this.sectionId,
    this.order,
    this.priority,
    this.projectId,
    this.dueString,
    this.isCompleted,
    this.duration,
    this.durationInMinutes,
    this.durationUnit,
  });

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          content == other.content;

  @override
  int get hashCode => content.hashCode;
}
