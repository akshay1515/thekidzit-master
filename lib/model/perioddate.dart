class periodDate {
  SafeDate? safeDate;
  SafeDate? fertileWindow;
  SafeDate? ovulationDate;
  SafeDate? postOvulationDate;
  String? nextDate;

  periodDate(
      {required this.safeDate,
        required this.fertileWindow,
        required this.ovulationDate,
        required this.postOvulationDate,
        required this.nextDate});

  periodDate.fromJson(Map<String, dynamic> json) {
    safeDate = json['safeDate'] != null
        ? new SafeDate.fromJson(json['safeDate'])
        : null;
    fertileWindow = json['fertileWindow'] != null
        ? new SafeDate.fromJson(json['fertileWindow'])
        : null;
    ovulationDate = json['ovulationDate'] != null
        ? new SafeDate.fromJson(json['ovulationDate'])
        : null;
    postOvulationDate = json['postOvulationDate'] != null
        ? new SafeDate.fromJson(json['postOvulationDate'])
        : null;
    nextDate = json['nextDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.safeDate != null) {
      data['safeDate'] = this.safeDate!.toJson();
    }
    if (this.fertileWindow != null) {
      data['fertileWindow'] = this.fertileWindow!.toJson();
    }
    if (this.ovulationDate != null) {
      data['ovulationDate'] = this.ovulationDate!.toJson();
    }
    if (this.postOvulationDate != null) {
      data['postOvulationDate'] = this.postOvulationDate!.toJson();
    }
    data['nextDate'] = this.nextDate;
    return data;
  }
}

class SafeDate {
  String? from;
  String? to;

  SafeDate({required this.from, required this.to});

  SafeDate.fromJson(Map<String, dynamic> json) {
    from = json['From'];
    to = json['To'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['From'] = this.from;
    data['To'] = this.to;
    return data;
  }
}
