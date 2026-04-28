import 'package:flutter/foundation.dart';
import 'package:rep_visit/screens/tracking_screen/models/end_visit_model.dart';
import 'package:rep_visit/screens/tracking_screen/models/start_visit_model.dart';

import '../../../core/network/constants/end_points.dart';
import '../../../core/network/http_client.dart';
import '../models/traking_model.dart';

class GetDailyVisitsRepo {
  /// To get all visits => (Pending and Completed)
  Future<GetDailyVisitsModel> getVisits() async {
    GetDailyVisitsModel getDailyVisitsModel =
        GetDailyVisitsModel(success: 0, msg: "", data: []);
    final response = await httpClient.get(endPoint: EndPoints.dailyVisits);
    if (response.statusCode == 200) {
      getDailyVisitsModel = getDailyVisitsModelFromJson(response.response);
      return getDailyVisitsModel;
    } else {
      getDailyVisitsModel.msg = "Error in get daily visits";
      return getDailyVisitsModel;
    }
  }

  /// To start visit
  Future<StartVisitModel> startVisit(Map<String, dynamic> body) async {
    StartVisitModel fallback =
        StartVisitModel(status: 0, msg: "Something went wrong", data: null);
    final response = await httpClient.post(
      endPoint: EndPoints.startVisit,
      payload: body,
    );

    if (response.statusCode == 200) {
      return startVisitModelFromJson(response.response);
    } else {
      /// Server responded but with error status
      return startVisitModelFromJson(response.response);
    }
    try {


    } catch (e, stacktrace) {
      /// Log error only in debug mode
      if (kDebugMode) {
        print("❌ startVisit() ERROR: $e");
        print(stacktrace);
      }

      /// Return safe fallback model
      return fallback;
    }
  }

  /// To end visit
  Future<EndVisitModel> endVisit(Map<String, dynamic> body) async {
    EndVisitModel fallback =
        EndVisitModel(status: 0, msg: "Something went wrong", data: null);

    try {
      final response = await httpClient.post(
        endPoint: EndPoints.endVisit,
        payload: body,
      );

      if (response.statusCode == 200) {
        return endVisitModelFromJson(response.response);
      } else {
        /// Server responded but with error status
        return endVisitModelFromJson(response.response);
      }
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print("❌ endVisit() ERROR: $e");
        print(stacktrace);
      }

      /// Return safe fallback model
      return fallback;
    }
  }
}
