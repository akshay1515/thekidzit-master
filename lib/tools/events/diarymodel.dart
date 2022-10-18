class Diarymodel {
  String? id;
  String? userId;
  String? date;
  String? text;

  Diarymodel({required this.id, required this.userId, required this.date, required this.text});

  Diarymodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    date = json['date'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['date'] = this.date;
    data['text'] = this.text;
    return data;
  }
}
