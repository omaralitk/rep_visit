// To parse this JSON data, do
//
//     final generalResponseModel = generalResponseModelFromJson(jsonString);

import 'dart:convert';

GeneralResponseModel generalResponseModelFromJson(String str) => GeneralResponseModel.fromJson(json.decode(str));

String generalResponseModelToJson(GeneralResponseModel data) => json.encode(data.toJson());

class GeneralResponseModel {
  int status;
  String msg;
  dynamic data;


  GeneralResponseModel({
    required this.data,
    required this.msg,
    required this.status,
  });

  factory GeneralResponseModel.fromJson(Map<String, dynamic> json) => GeneralResponseModel(
    msg: json["msg"],
    data: json["data"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data,
    "msg": msg,
    "status": status,
  };
}