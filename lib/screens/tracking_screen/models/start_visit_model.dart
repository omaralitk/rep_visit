// To parse this JSON data, do
//
//     final startVisitModel = startVisitModelFromJson(jsonString);

import 'dart:convert';

StartVisitModel startVisitModelFromJson(String str) => StartVisitModel.fromJson(json.decode(str));

String startVisitModelToJson(StartVisitModel data) => json.encode(data.toJson());

class StartVisitModel {
  int status;
  String msg;
  Data? data;

  StartVisitModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory StartVisitModel.fromJson(Map<String, dynamic> json) => StartVisitModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class Data {
  int dailyVisitId;
  int visitId;
  int doctorId;
  String doctorName;
  DateTime startTime;
  double startLat;
  double startLong;

  Data({
    required this.dailyVisitId,
    required this.visitId,
    required this.doctorId,
    required this.doctorName,
    required this.startTime,
    required this.startLat,
    required this.startLong,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    dailyVisitId: json["daily_visit_id"],
    visitId: json["visit_id"],
    doctorId: json["doctor_id"],
    doctorName: json["doctor_name"],
    startTime: DateTime.parse(json["start_time"]),
    startLat: json["start_lat"]?.toDouble(),
    startLong: json["start_long"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "daily_visit_id": dailyVisitId,
    "visit_id": visitId,
    "doctor_id": doctorId,
    "doctor_name": doctorName,
    "start_time": startTime.toIso8601String(),
    "start_lat": startLat,
    "start_long": startLong,
  };
}
