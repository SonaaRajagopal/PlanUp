class Task {
  String taskId;
  String taskName;
  String dueDate;
  String priority;
  String? description;
  int? eisenhowerMatrixRank;
  int isCompleted; 

  Task({
    required this.taskId,
    required this.taskName,
    required this.dueDate,
    required this.priority,
    this.description = '',
    this.eisenhowerMatrixRank = 4,
    this.isCompleted = 0, 
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      taskName: json['taskName'],
      dueDate: json['dueDate'],
      priority: json['priority'],
      description: json['description'],
      eisenhowerMatrixRank: json['eisenhowerMatrixRank'],
      isCompleted: json['isCompleted'] ?? 0, 
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taskId'] = this.taskId;
    data['taskName'] = this.taskName;
    data['dueDate'] = this.dueDate;
    data['priority'] = this.priority;
    data['description'] = this.description;
    data['eisenhowerMatrixRank'] = this.eisenhowerMatrixRank;
    data['isCompleted'] = this.isCompleted; 
    return data;
  }
}
