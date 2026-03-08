// To parse this JSON data, do
//
//     final reportsModel = reportsModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

ReportsModel reportsModelFromJson(String str) => ReportsModel.fromJson(json.decode(str));

String reportsModelToJson(ReportsModel data) => json.encode(data.toJson());

class ReportsModel {
  int? status;
  String? msg;
  String? date;
  Data? data;

  ReportsModel({
    this.status,
    this.msg,
    this.date,
    this.data,
  });

  factory ReportsModel.fromJson(Map<String, dynamic> json) => ReportsModel(
    status: json["status"],
    msg: json["msg"],
    date: json["date"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "date": date,
    "data": data?.toJson(),
  };
}

class Data {
  int? visits;
  num? durationMinutes;
  String? durationText;
  num? distanceKm;
  String? note;

  Data({
    this.visits,
    this.durationMinutes,
    this.durationText,
    this.distanceKm,
    this.note,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    visits: json["visits"],
    durationMinutes: json["duration_minutes"],
    durationText: json["duration_text"],
    distanceKm: json["distance_km"],
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "visits": visits,
    "duration_minutes": durationMinutes,
    "duration_text": durationText,
    "distance_km": distanceKm,
    "note": note,
  };
}
