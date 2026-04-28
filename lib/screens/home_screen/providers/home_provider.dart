import 'package:flutter/cupertino.dart';
import 'package:rep_visit/screens/home_screen/models/summary_model.dart';
import 'package:rep_visit/screens/home_screen/repo/home_repo.dart';

class HomeProvider extends ChangeNotifier {
  bool isLoading = false;

  /// Title Section
  String title = '';
  String subTitle = '';

  /// Today's progress section
  String completedVisits = "";
  int allVisits = 0;
  double percentage = 0;

  ///Next visit section
  String doctorName = "";
  String time = "";
  double lat = 0.0;
  String address = "";
  double lng = 0.0;
  String phone = "";
  bool isStarted=false;
  String startTime="";

  /// Today's Visit Section
  List<TodaysVisit> visits = [];

  getSummary(BuildContext context) async {
    HomeRepo homeRepo = HomeRepo();
    isLoading = true;
    notifyListeners();
    await homeRepo.getSummary().then((val) {
      isLoading = false;
      notifyListeners();
      if (val?.status == 1) {
        title = val?.data?.greeting ?? "";
        subTitle = val?.data?.subgreeting ?? "";
        isStarted=val?.data?.isStarted??false;
        startTime=val?.data?.startTime??"";
        completedVisits = val?.data?.progress?.visitsCompleted ?? "";
        allVisits = val?.data?.progress?.totalVisits ?? 0;
        percentage = val?.data?.progress?.percentage ?? 0;
        doctorName = val?.data?.nextVisit?.doctor ?? "";
        time = val?.data?.nextVisit?.time ?? "";
        address = val?.data?.nextVisit?.address ?? "";
        lat = val?.data?.nextVisit?.lat??0.0;
        lng = val?.data?.nextVisit?.long ?? 0.0;
        // phone=val?.data?.nextVisit?.phoneNumber??'';
        visits = val?.data?.todaysVisits ?? [];
        notifyListeners();
      } else {}
    });
  }

  /// Clear all state (for logout)
  void clearAllState() {
    isLoading = false;
    title = '';
    subTitle = '';
    completedVisits = "";
    allVisits = 0;
    percentage = 0;
    doctorName = "";
    time = "";
    lat = 0.0;
    address = "";
    lng = 0.0;
    phone = "";
    visits.clear();
    notifyListeners();
  }
}
