// To parse this JSON data, do
//
//     final reportsModel = reportsModelFromJson(jsonString);

import 'dart:convert';

ReportsModel reportsModelFromJson(String str) => ReportsModel.fromJson(json.decode(str));

String reportsModelToJson(ReportsModel data) => json.encode(data.toJson());

class ReportsModel {
  int status;
  String msg;
  String date;
  Data? data;

  ReportsModel({
    required this.status,
    required this.msg,
    required this.date,
    required this.data,
  });

  factory ReportsModel.fromJson(Map<String, dynamic> json) => ReportsModel(
    status: json["status"],
    msg: json["msg"],
    date: json["date"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "date": date,
    "data": data?.toJson(),
  };
}

class Data {
  int visits;
  String duration;
  String distanceTraveled;

  Data({
    required this.visits,
    required this.duration,
    required this.distanceTraveled,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    visits: json["visits"],
    duration: json["duration"],
    distanceTraveled: json["distance_traveled"],
  );

  Map<String, dynamic> toJson() => {
    "visits": visits,
    "duration": duration,
    "distance_traveled": distanceTraveled,
  };
}
