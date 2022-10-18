class kikModel {
  String? id;
  String? userId;
  String? date;
  String? kiks;

  kikModel({required this.id, required this.userId, required this.date, required this.kiks});

  kikModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    date = json['date'];
    kiks = json['kiks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['date'] = this.date;
    data['kiks'] = this.kiks;
    return data;
  }
}
