// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {
  int id;
  String title;
  String description;
  int priority;
  int timer;

  Task({
    this.id,
    this.title,
    this.description,
    this.priority,
    this.timer,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["_id"] == null ? null : json["_id"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    priority: json["priority"] == null ? null : json["priority"],
    timer: json["timer"] == null ? null : json["timer"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "priority": priority == null ? null : priority,
    "timer": timer == null ? null : timer,
  };
}
