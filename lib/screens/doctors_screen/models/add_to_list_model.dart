// To parse this JSON data, do
//
//     final addToListModel = addToListModelFromJson(jsonString);

import 'dart:convert';

AddToListModel addToListModelFromJson(String str) =>
    AddToListModel.fromJson(json.decode(str));

String addToListModelToJson(AddToListModel data) => json.encode(data.toJson());

class AddToListModel {
  int status;
  String msg;
  dynamic data;

  AddToListModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory AddToListModel.fromJson(Map<String, dynamic> json) {
    // Handle case where data is null, empty array, or empty map
    Data? data;
    if (json["data"] != null) {
      if (json["data"] is Map<String, dynamic> &&
          (json["data"] as Map<String, dynamic>).isNotEmpty) {
        try {
          data = Data.fromJson(json["data"] as Map<String, dynamic>);
        } catch (e) {
          data = null;
        }
      }
      // If data is an empty array [] or null, data remains null
    }

    return AddToListModel(
      status: json["status"] ?? 0,
      msg: json["msg"] ?? "",
      data: data,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data?.toJson(),
      };
}

class Data {
  List<Added> added;
  int addedCount;
  int skippedCount;

  Data({
    required this.added,
    required this.addedCount,
    required this.skippedCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        added: List<Added>.from(json["added"].map((x) => Added.fromJson(x))),
        addedCount: json["added_count"],
        skippedCount: json["skipped_count"],
      );

  Map<String, dynamic> toJson() => {
        "added": List<dynamic>.from(added.map((x) => x.toJson())),
        "added_count": addedCount,
        "skipped_count": skippedCount,
      };
}

class Added {
  int doctorId;
  String doctorName;
  String speciality;
  String hospitalName;

  Added({
    required this.doctorId,
    required this.doctorName,
    required this.speciality,
    required this.hospitalName,
  });

  factory Added.fromJson(Map<String, dynamic> json) => Added(
        doctorId: json["doctor_id"],
        doctorName: json["doctor_name"],
        speciality: json["speciality"],
        hospitalName: json["hospital_name"],
      );

  Map<String, dynamic> toJson() => {
        "doctor_id": doctorId,
        "doctor_name": doctorName,
        "speciality": speciality,
        "hospital_name": hospitalName,
      };
}
