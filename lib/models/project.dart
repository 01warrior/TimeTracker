import 'package:flutter/foundation.dart';

@immutable
class Project {
  final String id;
  final String name;

  Project({required this.id, required this.name});

  // Pour la sérialisation/désérialisation JSON (LocalStorage)
  Project.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Project &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}