// To parse this JSON data, do
//
//     final doctorRequestModel = doctorRequestModelFromJson(jsonString);

import 'dart:convert';

DoctorRequestModel doctorRequestModelFromJson(String str) =>
    DoctorRequestModel.fromJson(json.decode(str));

String doctorRequestModelToJson(DoctorRequestModel data) =>
    json.encode(data.toJson());

class DoctorRequestModel {
  int status;
  String msg;
  Data? data;

  DoctorRequestModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory DoctorRequestModel.fromJson(Map<String, dynamic> json) =>
      DoctorRequestModel(
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
  DoctorRequest doctorRequest;

  Data({
    required this.doctorRequest,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        doctorRequest: DoctorRequest.fromJson(json["doctor_request"]),
      );

  Map<String, dynamic> toJson() => {
        "doctor_request": doctorRequest.toJson(),
      };
}

class DoctorRequest {
  int id;
  String doctorName;
  String email;
  String phone;
  String speciality;
  String hospitalName;
  String status;
  DateTime createdAt;

  DoctorRequest({
    required this.id,
    required this.doctorName,
    required this.email,
    required this.phone,
    required this.speciality,
    required this.hospitalName,
    required this.status,
    required this.createdAt,
  });

  factory DoctorRequest.fromJson(Map<String, dynamic> json) => DoctorRequest(
        id: json["id"],
        doctorName: json["doctor_name"],
        email: json["email"],
        phone: json["phone"],
        speciality: json["speciality"],
        hospitalName: json["hospital_name"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "doctor_name": doctorName,
        "email": email,
        "phone": phone,
        "speciality": speciality,
        "hospital_name": hospitalName,
        "status": status,
        "created_at": createdAt.toIso8601String(),
      };
}
