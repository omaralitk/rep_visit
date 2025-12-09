// To parse this JSON data, do
//
//     final endVisitModel = endVisitModelFromJson(jsonString);

import 'dart:convert';

EndVisitModel endVisitModelFromJson(String str) => EndVisitModel.fromJson(json.decode(str));

String endVisitModelToJson(EndVisitModel data) => json.encode(data.toJson());

class EndVisitModel {
  int status;
  String msg;
  Data? data;

  EndVisitModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory EndVisitModel.fromJson(Map<String, dynamic> json) => EndVisitModel(
    status: json["status"],
    msg: json["msg"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class Data {
  int visitId;
  int dailyVisitId;
  int doctorId;
  DateTime startTime;
  DateTime endTime;
  int totalDuration;
  double totalDistance;
  String status;

  Data({
    required this.visitId,
    required this.dailyVisitId,
    required this.doctorId,
    required this.startTime,
    required this.endTime,
    required this.totalDuration,
    required this.totalDistance,
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    visitId: json["visit_id"],
    dailyVisitId: json["daily_visit_id"],
    doctorId: json["doctor_id"],
    startTime: DateTime.parse(json["start_time"]),
    endTime: DateTime.parse(json["end_time"]),
    totalDuration: json["total_duration"],
    totalDistance: json["total_distance"]?.toDouble(),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "visit_id": visitId,
    "daily_visit_id": dailyVisitId,
    "doctor_id": doctorId,
    "start_time": startTime.toIso8601String(),
    "end_time": endTime.toIso8601String(),
    "total_duration": totalDuration,
    "total_distance": totalDistance,
    "status": status,
  };
}
