import 'package:flutter/foundation.dart';

@immutable
class TimeEntry {
  final String id;
  final String projectId;
  final String taskId;
  final double totalTime; // En heures
  final DateTime date;
  final String notes;

  TimeEntry({
    required this.id,
    required this.projectId,
    required this.taskId,
    required this.totalTime,
    required this.date,
    required this.notes,
  });

  // Pour la sérialisation/désérialisation JSON (LocalStorage)
  TimeEntry.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        projectId = json['projectId'] as String,
        taskId = json['taskId'] as String,
        totalTime = (json['totalTime'] as num).toDouble(), // Gère int ou double
        date = DateTime.parse(json['date'] as String), // Stocke comme ISO string
        notes = json['notes'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'projectId': projectId,
        'taskId': taskId,
        'totalTime': totalTime,
        'date': date.toIso8601String(), // Convertit en string pour JSON
        'notes': notes,
      };

   @override
    bool operator ==(Object other) =>
        identical(this, other) ||
        other is TimeEntry &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            projectId == other.projectId &&
            taskId == other.taskId &&
            totalTime == other.totalTime &&
            date == other.date &&
            notes == other.notes;

    @override
    int get hashCode =>
        id.hashCode ^
        projectId.hashCode ^
        taskId.hashCode ^
        totalTime.hashCode ^
        date.hashCode ^
        notes.hashCode;
}