import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rep_visit/screens/home_screen/providers/home_provider.dart';
import 'package:rep_visit/screens/home_screen/repo/home_repo.dart';

class DayStatusProvider extends ChangeNotifier {
  DateTime? startTime;
  DateTime? endTime;
bool isStart=false;
  /// Keep history
  final List<DateTime> startHistory = [];
  final List<DateTime> endHistory = [];

  bool get isDayStarted => startTime != null && endTime == null;

  String get formattedDate => DateFormat('EEEE, MMM d').format(DateTime.now());

  String get formattedStartTime => startTime != null
      ? DateFormat('hh:mm a').format(startTime!)
      : 'Not started';

  String get formattedEndTime => endTime != null
      ? DateFormat('hh:mm a').format(endTime!)
      : 'Not ended';

  /// Handle Start/End button logic
  void handleDayAction() {
    if (isStart==false) {

      isStart=true;
      startTime = DateTime.now();
      endTime = null;

    } else if (isStart) {
      // End current day
      isStart=false;
      endTime = DateTime.now();

    }
    notifyListeners();
  }

  startDay(){
    Map<String, dynamic> body={

    };
    HomeRepo().startVisit(body).then((val){

    });
  }

}
