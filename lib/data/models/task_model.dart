class TaskModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final String status;
  final String time;
  bool isDone;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.time,
    this.isDone = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      status: json['status'],
      time: json['time'],
      isDone: json['isDone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'status': status,
      'time': time,
      'isDone': isDone,
    };
  }
}