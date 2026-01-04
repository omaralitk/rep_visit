import 'package:rep_visit/core/network/models/general_response_model.dart';
import 'package:rep_visit/screens/home_screen/models/end_work_model.dart';
import 'package:rep_visit/screens/home_screen/models/start_work_model.dart';
import 'package:rep_visit/screens/home_screen/models/summary_model.dart';

import '../../../core/network/constants/end_points.dart';
import '../../../core/network/http_client.dart';

class HomeRepo {
  // -----------------------------------------
  // GET SUMMARY
  // -----------------------------------------
  Future<SummaryModel?> getSummary() async {
    try {
      final response = await httpClient.get(endPoint: EndPoints.summaryPi);

      if (response.statusCode == 200) {
        return summaryModelFromJson(response.response);
      } else {
        return SummaryModel(
          status: 0,
          msg: "Something Error",
          data: SummaryData(
            greeting: "",
            subgreeting: "",
            todaysVisits: null,
            progress: null,
            nextVisit: null,
          ),
        );
      }
    } catch (e) {
      print("getSummary() Error: $e");
      return SummaryModel(
        status: 0,
        msg: "Something Error",
        data: SummaryData(
          greeting: "",
          subgreeting: "",
          todaysVisits: null,
          progress: null,
          nextVisit: null,
        ),
      );
    }
  }

  // -----------------------------------------
  // START WORK
  // -----------------------------------------
  Future<StartWorkModel?> startWork() async {
    try {
      final response = await httpClient.post(
        endPoint: EndPoints.startWork,
        payload: {},
      );
      if (response.statusCode == 200) {
        return startWorkModelFromJson(response.response);
      } else {
        return StartWorkModel(
          status: 0,
          msg: "Something Error",
          data: null,
        );
      }
    } catch (e) {
      print("startWork() Error: $e");
      return StartWorkModel(
        status: 0,
        msg: "Something Error",
        data: null,
      );
    }
  }

  // -----------------------------------------
  // END WORK
  // -----------------------------------------
  Future<EndWorkModel?> endWork() async {
    try {
      final response = await httpClient.post(
        endPoint: EndPoints.endWork,
        payload: {},
      );

      if (response.statusCode == 200) {
        return endWorkModelFromJson(response.response);
      } else {
        return EndWorkModel(
          status: 0,
          msg: "Something Error",
          data: null,
        );
      }
    } catch (e) {
      print("endWork() Error: $e");
      return EndWorkModel(
        status: 0,
        msg: "Something Error",
        data: null,
      );
    }
  }
}
