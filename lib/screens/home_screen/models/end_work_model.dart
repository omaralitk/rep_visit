// To parse this JSON data, do
//
//     final endWorkModel = endWorkModelFromJson(jsonString);

import 'dart:convert';

EndWorkModel endWorkModelFromJson(String str) => EndWorkModel.fromJson(json.decode(str));

String endWorkModelToJson(EndWorkModel data) => json.encode(data.toJson());

class EndWorkModel {
  int status;
  String msg;
  Data? data;

  EndWorkModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory EndWorkModel.fromJson(Map<String, dynamic> json) => EndWorkModel(
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
  String empcode;
  String name;
  DateTime startDate;
  DateTime endDate;
  double totalHours;
  bool isActive;

  Data({
    required this.empcode,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.totalHours,
    required this.isActive,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    empcode: json["empcode"],
    name: json["name"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    totalHours: json["total_hours"]?.toDouble(),
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "empcode": empcode,
    "name": name,
    "start_date": startDate.toIso8601String(),
    "end_date": endDate.toIso8601String(),
    "total_hours": totalHours,
    "is_active": isActive,
  };
}
