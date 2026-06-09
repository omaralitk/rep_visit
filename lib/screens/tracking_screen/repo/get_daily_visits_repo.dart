import 'dart:convert';

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
      print("visits ${response.response}");
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

    final responseFuture = httpClient.post(
      endPoint: EndPoints.startVisit,
      payload: body,
    );

    try {
      final response = await responseFuture;
     if(response.statusCode ==200){
       return startVisitModelFromJson(response.response);
     }else{
       return startVisitModelFromJson(response.response);
     }

    } catch (e) {

      try {
        final raw = e.toString().replaceFirst("Exception:", "").trim();
        return startVisitModelFromJson(raw);
      } catch (_) {
        return fallback;
      }
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
      final jsonData = jsonDecode(response.response);
      if (response.statusCode == 200) {
        return endVisitModelFromJson(response.response);
      } else {
        /// Server responded but with error status

        return endVisitModelFromJson(jsonData);
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
