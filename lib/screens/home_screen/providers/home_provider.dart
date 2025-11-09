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
  int percentage = 0;

  ///Next visit section
  String doctorName="";
  String address="";
  String time="";

  /// Today's Visit Section
  List<Visit> visits=[];

  getSummary(BuildContext context) {
    HomeRepo homeRepo = HomeRepo();
    isLoading = true;
    notifyListeners();
    homeRepo.getSummary().then((val) {
      print(val?.data.nextVisit?.address.toString());
      isLoading = false;
      if (val?.status == 1) {
        title = val?.data.greeting ?? "";
        subTitle = val?.data.subgreeting ?? "";
        completedVisits = val?.data.progress?.visitsCompleted ?? "";
        allVisits = val?.data.progress?.totalVisits ?? 0;
        percentage=val?.data.progress?.percentage??0;
        doctorName=val?.data.nextVisit?.doctor??"";
        time=val?.data.nextVisit?.time??"";
        address=val?.data.nextVisit?.address??"";
        visits=val?.data.todaysVisits??[];

      } else {}
      notifyListeners();
    });
  }
}
