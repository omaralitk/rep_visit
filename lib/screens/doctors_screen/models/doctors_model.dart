// To parse this JSON data, do
//
//     final doctorsModel = doctorsModelFromJson(jsonString);

import 'dart:convert';

DoctorsModel doctorsModelFromJson(String str) => DoctorsModel.fromJson(json.decode(str));

String doctorsModelToJson(DoctorsModel data) => json.encode(data.toJson());

class DoctorsModel {
  int? success;
  List<Doctor>? data;

  DoctorsModel({
    required this.success,
    required this.data,
  });

  factory DoctorsModel.fromJson(Map<String, dynamic> json) => DoctorsModel(
    success: json["success"],
    data: List<Doctor>.from(json["data"].map((x) => Doctor.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Doctor {
  int id;
  String name;
  String speciality;
  String hospitalName;
  String address;
  String status;
  String datumClass;
  String rating;
  String availableTime;
  String availableDays;
  String lastVisit;
  String latitude;
  String longitude;
  DateTime createdAt;
  DateTime updatedAt;

  Doctor({
    required this.id,
    required this.name,
    required this.speciality,
    required this.hospitalName,
    required this.address,
    required this.status,
    required this.datumClass,
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
    name: json["name"],
    speciality: json["speciality"],
    hospitalName: json["hospital_name"],
    address: json["address"],
    status: json["status"],
    datumClass: json["class"],
    rating: json["rating"],
    availableTime: json["available_time"],
    availableDays: json["available_days"],
    lastVisit:json["last_visit"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "speciality": speciality,
    "hospital_name": hospitalName,
    "address": address,
    "status": status,
    "class": datumClass,
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
