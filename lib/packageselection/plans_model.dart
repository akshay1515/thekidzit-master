class planModel {
  bool? ack;
  String? message;
  List<Plans>? plans;

  planModel({required this.ack, required this.message, required this.plans});

  planModel.fromJson(Map<String, dynamic> json) {
    ack = json['ack'];
    message = json['message'];
    if (json['plans'] != null) {
      plans = [];
      json['plans'].forEach((v) {
        plans!.add(new Plans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ack'] = this.ack;
    data['message'] = this.message;
    if (this.plans != null) {
      data['plans'] = this.plans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Plans {
  int? duration;
  List<Package>? package;

  Plans({required this.duration, required this.package});

  Plans.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    if (json['package'] != null) {
      package = [];
      json['package'].forEach((v) {
        package!.add(new Package.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    if (this.package != null) {
      data['package'] = this.package!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Package {
  int? id;
  String? title;
  int? price;
  bool? isActive;
  String? startDate;
  String? endDate;
  List<Features>? features;

  Package(
      {required this.id,
        required this.title,
        required this.price,
        required this.isActive,
        required this.startDate,
        required this.endDate,
        required this.features});

  Package.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    isActive = json['isActive'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    if (json['features'] != null) {
      features = [];
      json['features'].forEach((v) {
        features!.add(new Features.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['isActive'] = this.isActive;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    if (this.features != null) {
      data['features'] = this.features!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Features {
  String? title;
  String? image;

  Features({required this.title, required this.image});

  Features.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['image'] = this.image;
    return data;
  }
}
