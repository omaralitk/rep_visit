// To parse this JSON data, do
//
//     final addScheduleVisitsModel = addScheduleVisitsModelFromJson(jsonString);

import 'dart:convert';

AddScheduleVisitsModel addScheduleVisitsModelFromJson(String str) => AddScheduleVisitsModel.fromJson(json.decode(str));

String addScheduleVisitsModelToJson(AddScheduleVisitsModel data) => json.encode(data.toJson());

class AddScheduleVisitsModel {
  int success;
  String msg;
  List<Visits> data;

  AddScheduleVisitsModel({
    required this.success,
    required this.msg,
    required this.data,
  });

  factory AddScheduleVisitsModel.fromJson(Map<String, dynamic> json) => AddScheduleVisitsModel(
    success: json["success"],
    msg: json["msg"],
    data: List<Visits>.from(json["data"].map((x) => Visits.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Visits {
  int userId;
  int doctorId;
  DateTime visitDate;
  String status;
  String visitTime;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Visits({
    required this.userId,
    required this.doctorId,
    required this.visitDate,
    required this.status,
    required this.visitTime,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Visits.fromJson(Map<String, dynamic> json) => Visits(
    userId: json["user_id"],
    doctorId: json["doctor_id"],
    visitDate: DateTime.parse(json["visit_date"]),
    status: json["status"],
    visitTime: json["visit_time"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "doctor_id": doctorId,
    "visit_date": "${visitDate.year.toString().padLeft(4, '0')}-${visitDate.month.toString().padLeft(2, '0')}-${visitDate.day.toString().padLeft(2, '0')}",
    "status": status,
    "visit_time": visitTime,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
