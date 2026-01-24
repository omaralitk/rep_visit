// To parse this JSON data, do
//
//     final exportModel = exportModelFromJson(jsonString);

import 'dart:convert';

ExportModel exportModelFromJson(String str) =>
    ExportModel.fromJson(json.decode(str));

String exportModelToJson(ExportModel data) => json.encode(data.toJson());

class ExportModel {
  int success;
  String msg;
  Data? data;

  ExportModel({
    required this.success,
    required this.msg,
    required this.data,
  });

  factory ExportModel.fromJson(Map<String, dynamic> json) => ExportModel(
        success: json["success"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  DateTime? date;
  String? note;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
     this.id,
     this.date,
     this.note,
     this.createdAt,
     this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        note: json["note"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date":
            "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
        "note": note,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
