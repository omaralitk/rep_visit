import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rep_visit/base/ui/widgets/custom_toast.dart';
import 'package:rep_visit/core/navigation_service/navigation_service.dart';
import 'package:rep_visit/core/utilities/main_utilities.dart';
import 'package:rep_visit/screens/doctors_screen/models/doctors_model.dart'
    as doctors_model;
import 'package:rep_visit/screens/schedule_screen/repo/ai_schedule_repo.dart';

import '../../../base/ui/widgets/loading_widget.dart';
import '../../doctors_screen/repo/doctors_repo.dart';
import '../models/ai_schedule_model.dart';

class ScheduleProvider extends ChangeNotifier {
  bool isLoading = false;
  List<AiList> listOfVisits = [];
  double lat = 0.0;
  double lng = 0.0;

  // ---------------------------- GET VISITS -----------------------------

  getVisits(bool isAi) async {
    isLoading = true;
    notifyListeners();
    await getLocation();
    Map<String, double> body = {};
    body["current_lat"] = lat;
    body["current_lng"] = lng;
    Map<String, double> emptyBody = {"current_lat": 0.0, "current_lng": 0.0};
    AiScheduleRepo().getAiVisits(isAi ? body : emptyBody).then((val) {
      isLoading = false;
      if (val.success == 1) {
        listOfVisits = val.data??[];
      }
      notifyListeners();
    });
  }

  getLocation() async {
    try {
      Position position = await MainUtilities.getPosition();
      lat = position.latitude;
      lng = position.longitude;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting location: $e');
      }
    }
  }

  // ---------------------------- TAB SELECTION -----------------------------

  int selectedIndex = 0;

  setSelectedTap(int val) {
    selectedIndex = val;
    notifyListeners();
  }

  // ---------------------------- DOCTORS SEARCH -----------------------------

  TextEditingController searchController = TextEditingController();

  List<doctors_model.Datum> doctorsList = [];
  List<doctors_model.Datum> filteredDoctorsList = [];
  bool doctorsLoading = false;

  getDoctorsList() {
    doctorsLoading = true;
    notifyListeners();

    DoctorsRepo().getDoctors().then((val) {
      doctorsLoading = false;

      if (val.status == 1) {
        doctorsList = val.data??[];
        filteredDoctorsList = List.from(doctorsList);
      } else {
        doctorsList.clear();
        filteredDoctorsList.clear();
      }

      notifyListeners();
    });
  }

  // ---------------------------- SEARCH FUNCTION -----------------------------

  void searchDoctors(String query) {
    if (query.isEmpty) {
      filteredDoctorsList = List.from(doctorsList);
    } else {
      filteredDoctorsList = doctorsList.where((doctor) {
        return doctor.name?.toLowerCase().contains(query.toLowerCase())??false;
      }).toList();
    }

    // Sort: priority to names starting with query
    filteredDoctorsList.sort((a, b) {
      final aStarts = a.name?.toLowerCase().startsWith(query.toLowerCase())??false;
      final bStarts = b.name?.toLowerCase().startsWith(query.toLowerCase())??false;

      if (aStarts && !bStarts) return -1;
      if (!aStarts && bStarts) return 1;

      return a.name?.compareTo(b.name??"")??0;
    });

    notifyListeners();
  }

  // ---------------------------- ADD / REMOVE SCHEDULE -----------------------------

  List<Map<dynamic, dynamic>> listOfAddedSchedule = [];

  toggleScheduleVisit(int id, String time) {
    final exists = listOfAddedSchedule.any((item) => item["doctor_id"] == id);

    if (exists) {
      listOfAddedSchedule.removeWhere((item) => item["doctor_id"] == id);
    } else {
      listOfAddedSchedule.add({
        "doctor_id": id,
        "visit_time": time,
      });
    }

    notifyListeners();
  }

  // ---------------------------- SAVE VISITS -----------------------------

  saveScheduleVisits(BuildContext context) {
    LoadingWidget.show();

    final now = DateTime.now();

    final selectedDate = selectedIndex == 0
        ? now
        : now.add(const Duration(days: 1));


    final formattedDate =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

    Map<String, dynamic> body = {
      "day": formattedDate,
      "doctor_visits": listOfAddedSchedule,
    };
print("fffff ${body}");
    AiScheduleRepo().addVisits(body).then((val) {
      LoadingWidget.hide();
      if (val.success == 1) {
        ToastService.showSuccess(val.msg);
        listOfAddedSchedule.clear();
        getVisits(false);
        NavigationService.back();
      } else {
        ToastService.showError(val.msg);
      }
    });
  }
}
