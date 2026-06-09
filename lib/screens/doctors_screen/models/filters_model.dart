// To parse this JSON data, do
//
//     final filtersModel = filtersModelFromJson(jsonString);

import 'dart:convert';

FiltersModel filtersModelFromJson(String str) =>
    FiltersModel.fromJson(json.decode(str));

String filtersModelToJson(FiltersModel data) => json.encode(data.toJson());

class FiltersModel {
  int status;
  String msg;
  Data? data;

  FiltersModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory FiltersModel.fromJson(Map<String, dynamic> json) => FiltersModel(
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
  List<Area> categories;
  List<Area> specialties;
  List<Area> availability;
  List<Area> areas;

  Data({
    required this.categories,
    required this.specialties,
    required this.availability,
    required this.areas,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        categories:
            List<Area>.from(json["categories"].map((x) => Area.fromJson(x))),
        specialties:
            List<Area>.from(json["specialties"].map((x) => Area.fromJson(x))),
        availability:
            List<Area>.from(json["availability"].map((x) => Area.fromJson(x))),
        areas: List<Area>.from(json["areas"].map((x) => Area.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "specialties": List<dynamic>.from(specialties.map((x) => x.toJson())),
        "availability": List<dynamic>.from(availability.map((x) => x.toJson())),
        "areas": List<dynamic>.from(areas.map((x) => x.toJson())),
      };
}

class Area {
  String value;
  String label;

  Area({
    required this.value,
    required this.label,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
        value: json["value"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "label": label,
      };
}
