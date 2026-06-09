// To parse this JSON data, do
//
//     final getAiScheduleModel = getAiScheduleModelFromJson(jsonString);

import 'dart:convert';

GetAiScheduleModel getAiScheduleModelFromJson(String str) =>
    GetAiScheduleModel.fromJson(json.decode(str));

String getAiScheduleModelToJson(GetAiScheduleModel data) =>
    json.encode(data.toJson());

class GetAiScheduleModel {
  int? success;
  String? msg;
  List<ScheduleVisits>? data;

  GetAiScheduleModel({
    this.success,
    this.msg,
    this.data,
  });

  factory GetAiScheduleModel.fromJson(Map<String, dynamic> json) =>
      GetAiScheduleModel(
        success: json["success"],
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<ScheduleVisits>.from(
                json["data"]!.map((x) => ScheduleVisits.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ScheduleVisits {
  int? id;
  int? userId;
  int? doctorId;
  DateTime? visitDate;
  String? status;
  String? visitTime;
  dynamic endTime;
  dynamic totalDuration;
  dynamic notes;
  DateTime? createdAt;
  DateTime? updatedAt;
  Doctor? doctor;

  ScheduleVisits({
    this.id,
    this.userId,
    this.doctorId,
    this.visitDate,
    this.status,
    this.visitTime,
    this.endTime,
    this.totalDuration,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.doctor,
  });

  factory ScheduleVisits.fromJson(Map<String, dynamic> json) => ScheduleVisits(
        id: json["id"],
        userId: json["user_id"],
        doctorId: json["doctor_id"],
        visitDate: json["visit_date"] == null
            ? null
            : DateTime.parse(json["visit_date"]),
        status: json["status"],
        visitTime: json["visit_time"],
        endTime: json["end_time"],
        totalDuration: json["total_duration"],
        notes: json["notes"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        doctor: json["doctor"] == null ? null : Doctor.fromJson(json["doctor"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "doctor_id": doctorId,
        "visit_date":
            "${visitDate!.year.toString().padLeft(4, '0')}-${visitDate!.month.toString().padLeft(2, '0')}-${visitDate!.day.toString().padLeft(2, '0')}",
        "status": status,
        "visit_time": visitTime,
        "end_time": endTime,
        "total_duration": totalDuration,
        "notes": notes,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "doctor": doctor?.toJson(),
      };
}

class Doctor {
  int? id;
  int? companyId;
  dynamic addedByUserId;
  dynamic representativeEmpCode;
  String? name;
  String? speciality;
  String? hospitalName;
  String? address;
  dynamic phone;
  dynamic email;
  dynamic image;
  String? status;
  String? doctorClass;
  String? rating;
  dynamic availableTime;
  String? availableDays;
  dynamic lastVisit;
  String? latitude;
  String? longitude;
  DateTime? createdAt;
  DateTime? updatedAt;

  Doctor({
    this.id,
    this.companyId,
    this.addedByUserId,
    this.representativeEmpCode,
    this.name,
    this.speciality,
    this.hospitalName,
    this.address,
    this.phone,
    this.email,
    this.image,
    this.status,
    this.doctorClass,
    this.rating,
    this.availableTime,
    this.availableDays,
    this.lastVisit,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
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
        lastVisit: json["last_visit"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
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
        "last_visit": lastVisit,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
