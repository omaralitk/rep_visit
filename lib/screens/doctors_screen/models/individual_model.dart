// To parse this JSON data, do
//
//     final individualModel = individualModelFromJson(jsonString);

import 'dart:convert';

IndividualModel individualModelFromJson(String str) => IndividualModel.fromJson(json.decode(str));

String individualModelToJson(IndividualModel data) => json.encode(data.toJson());

class IndividualModel {
    int success;
    String msg;
    Data data;

    IndividualModel({
        required this.success,
        required this.msg,
        required this.data,
    });

    factory IndividualModel.fromJson(Map<String, dynamic> json) => IndividualModel(
        success: json["success"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": data.toJson(),
    };
}

class Data {
    int doctorId;
    String doctorName;
    String scheduleType;
    List<Schedule> schedules;
    String message;

    Data({
        required this.doctorId,
        required this.doctorName,
        required this.scheduleType,
        required this.schedules,
        required this.message,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        doctorId: json["doctor_id"],
        doctorName: json["doctor_name"],
        scheduleType: json["schedule_type"],
        schedules: List<Schedule>.from(json["schedules"].map((x) => Schedule.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "doctor_id": doctorId,
        "doctor_name": doctorName,
        "schedule_type": scheduleType,
        "schedules": List<dynamic>.from(schedules.map((x) => x.toJson())),
        "message": message,
    };
}

class Schedule {
    String day;
    String time;

    Schedule({
        required this.day,
        required this.time,
    });

    factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        day: json["day"],
        time: json["time"],
    );

    Map<String, dynamic> toJson() => {
        "day": day,
        "time": time,
    };
}
