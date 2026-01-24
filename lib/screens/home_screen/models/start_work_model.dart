// To parse this JSON data, do
//
//     final startWorkModel = startWorkModelFromJson(jsonString);

import 'dart:convert';

StartWorkModel startWorkModelFromJson(String str) =>
    StartWorkModel.fromJson(json.decode(str));

String startWorkModelToJson(StartWorkModel data) => json.encode(data.toJson());

class StartWorkModel {
  int status;
  String msg;
  Data? data;

  StartWorkModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory StartWorkModel.fromJson(Map<String, dynamic> json) => StartWorkModel(
        status: json["status"],
        msg: json["msg"],
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
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
  bool isActive;

  Data({
    required this.empcode,
    required this.name,
    required this.startDate,
    required this.isActive,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        empcode: json["empcode"],
        name: json["name"],
        startDate: DateTime.parse(json["start_date"]),
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "empcode": empcode,
        "name": name,
        "start_date": startDate.toIso8601String(),
        "is_active": isActive,
      };
}
