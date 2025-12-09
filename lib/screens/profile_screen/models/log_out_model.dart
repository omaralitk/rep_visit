// To parse this JSON data, do
//
//     final logOutModel = logOutModelFromJson(jsonString);

import 'dart:convert';

LogOutModel logOutModelFromJson(String str) => LogOutModel.fromJson(json.decode(str));

String logOutModelToJson(LogOutModel data) => json.encode(data.toJson());

class LogOutModel {
  int status;
  String msg;
  List<dynamic>? data;

  LogOutModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory LogOutModel.fromJson(Map<String, dynamic> json) => LogOutModel(
    status: json["status"],
    msg: json["msg"],
    data: List<dynamic>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data!.map((x) => x)),
  };
}
