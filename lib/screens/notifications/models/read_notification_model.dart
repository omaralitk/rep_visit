// To parse this JSON data, do
//
//     final readNotificationModel = readNotificationModelFromJson(jsonString);

import 'dart:convert';

ReadNotificationModel readNotificationModelFromJson(String str) => ReadNotificationModel.fromJson(json.decode(str));

String readNotificationModelToJson(ReadNotificationModel data) => json.encode(data.toJson());

class ReadNotificationModel {
  int? success;
  String? msg;
  List<dynamic>? data;

  ReadNotificationModel({
    this.success,
    this.msg,
    this.data,
  });

  factory ReadNotificationModel.fromJson(Map<String, dynamic> json) => ReadNotificationModel(
    success: json["success"],
    msg: json["msg"],
    data: json["data"] == null ? [] : List<dynamic>.from(json["data"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "msg": msg,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
  };
}
