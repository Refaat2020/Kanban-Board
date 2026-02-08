import 'package:isar_community/isar.dart';

import '../../domain/entities/task.dart';

part 'task_local_model.g.dart';

@collection
class TaskLocalModel {
  Id isarId = Isar.autoIncrement;
  @Index(unique: true)
  String? taskId;
  String? content;
  String? description;
  String? projectId;

  int? sectionId;
  int? order;
  int? priority;
  bool? isCompleted;

  String? dueString;
  List<String>? labels;

  /// Offline-first flag
  bool? isSynced;

  // -------- Mapping --------

  Task toEntity() {
    return Task(
      id: taskId,
      content: content,
      description: description,
      projectId: projectId,
      sectionId: sectionId,
      order: order,
      priority: priority,
      isCompleted: isCompleted,
      dueString: dueString,
      labels: labels,
    );
  }

  static TaskLocalModel fromEntity(Task task, {bool isSynced = true}) {
    return TaskLocalModel()
      ..taskId = task.id
      ..content = task.content
      ..description = task.description
      ..projectId = task.projectId
      ..sectionId = task.sectionId
      ..order = task.order
      ..priority = task.priority
      ..isCompleted = task.isCompleted
      ..dueString = task.dueString
      ..labels = task.labels
      ..isSynced = isSynced;
  }
}
