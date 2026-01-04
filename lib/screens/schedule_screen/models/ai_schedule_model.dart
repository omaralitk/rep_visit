// To parse this JSON data, do
//
//     final aiSchedulModel = aiSchedulModelFromJson(jsonString);

import 'dart:convert';

AiSchedulModel aiSchedulModelFromJson(String str) =>
    AiSchedulModel.fromJson(json.decode(str));

String aiSchedulModelToJson(AiSchedulModel data) => json.encode(data.toJson());

class AiSchedulModel {
  int success;
  List<AiList> data;

  AiSchedulModel({
    required this.success,
    required this.data,
  });

  factory AiSchedulModel.fromJson(Map<String, dynamic> json) => AiSchedulModel(
        success: json["success"],
        data: List<AiList>.from(json["data"].map((x) => AiList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AiList {
  int id;
  int userId;
  int doctorId;
  DateTime visitDate;
  String status;
  String visitTime;
  dynamic endTime;
  dynamic totalDuration;
  dynamic notes;
  DateTime createdAt;
  DateTime updatedAt;
  Doctor doctor;

  AiList({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.visitDate,
    required this.status,
    required this.visitTime,
    required this.endTime,
    required this.totalDuration,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.doctor,
  });

  factory AiList.fromJson(Map<String, dynamic> json) => AiList(
        id: json["id"],
        userId: json["user_id"],
        doctorId: json["doctor_id"],
        visitDate: DateTime.parse(json["visit_date"]),
        status: json["status"],
        visitTime: json["visit_time"],
        endTime: json["end_time"],
        totalDuration: json["total_duration"],
        notes: json["notes"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        doctor: Doctor.fromJson(json["doctor"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "doctor_id": doctorId,
        "visit_date":
            "${visitDate.year.toString().padLeft(4, '0')}-${visitDate.month.toString().padLeft(2, '0')}-${visitDate.day.toString().padLeft(2, '0')}",
        "status": status,
        "visit_time": visitTime,
        "end_time": endTime,
        "total_duration": totalDuration,
        "notes": notes,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "doctor": doctor.toJson(),
      };
}

class Doctor {
  int id;
  int? companyId;
  dynamic addedByUserId;
  dynamic representativeEmpCode;
  String name;
  String speciality;
  String hospitalName;
  String address;
  String? phone;
  String? email;
  String? image;
  String status;
  String doctorClass;
  String? rating;
  dynamic availableTime;
  dynamic availableDays;
  DateTime? lastVisit;
  String latitude;
  String longitude;
  DateTime createdAt;
  DateTime updatedAt;

  Doctor({
    required this.id,
    required this.companyId,
    required this.addedByUserId,
    required this.representativeEmpCode,
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
        addedByUserId: json["added_by_user_id"],
        representativeEmpCode: json["representative_emp_code"],
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
        lastVisit: json["last_visit"] == null
            ? null
            : DateTime.parse(json["last_visit"]),
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "added_by_user_id": addedByUserId,
        "representative_emp_code": representativeEmpCode,
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
        "last_visit":
            "${lastVisit!.year.toString().padLeft(4, '0')}-${lastVisit!.month.toString().padLeft(2, '0')}-${lastVisit!.day.toString().padLeft(2, '0')}",
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
