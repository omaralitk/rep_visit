// To parse this JSON data, do
//
//     final onboardingModel = onboardingModelFromJson(jsonString);

import 'dart:convert';

OnboardingModel onboardingModelFromJson(String str) => OnboardingModel.fromJson(json.decode(str));

String onboardingModelToJson(OnboardingModel data) => json.encode(data.toJson());

class OnboardingModel {
  int status;
  String msg;
  List<OnboardingScreens>? data;

  OnboardingModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory OnboardingModel.fromJson(Map<String, dynamic> json) => OnboardingModel(
    status: json["status"],
    msg: json["msg"],
    data: List<OnboardingScreens>.from(json["data"].map((x) => OnboardingScreens.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class OnboardingScreens {
  int id;
  String title;
  List<String> body;
  String image;
  int order;
  DateTime createdAt;
  DateTime updatedAt;

  OnboardingScreens({
    required this.id,
    required this.title,
    required this.body,
    required this.image,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OnboardingScreens.fromJson(Map<String, dynamic> json) => OnboardingScreens(
    id: json["id"],
    title: json["title"],
    body: List<String>.from(json["body"].map((x) => x)),
    image: json["image"],
    order: json["order"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "body": List<dynamic>.from(body.map((x) => x)),
    "image": image,
    "order": order,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
