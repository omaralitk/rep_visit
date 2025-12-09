
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rep_visit/base/ui/widgets/custom_toast.dart';
import 'package:rep_visit/core/navigation_service/navigation_service.dart';
import 'package:rep_visit/core/utilities/main_utilities.dart';
import 'package:rep_visit/screens/doctors_screen/models/doctors_model.dart';
import 'package:rep_visit/screens/schedule_screen/repo/ai_schedule_repo.dart';

import '../../../base/ui/widgets/loading_widget.dart';
import '../../doctors_screen/repo/doctors_repo.dart';
import '../models/get_ai_schedule_model.dart' hide Doctor;

class ScheduleProvider extends ChangeNotifier {
  bool isLoading = false;
  List<ScheduleVisits> listOfVisits = [];
  double lat = 0.0;
  double lng = 0.0;

  getVisits() async {
    isLoading = true;
    notifyListeners();
    await getLocation();
    AiScheduleRepo().getVisits().then((val) {
      isLoading = false;
      if (val.success == 1) {
        listOfVisits = val.data;
      } else {}
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

  // Future<Position> determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   // 1️⃣ Check if location services are enabled
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     throw Exception('Location services are disabled.');
  //   }
  //
  //   // 2️⃣ Check permission
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       throw Exception('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     throw Exception(
  //         'Location permissions are permanently denied, cannot request permissions.');
  //   }
  //
  //   // 3️⃣ Get current position
  //   return await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  // }

  int selectedIndex = 0;

  setSelectedTap(int val) {
    selectedIndex = val;

    notifyListeners();
  }

  TextEditingController searchController = TextEditingController();
  List<Doctor> doctorsList = [];
  bool doctorsLoading = false;

  getDoctorsList() {
    doctorsLoading = true;
    notifyListeners();
    DoctorsRepo().getDoctors().then((val) {
      doctorsLoading = false;

      if (val.status == 1) {
        doctorsList = val.data ?? [];
      } else {
        doctorsList.clear();
      }
      notifyListeners();
    });
  }

  List<Map<dynamic, dynamic>> listOfAddedSchedule = [];

  toggleScheduleVisit(int id, String time) {
    /// Check if doctor already exists in list
    final exists = listOfAddedSchedule
        .any((item) => item["doctor_id"] == id);

    if (exists) {
      /// Remove doctor
      listOfAddedSchedule.removeWhere((item) => item["doctor_id"] == id);
    } else {
      /// Add doctor
      listOfAddedSchedule.add({
        "doctor_id": id,
        "visit_time": time,
      });
    }

    notifyListeners();
  }

/// Save schedule list
  saveScheduleVisits(BuildContext context) {
    LoadingWidget.show();

    Map<String, dynamic> body = {
      "doctor_visits": listOfAddedSchedule,
    };

    AiScheduleRepo().addVisits(body).then((val) {
      LoadingWidget.hide();

      if (val.success == 1) {
        ToastService.showSuccess( val.msg);
        listOfAddedSchedule.clear();
        getVisits();
        NavigationService.back();

      } else {
        ToastService.showError(val.msg);
      }
    });
  }
}
