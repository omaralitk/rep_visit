// To parse this JSON data, do
//
//     final filesModel = filesModelFromJson(jsonString);

import 'dart:convert';

FilesModel filesModelFromJson(String str) => FilesModel.fromJson(json.decode(str));

String filesModelToJson(FilesModel data) => json.encode(data.toJson());

class FilesModel {
  int status;
  String msg;
  List<Files> data;

  FilesModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory FilesModel.fromJson(Map<String, dynamic> json) => FilesModel(
    status: json["status"],
    msg: json["msg"],
    data: List<Files>.from(json["data"].map((x) => Files.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Files {
  int id;
  String name;
  String originalName;
  String fileType;
  int fileSize;
  dynamic description;
  String downloadUrl;
  DateTime sentAt;
  bool isRead;
  dynamic readAt;
  DateTime createdAt;

  Files({
    required this.id,
    required this.name,
    required this.originalName,
    required this.fileType,
    required this.fileSize,
    required this.description,
    required this.downloadUrl,
    required this.sentAt,
    required this.isRead,
    required this.readAt,
    required this.createdAt,
  });

  factory Files.fromJson(Map<String, dynamic> json) => Files(
    id: json["id"],
    name: json["name"],
    originalName: json["original_name"],
    fileType: json["file_type"],
    fileSize: json["file_size"],
    description: json["description"],
    downloadUrl: json["download_url"],
    sentAt: DateTime.parse(json["sent_at"]),
    isRead: json["is_read"],
    readAt: json["read_at"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "original_name": originalName,
    "file_type": fileType,
    "file_size": fileSize,
    "description": description,
    "download_url": downloadUrl,
    "sent_at": sentAt.toIso8601String(),
    "is_read": isRead,
    "read_at": readAt,
    "created_at": createdAt.toIso8601String(),
  };
}
