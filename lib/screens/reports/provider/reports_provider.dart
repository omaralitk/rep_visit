import 'package:flutter/cupertino.dart';
import 'package:rep_visit/base/ui/widgets/custom_toast.dart';
import 'package:rep_visit/base/ui/widgets/loading_widget.dart';
import 'package:rep_visit/screens/reports/repo/reports_repo.dart';

class ReportsProvider extends ChangeNotifier {
  bool isLoading = false;
  String date = "";
  int visits = 0;
  String duration = "";
  String distance = "";
  TextEditingController noteController = TextEditingController();
  getReports() {
    isLoading = true;
    notifyListeners();
    ReportsRepo().getReports().then((val) {
      isLoading = false;

      if (val.status == 1) {

        date = val.date??"";
        visits = val.data?.visits ?? 0;
        duration = val.data?.durationText ?? "0";
        distance = val.data?.distanceKm.toString() ?? "0";
      }
      notifyListeners();
    });
  }

  exportNote() {
    Map<String, dynamic> body = {"note": noteController.text};
    LoadingWidget.show();

    ReportsRepo().exportNote(body).then((val) {
      LoadingWidget.hide();
      if (val.success == 1) {
        ToastService.showSuccess(val.msg);
      } else {
        ToastService.showError(val.msg);
      }
    });
  }
}
