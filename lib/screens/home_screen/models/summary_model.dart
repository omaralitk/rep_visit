// To parse this JSON data, do
//
//     final summaryModel = summaryModelFromJson(jsonString);

import 'dart:convert';

SummaryModel summaryModelFromJson(String str) => SummaryModel.fromJson(json.decode(str));

String summaryModelToJson(SummaryModel data) => json.encode(data.toJson());

class SummaryModel {
  int status;
  String msg;
  SummaryData data;

  SummaryModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) => SummaryModel(
    status: json["status"],
    msg: json["msg"],
    data: SummaryData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data.toJson(),
  };
}

class SummaryData {
  String greeting;
  String subgreeting;
  List<Visit>? todaysVisits;
  Progress? progress;
  Visit? nextVisit;

  SummaryData({
    required this.greeting,
    required this.subgreeting,
    required this.todaysVisits,
    required this.progress,
    required this.nextVisit,
  });

  factory SummaryData.fromJson(Map<String, dynamic> json) => SummaryData(
    greeting: json["greeting"],
    subgreeting: json["subgreeting"],
    todaysVisits: List<Visit>.from(json["todaysVisits"].map((x) => Visit.fromJson(x))),
    progress: Progress.fromJson(json["progress"]),
    nextVisit: Visit.fromJson(json["nextVisit"]),
  );

  Map<String, dynamic> toJson() => {
    "greeting": greeting,
    "subgreeting": subgreeting,
    "todaysVisits": List<dynamic>.from(todaysVisits!.map((x) => x.toJson())),
    "progress": progress?.toJson(),
    "nextVisit": nextVisit?.toJson(),
  };
}

class Visit {
  String time;
  String doctor;
  String address;
  String status;

  Visit({
    required this.time,
    required this.doctor,
    required this.address,
    required this.status,
  });

  factory Visit.fromJson(Map<String, dynamic> json) => Visit(
    time: json["time"],
    doctor: json["doctor"],
    address: json["address"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "doctor": doctor,
    "address": address,
    "status": status,
  };
}

class Progress {
  int percentage;
  int totalVisits;
  String visitsCompleted;

  Progress({
    required this.percentage,
    required this.totalVisits,
    required this.visitsCompleted,
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
