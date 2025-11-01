// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  int status;
  String msg;
  String token;
  dynamic data;

  LoginModel({
    required this.status,
    required this.msg,
    required this.token,
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"],
    msg: json["msg"],
    token: json["token"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "token": token,
    "data": data.toJson(),
  };
}

class Data {
  String empcode;
  String name;
  String email;
  String phoneNumber;
  dynamic image;
  String companyCode;

  Data({
    required this.empcode,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.image,
    required this.companyCode,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    empcode: json["empcode"],
    name: json["name"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    image: json["image"],
    companyCode: json["CompanyCode"],
  );

  Map<String, dynamic> toJson() => {
    "empcode": empcode,
    "name": name,
    "email": email,
    "phone_number": phoneNumber,
    "image": image,
    "CompanyCode": companyCode,
  };
}
