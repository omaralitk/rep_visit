import 'package:flutter/cupertino.dart';
import 'package:rep_visit/screens/reports/repo/reports_repo.dart';

class ReportsProvider extends ChangeNotifier {


  bool isLoading = false;
  String date = "";
  int visits = 0;
  String duration = "";
  String distance = "";

  getReports() {
    isLoading = true;
    notifyListeners();
    ReportsRepo().getReports().then((val) {
      isLoading = false;
      if (val.status == 1) {
        date = val.date;
        visits = val.data?.visits ?? 0;
        duration = val.data?.duration ?? "";
        distance = val.data?.distanceTraveled ?? "";
      }
      notifyListeners();
    });
  }
}
