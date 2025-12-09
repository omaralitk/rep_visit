// To parse this JSON data, do
//
//     final workProcessModel = workProcessModelFromJson(jsonString);

import 'dart:convert';

WorkProcessModel workProcessModelFromJson(String str) => WorkProcessModel.fromJson(json.decode(str));

String workProcessModelToJson(WorkProcessModel data) => json.encode(data.toJson());

class WorkProcessModel {
  int status;
  String msg;
  Data? data;

  WorkProcessModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory WorkProcessModel.fromJson(Map<String, dynamic> json) => WorkProcessModel(
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
  String? empcode;
  String? name;
  DateTime? startDate;
  DateTime? endDate;
  double? totalHours;
  bool? isActive;

  Data({
     this.empcode,
     this.name,
     this.startDate,
     this.endDate,
     this.totalHours,
     this.isActive,
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
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "total_hours": totalHours,
    "is_active": isActive,
  };
}
