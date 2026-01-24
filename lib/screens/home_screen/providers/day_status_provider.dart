import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rep_visit/base/ui/widgets/custom_toast.dart';
import 'package:rep_visit/base/ui/widgets/loading_widget.dart';
import 'package:rep_visit/core/utilities/main_utilities.dart';
import 'package:rep_visit/screens/home_screen/repo/home_repo.dart';

class DayStatusProvider extends ChangeNotifier {
  DateTime? startTime;
  DateTime? endTime;
  bool isStart = false;

  /// Keep history
  final List<DateTime> startHistory = [];
  final List<DateTime> endHistory = [];

  bool get isDayStarted => startTime != null && endTime == null;

  String get formattedDate => DateFormat('EEEE, MMM d').format(DateTime.now());

  String get formattedStartTime => startTime != null
      ? DateFormat('hh:mm a').format(startTime!)
      : 'Not started';

  String get formattedEndTime =>
      endTime != null ? DateFormat('hh:mm a').format(endTime!) : 'Not ended';

  /// Handle Start/End button logic
  void handleDayAction() async {
    if (isStart == false) {
      // Start Day
      bool success = await startWork();

      if (success) {
        isStart = true;
        startTime = DateTime.now();
        endTime = null;
        notifyListeners();
      }
    } else {
      // End Day
      bool success = await endWork();

      if (success) {
        isStart = false;
        endTime = DateTime.now();
        notifyListeners();
      }
    }
  }

  Future<bool> startWork() async {
    try {
      LoadingWidget.show();

      // Get current location
      double lat = 0.0;
      double long = 0.0;
      try {
        final position = await MainUtilities.getPosition();
        lat = position.latitude;
        long = position.longitude;
      } catch (e) {
        LoadingWidget.hide();
        ToastService.showError(
            "Please enable location permission to start your day");
        return false;
      }

      final response = await HomeRepo().startWork(lat: lat, long: long);

      LoadingWidget.hide();

      if (response?.status == 1) {
        ToastService.showSuccess(response?.msg ?? "");
        return true;
      } else {
        ToastService.showError(response?.msg ?? "Something went wrong");
        return false;
      }
    } catch (e) {
      LoadingWidget.hide();
      ToastService.showError("Error occurred: $e");
      return false;
    }
  }

  Future<bool> endWork() async {
    try {
      LoadingWidget.show();

      // Get current location
      double lat = 0.0;
      double long = 0.0;
      try {
        final position = await MainUtilities.getPosition();
        lat = position.latitude;
        long = position.longitude;
      } catch (e) {
        LoadingWidget.hide();
        ToastService.showError(
            "Please enable location permission to end your day");
        return false;
      }

      final response = await HomeRepo().endWork(lat: lat, long: long);
      LoadingWidget.hide();

      if (response?.status == 1) {
        ToastService.showSuccess(response?.msg ?? "");
        return true;
      } else {
        ToastService.showError(response?.msg ?? "Something went wrong");
        return false;
      }
    } catch (e) {
      LoadingWidget.hide();
      ToastService.showError("Error occurred: $e");
      return false;
    }
  }
}
