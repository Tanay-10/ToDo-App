import 'package:flutter/material.dart';

class ToDoModel {
  String? title;
  int? id;
  int? category_id;
  String? description;
  int? priority;
  int? is_done;

  ToDoModel({
    int? id,
    String? title,
    int? category_id,
    int? priority,
    String? description,
    int? is_done,
  }) {
    [
      this.id = id,
      this.category_id = category_id,
      this.priority = priority,
      this.title = title,
      this.description = description,
      this.is_done = is_done,
    ];
  }

  Map<String, dynamic?> toMap() {
    return {
      "id": this.id,
      "category_id": this.category_id,
      "title": this.title,
      "priority": this.priority,
      "description": this.description,
      "is_done": is_done,
    };
  }

  ToDoModel? fromMap(Map<String, dynamic>? map) {
    ToDoModel todo = ToDoModel();
    if (map == null) return null;
    if (map["id"] != null) todo.id = map["id"];
    if (map["category_id"] != null) todo.category_id = map["category_id"];
    if (map["title"] != null) todo.title = map["title"];
    if (map["priority"] != null) todo.priority = map["priority"];
    if (map["description"] != null) todo.description = map["description"];
  }
}
