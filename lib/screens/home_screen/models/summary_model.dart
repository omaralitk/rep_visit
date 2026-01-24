// To parse this JSON data, do
//
//     final summaryModel = summaryModelFromJson(jsonString);

import 'dart:convert';

SummaryModel summaryModelFromJson(String str) => SummaryModel.fromJson(json.decode(str));

String summaryModelToJson(SummaryModel data) => json.encode(data.toJson());

class SummaryModel {
  int? status;
  String? msg;
  SummaryData? data;

  SummaryModel({
    this.status,
    this.msg,
    this.data,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) => SummaryModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? null : SummaryData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class SummaryData {
  String? greeting;
  String? subgreeting;
  List<TodaysVisit>? todaysVisits;
  Progress? progress;
  NextVisit? nextVisit;

  SummaryData({
    this.greeting,
    this.subgreeting,
    this.todaysVisits,
    this.progress,
    this.nextVisit,
  });

  factory SummaryData.fromJson(Map<String, dynamic> json) => SummaryData(
    greeting: json["greeting"],
    subgreeting: json["subgreeting"],
    todaysVisits: json["todaysVisits"] == null ? [] : List<TodaysVisit>.from(json["todaysVisits"]!.map((x) => TodaysVisit.fromJson(x))),
    progress: json["progress"] == null ? null : Progress.fromJson(json["progress"]),
    nextVisit: json["nextVisit"] == null ? null : NextVisit.fromJson(json["nextVisit"]),
  );

  Map<String, dynamic> toJson() => {
    "greeting": greeting,
    "subgreeting": subgreeting,
    "todaysVisits": todaysVisits == null ? [] : List<dynamic>.from(todaysVisits!.map((x) => x.toJson())),
    "progress": progress?.toJson(),
    "nextVisit": nextVisit?.toJson(),
  };
}

class NextVisit {
  String? time;
  String? doctor;
  String? address;
  String? status;
  double? lat;
  double? long;
  String? phone;

  NextVisit({
    this.time,
    this.doctor,
    this.address,
    this.status,
    this.lat,
    this.long,
    this.phone,
  });

  factory NextVisit.fromJson(Map<String, dynamic> json) => NextVisit(
    time: json["time"],
    doctor: json["doctor"],
    address: json["address"],
    status: json["status"],
    lat: json["lat"],
    long: json["long"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "doctor": doctor,
    "address": address,
    "status": status,
    "lat": lat,
    "long": long,
    "phone": phone,
  };
}

class Progress {
  double? percentage;
  int? totalVisits;
  String? visitsCompleted;

  Progress({
    this.percentage,
    this.totalVisits,
    this.visitsCompleted,
  });

  factory Progress.fromJson(Map<String, dynamic> json) => Progress(
    percentage: json["percentage"],
    totalVisits: json["totalVisits"],
    visitsCompleted: json["visitsCompleted"],
  );

  Map<String, dynamic> toJson() => {
    "percentage": percentage,
    "totalVisits": totalVisits,
    "visitsCompleted": visitsCompleted,
  };
}

class TodaysVisit {
  String? doctor;
  String? address;
  String? time;
  String? status;
  int? isNext;

  TodaysVisit({
    this.doctor,
    this.address,
    this.time,
    this.status,
    this.isNext,
  });

  factory TodaysVisit.fromJson(Map<String, dynamic> json) => TodaysVisit(
    doctor: json["doctor"],
    address: json["address"],
    time: json["time"],
    status: json["status"],
    isNext: json["isNext"],
  );

  Map<String, dynamic> toJson() => {
    "doctor": doctor,
    "address": address,
    "time": time,
    "status": status,
    "isNext": isNext,
  };
}
