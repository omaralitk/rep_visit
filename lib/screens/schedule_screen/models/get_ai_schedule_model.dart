// To parse this JSON data, do
//
//     final getAiScheduleModel = getAiScheduleModelFromJson(jsonString);

import 'dart:convert';

GetAiScheduleModel getAiScheduleModelFromJson(String str) => GetAiScheduleModel.fromJson(json.decode(str));

String getAiScheduleModelToJson(GetAiScheduleModel data) => json.encode(data.toJson());

class GetAiScheduleModel {
  int success;
  String msg;
  List<ScheduleVisits> data;

  GetAiScheduleModel({
    required this.success,
    required this.msg,
    required this.data,
  });

  factory GetAiScheduleModel.fromJson(Map<String, dynamic> json) => GetAiScheduleModel(
    success: json["success"],
    msg: json["msg"],
    data: List<ScheduleVisits>.from(json["data"].map((x) => ScheduleVisits.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ScheduleVisits {
  int id;
  int userId;
  int doctorId;
  DateTime visitDate;
  String status;
  String visitTime;
  dynamic endTime;
  dynamic totalDuration;
  DateTime createdAt;
  DateTime updatedAt;
  Doctor doctor;

  ScheduleVisits({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.visitDate,
    required this.status,
    required this.visitTime,
    required this.endTime,
    required this.totalDuration,
    required this.createdAt,
    required this.updatedAt,
    required this.doctor,
  });

  factory ScheduleVisits.fromJson(Map<String, dynamic> json) => ScheduleVisits(
    id: json["id"],
    userId: json["user_id"],
    doctorId: json["doctor_id"],
    visitDate: DateTime.parse(json["visit_date"]),
    status: json["status"],
    visitTime: json["visit_time"],
    endTime: json["end_time"],
    totalDuration: json["total_duration"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    doctor: Doctor.fromJson(json["doctor"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "doctor_id": doctorId,
    "visit_date": "${visitDate.year.toString().padLeft(4, '0')}-${visitDate.month.toString().padLeft(2, '0')}-${visitDate.day.toString().padLeft(2, '0')}",
    "status": status,
    "visit_time": visitTime,
    "end_time": endTime,
    "total_duration": totalDuration,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "doctor": doctor.toJson(),
  };
}

class Doctor {
  int id;
  int companyId;
  String name;
  String speciality;
  String hospitalName;
  String address;
  dynamic phone;
  dynamic email;
  dynamic image;
  String status;
  String doctorClass;
  dynamic rating;
  dynamic availableTime;
  dynamic availableDays;
  dynamic lastVisit;
  String latitude;
  String longitude;
  DateTime createdAt;
  DateTime updatedAt;

  Doctor({
    required this.id,
    required this.companyId,
    required this.name,
    required this.speciality,
    required this.hospitalName,
    required this.address,
    required this.phone,
    required this.email,
    required this.image,
    required this.status,
    required this.doctorClass,
    required this.rating,
    required this.availableTime,
    required this.availableDays,
    required this.lastVisit,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    id: json["id"],
    companyId: json["company_id"],
    name: json["name"],
    speciality: json["speciality"],
    hospitalName: json["hospital_name"],
    address: json["address"],
    phone: json["phone"],
    email: json["email"],
    image: json["image"],
    status: json["status"],
    doctorClass: json["class"],
    rating: json["rating"],
    availableTime: json["available_time"],
    availableDays: json["available_days"],
    lastVisit: json["last_visit"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_id": companyId,
    "name": name,
    "speciality": speciality,
    "hospital_name": hospitalName,
    "address": address,
    "phone": phone,
    "email": email,
    "image": image,
    "status": status,
    "class": doctorClass,
    "rating": rating,
    "available_time": availableTime,
    "available_days": availableDays,
    "last_visit": lastVisit,
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
