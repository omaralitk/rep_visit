// To parse this JSON data, do
//
//     final forgetPassModel = forgetPassModelFromJson(jsonString);

import 'dart:convert';

ForgetPassModel forgetPassModelFromJson(String str) => ForgetPassModel.fromJson(json.decode(str));

String forgetPassModelToJson(ForgetPassModel data) => json.encode(data.toJson());

class ForgetPassModel {
  int? status;
  String? msg;
  Data? data;

  ForgetPassModel({
    this.status,
    this.msg,
    this.data,
  });

  factory ForgetPassModel.fromJson(Map<String, dynamic> json) => ForgetPassModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class Data {
  String? newPassword;

  Data({
    this.newPassword,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    newPassword: json["new_password"],
  );

  Map<String, dynamic> toJson() => {
    "new_password": newPassword,
  };
}
