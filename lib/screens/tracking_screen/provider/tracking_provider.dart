import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rep_visit/screens/tracking_screen/models/traking_model.dart';
import 'package:rep_visit/screens/tracking_screen/repo/get_daily_visits_repo.dart';

class TrackingProvider extends ChangeNotifier {
  bool isLoading = false;

  List<ScheduleVisits> allVisits = [];
  List<ScheduleVisits> pendingVisits = [];
  List<ScheduleVisits> completedVisits = [];

  int selectedTab = 0; /// 0 = Pending, 1 = Completed

  void changeTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  Future<void> getVisits() async {
    isLoading = true;
    notifyListeners();

    GetDailyVisitsRepo().getVisits().then((val) {
      isLoading = false;

      if (val.success == 1) {
        allVisits = val.data;

        /// ---- SPLIT VISITS BASED ON STATUS ----
        pendingVisits = allVisits.where((v) =>
        (v.status == "Pending")
        ).toList();

        completedVisits = allVisits.where((v) =>
        (v.status.toLowerCase() == "Completed")
        ).toList();

      } else {

      }

      notifyListeners();
    });
  }
}

