import 'package:json_annotation/json_annotation.dart';
import 'package:kanban_board/features/kanban_board/data/models/duration_model.dart';

import '../../domain/entities/task.dart';

part 'task_model.g.dart';

@JsonSerializable(includeIfNull: false)
class TaskModel extends Task {
  TaskModel({
    super.id,
    super.content,
    super.description,
    @JsonKey(name: 'due_string') super.dueString,
    @JsonKey(includeToJson: false) super.duration,
    @JsonKey(includeToJson: true, includeFromJson: false, name: 'duration')
    super.durationInMinutes,
    @JsonKey(includeToJson: true, includeFromJson: false, name: 'duration_unit')
    super.durationUnit,
    @JsonKey(name: 'is_completed') super.isCompleted,
    super.order,
    super.priority,
    @JsonKey(name: 'project_id') super.projectId,
    @JsonKey(name: 'section_id') super.sectionId,
    super.labels,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      dueString: task.dueString,
      content: task.content,
      description: task.description,
      projectId: task.projectId,
      sectionId: task.sectionId,
      isCompleted: task.isCompleted,
      priority: task.priority,
      labels: task.labels,
    );
  }

  Task toEntity() {
    return Task(
      id: id ?? '',
      content: content ?? '',
      description: description ?? '',
      projectId: projectId ?? '',
      sectionId: sectionId ?? 0,
      order: order ?? 0,
      priority: priority ?? 0,
      isCompleted: isCompleted ?? false,
      dueString: dueString,
      duration: duration,
      labels: labels,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          content == other.content;

  @override
  int get hashCode => content.hashCode;
}
