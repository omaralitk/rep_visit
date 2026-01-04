// To parse this JSON data, do
//
//     final doctorsModel = doctorsModelFromJson(jsonString);

import 'dart:convert';

DoctorsModel doctorsModelFromJson(String str) => DoctorsModel.fromJson(json.decode(str));

String doctorsModelToJson(DoctorsModel data) => json.encode(data.toJson());

class DoctorsModel {
  int status;
  String msg;
  List<Datum> data;
  int companyId;

  DoctorsModel({
    required this.status,
    required this.msg,
    required this.data,
    required this.companyId,
  });

  factory DoctorsModel.fromJson(Map<String, dynamic> json) => DoctorsModel(
    status: json["status"],
    msg: json["msg"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    companyId: json["company_id"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "company_id": companyId,
  };
}

class Datum {
  int id;
  String name;
  String speciality;
  String hospitalName;
  String address;
  dynamic image;
  String status;
  String datumClass;
  dynamic rating;
  dynamic availableTime;
  String? availableDays;
  dynamic lastVisit;
  String latitude;
  String longitude;
  DateTime createdAt;
  DateTime updatedAt;
  List<WeeklySchedule> weeklySchedule;

  Datum({
    required this.id,
    required this.name,
    required this.speciality,
    required this.hospitalName,
    required this.address,
    required this.image,
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
    required this.weeklySchedule,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
    weeklySchedule: List<WeeklySchedule>.from(json["weekly_schedule"].map((x) => WeeklySchedule.fromJson(x))),
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
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "weekly_schedule": List<dynamic>.from(weeklySchedule.map((x) => x.toJson())),
  };
}

class WeeklySchedule {
  String day;
  String dayShort;
  String time;
  String display;

  WeeklySchedule({
    required this.day,
    required this.dayShort,
    required this.time,
    required this.display,
  });

  factory WeeklySchedule.fromJson(Map<String, dynamic> json) => WeeklySchedule(
    day: json["day"],
    dayShort: json["day_short"],
    time: json["time"],
    display: json["display"],
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "day_short": dayShort,
    "time": time,
    "display": display,
  };
}
