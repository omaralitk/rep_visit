// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) =>
    NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) =>
    json.encode(data.toJson());

class NotificationsModel {
  int success;
  String msg;
  Data? data;

  NotificationsModel({
    required this.success,
    required this.msg,
    required this.data,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
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
  List<Notification> notifications;
  int unreadCount;
  int totalCount;

  Data({
    required this.notifications,
    required this.unreadCount,
    required this.totalCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        notifications: List<Notification>.from(
            json["notifications"].map((x) => Notification.fromJson(x))),
        unreadCount: json["unread_count"],
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "notifications":
            List<dynamic>.from(notifications.map((x) => x.toJson())),
        "unread_count": unreadCount,
        "total_count": totalCount,
      };
}

class Notification {
  String id;
  String type;
  String title;
  String message;
  String doctorName;
  int? doctorId;
  DateTime? visitDate;
  String? visitTime;
  int? visitId;
  dynamic notes;
  DateTime createdAt;
  String createdAtHuman;
  String? status;
  String? reviewerName;
  String? reviewerType;
  dynamic rejectionReason;
  DateTime? decisionDate;
  dynamic readAt;

  Notification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.doctorName,
    this.doctorId,
    this.visitDate,
    this.visitTime,
    this.visitId,
    this.notes,
    required this.createdAt,
    required this.createdAtHuman,
    this.status,
    this.reviewerName,
    this.reviewerType,
    this.rejectionReason,
    this.decisionDate,
    this.readAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json["id"],
        type: json["type"],
        title: json["title"],
        message: json["message"],
        doctorName: json["doctor_name"],
        doctorId: json["doctor_id"],
        visitDate: json["visit_date"] == null
            ? null
            : DateTime.parse(json["visit_date"]),
        visitTime: json["visit_time"],
        visitId: json["visit_id"],
        notes: json["notes"],
        createdAt: DateTime.parse(json["created_at"]),
        createdAtHuman: json["created_at_human"],
        status: json["status"],
        reviewerName: json["reviewer_name"],
        reviewerType: json["reviewer_type"],
        rejectionReason: json["rejection_reason"],
        decisionDate: json["decision_date"] == null
            ? null
            : DateTime.parse(json["decision_date"]),
        readAt: json["read_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "title": title,
        "message": message,
        "doctor_name": doctorName,
        "doctor_id": doctorId,
        "visit_date":
            "${visitDate!.year.toString().padLeft(4, '0')}-${visitDate!.month.toString().padLeft(2, '0')}-${visitDate!.day.toString().padLeft(2, '0')}",
        "visit_time": visitTime,
        "visit_id": visitId,
        "notes": notes,
        "created_at": createdAt.toIso8601String(),
        "created_at_human": createdAtHuman,
        "status": status,
        "reviewer_name": reviewerName,
        "reviewer_type": reviewerType,
        "rejection_reason": rejectionReason,
        "decision_date": decisionDate?.toIso8601String(),
        "read_at": readAt,
      };
}
