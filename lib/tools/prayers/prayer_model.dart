class PrayerModel {
  String? id;
  String? title;
  String? image;
  String? audio;

  PrayerModel({required this.id, required this.title, required this.image, required this.audio});

  PrayerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    audio = json['audio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['audio'] = this.audio;
    return data;
  }
}
