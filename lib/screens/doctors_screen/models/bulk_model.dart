// To parse this JSON data, do
//
//     final bulkResponse = bulkResponseFromJson(jsonString);

import 'dart:convert';

BulkResponse bulkResponseFromJson(String str) =>
    BulkResponse.fromJson(json.decode(str));

String bulkResponseToJson(BulkResponse data) => json.encode(data.toJson());

class BulkResponse {
  int success;
  String msg;
  Data? data;

  BulkResponse({
    required this.success,
    required this.msg,
    required this.data,
  });

  factory BulkResponse.fromJson(Map<String, dynamic> json) => BulkResponse(
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
  int doctorId;
  String doctorName;
  String scheduleType;
  List<String> days;
  String time;
  List<Preview> preview;
  String message;

  Data({
    required this.doctorId,
    required this.doctorName,
    required this.scheduleType,
    required this.days,
    required this.time,
    required this.preview,
    required this.message,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        doctorId: json["doctor_id"],
        doctorName: json["doctor_name"],
        scheduleType: json["schedule_type"],
        days: List<String>.from(json["days"].map((x) => x)),
        time: json["time"],
        preview:
            List<Preview>.from(json["preview"].map((x) => Preview.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "doctor_id": doctorId,
        "doctor_name": doctorName,
        "schedule_type": scheduleType,
        "days": List<dynamic>.from(days.map((x) => x)),
        "time": time,
        "preview": List<dynamic>.from(preview.map((x) => x.toJson())),
        "message": message,
      };
}

class Preview {
  DateTime date;
  String day;
  String time;

  Preview({
    required this.date,
    required this.day,
    required this.time,
  });

  factory Preview.fromJson(Map<String, dynamic> json) => Preview(
        date: DateTime.parse(json["date"]),
        day: json["day"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "day": day,
        "time": time,
      };
}
