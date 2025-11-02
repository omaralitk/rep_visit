import 'package:flutter/cupertino.dart';
import 'package:rep_visit/base/ui/widgets/custom_toast.dart';
import 'package:rep_visit/screens/doctors_screen/models/doctors_model.dart';
import 'package:rep_visit/screens/doctors_screen/repo/doctors_repo.dart';

class DoctorsProvider extends ChangeNotifier {
  List<Doctor> doctorsList = [];
  bool isLoading = false;

  getDoctorsList() {
    isLoading = true;
    notifyListeners();
    DoctorsRepo().getDoctors().then((val) {
      isLoading = false;

      if (val.success == 1) {
        doctorsList = val.data ?? [];
      } else {
        doctorsList.clear();
      }
      notifyListeners();
    });
  }
}
