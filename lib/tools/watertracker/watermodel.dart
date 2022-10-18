class Watergalassdata {
  String? id;
  String? userId;
  String? date;
  String? noOfGlasses;

  Watergalassdata({required this.id, required this.userId, required this.date, required this.noOfGlasses});

  Watergalassdata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    date = json['date'];
    noOfGlasses = json['noOfGlasses'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['date'] = this.date;
    data['noOfGlasses'] = this.noOfGlasses;
    return data;
  }
}
