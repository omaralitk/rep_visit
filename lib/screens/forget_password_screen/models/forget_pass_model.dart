// To parse this JSON data, do
//
//     final forgetPassModel = forgetPassModelFromJson(jsonString);

import 'dart:convert';

ForgetPassModel forgetPassModelFromJson(String str) => ForgetPassModel.fromJson(json.decode(str));

String forgetPassModelToJson(ForgetPassModel data) => json.encode(data.toJson());

class ForgetPassModel {
  int status;
  String msg;
  String newPassword;

  ForgetPassModel({
    required this.status,
    required this.msg,
    required this.newPassword,
  });

  factory ForgetPassModel.fromJson(Map<String, dynamic> json) => ForgetPassModel(
    status: json["status"],
    msg: json["msg"],
    newPassword: json["new_password"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "new_password": newPassword,
  };
}
