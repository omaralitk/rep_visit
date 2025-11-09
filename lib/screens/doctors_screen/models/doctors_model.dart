// To parse this JSON data, do
//
//     final doctorsModel = doctorsModelFromJson(jsonString);

import 'dart:convert';

DoctorsModel doctorsModelFromJson(String str) => DoctorsModel.fromJson(json.decode(str));

String doctorsModelToJson(DoctorsModel data) => json.encode(data.toJson());

class DoctorsModel {
  int? status;
  String? msg;
  List<Doctor>? data;

  DoctorsModel({
    this.status,
    this.msg,
    this.data,
  });

  factory DoctorsModel.fromJson(Map<String, dynamic> json) => DoctorsModel(
    status: json["status"],
    msg: json["msg"],
    data: List<Doctor>.from(json["data"].map((x) => Doctor.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data?.map((x) => x.toJson())??[]),
  };
}

class Doctor {
  int? id;
  String? name;
  String? speciality;
  String? hospitalName;
  String? address;
  dynamic image;
  String? status;
  String? datumClass;
  dynamic rating;
  dynamic availableTime;
  dynamic availableDays;
  dynamic lastVisit;
  String? latitude;
  String? longitude;
  DateTime? createdAt;
  DateTime? updatedAt;

  Doctor({
    this.id,
    this.name,
    this.speciality,
    this.hospitalName,
    this.address,
    this.image,
    this.status,
    this.datumClass,
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
    name: json["name"],
    speciality: json["speciality"],
    hospitalName: json["hospital_name"],
    address: json["address"],
    image: json["image"],
    status: json["status"],
    datumClass: json["class"],
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
    "name": name,
    "speciality": speciality,
    "hospital_name": hospitalName,
    "address": address,
    "image": image,
    "status": status,
    "class": datumClass,
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
