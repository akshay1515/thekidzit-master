class TaskModel {
  String? id;
  String? userId;
  String? title;
  String? description;
  String? date;
  String? createdAt;

  TaskModel(
      {required this.id,
        required this.userId,
        required this.title,
        required this.description,
        required this.date,
        required this.createdAt});

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['date'] = this.date;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
