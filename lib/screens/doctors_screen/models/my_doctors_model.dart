// To parse this JSON data, do
//
//     final getMyDoctorsModel = getMyDoctorsModelFromJson(jsonString);

import 'dart:convert';

GetMyDoctorsModel getMyDoctorsModelFromJson(String str) =>
    GetMyDoctorsModel.fromJson(json.decode(str));

String getMyDoctorsModelToJson(GetMyDoctorsModel data) =>
    json.encode(data.toJson());

class GetMyDoctorsModel {
  int status;
  String msg;
  List<Datum> data;
  int count;

  GetMyDoctorsModel({
    required this.status,
    required this.msg,
    required this.data,
    required this.count,
  });

  factory GetMyDoctorsModel.fromJson(Map<String, dynamic> json) =>
      GetMyDoctorsModel(
        status: json["status"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "count": count,
      };
}

class Datum {
  int id;
  String name;
  String speciality;
  String hospitalName;
  String address;
  dynamic phone;
  dynamic email;
  dynamic image;
  String status;
  String datumClass;
  dynamic rating;
  dynamic availableTime;
  String availableDays;
  dynamic lastVisit;
  String latitude;
  String longitude;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.name,
    required this.speciality,
    required this.hospitalName,
    required this.address,
    required this.phone,
    required this.email,
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
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        speciality: json["speciality"],
        hospitalName: json["hospital_name"],
        address: json["address"],
        phone: json["phone"],
        email: json["email"],
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
        "phone": phone,
        "email": email,
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
      };
}
