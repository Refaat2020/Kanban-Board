import 'package:flutter/material.dart';
import 'package:kanban_board/features/kanban_board/data/models/task.dart';

class KanbanColumnData {
  final int columnId;
  final String columnName;
  final Color columnColor;
  final List<Task> tasks;

  KanbanColumnData({
    required this.columnId,
    required this.columnName,
    required this.tasks,
    required this.columnColor,
  });

  KanbanColumnData copyWith({
    final int? columnId,
    final String? columnName,
    final Color? columnColor,
    final List<Task>? tasks,
  }) {
    return KanbanColumnData(
      columnId: columnId ?? this.columnId,
      columnName: columnName ?? this.columnName,
      columnColor: columnColor ?? this.columnColor,
      tasks: tasks ?? this.tasks,
    );
  }
}
