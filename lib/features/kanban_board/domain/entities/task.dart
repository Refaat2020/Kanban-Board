import 'package:kanban_board/features/kanban_board/data/models/duration_model.dart';

enum TaskStatus { todo, inProgress, done }

class Task {
  final String? id;
  String? localId;
  final String? content;
  final String? description;
  final int? sectionId;
  final int? order;
  final int? priority;
  final String? projectId;
  final String? dueString;
  final bool? isCompleted;
  final DurationDataModel? duration;
  final int? durationInMinutes;
  final String? durationUnit;
  final List<String>? labels;
  Task({
    this.id,
    this.localId,
    this.content,
    this.description,
    this.sectionId,
    this.order,
    this.priority,
    this.projectId,
    this.isCompleted,
    this.dueString,
    this.duration,
    this.durationInMinutes,
    this.durationUnit,
    this.labels,
  });

  Task copyWith({
    String? id,
    String? localId,
    String? content,
    String? description,
    int? sectionId,
    int? order,
    int? priority,
    String? projectId,
    String? dueString,
    bool? isCompleted,
    DurationDataModel? duration,
    int? durationInMinutes,
    String? durationUnit,
    List<String>? labels,
  }) {
    return Task(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      content: content ?? this.content,
      description: description ?? this.description,
      sectionId: sectionId ?? this.sectionId,
      order: order ?? this.order,
      priority: priority ?? this.priority,
      projectId: projectId ?? this.projectId,
      dueString: dueString ?? this.dueString,
      isCompleted: isCompleted ?? this.isCompleted,
      duration: duration ?? this.duration,
      durationInMinutes: durationInMinutes ?? this.durationInMinutes,
      durationUnit: durationUnit ?? this.durationUnit,
      labels: labels ?? this.labels,
    );
  }
}
