import 'package:flutter/foundation.dart';

@immutable
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.questionCount,
  });

  final String id;
  final String name;
  final String description;
  final String iconPath;
  final int questionCount;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        iconPath: json['icon_path'] as String,
        questionCount: json['question_count'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'icon_path': iconPath,
        'question_count': questionCount,
      };
}
