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
        print("summery model ${response.response}");
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
  Future<StartWorkModel?> startWork(
      {required double lat, required double long}) async {
    try {
      final response = await httpClient.post(
        endPoint: EndPoints.startWork,
        payload: {
          "lat": lat,
          "long": long,
        },
      );

      if (response.statusCode == 200) {
        try {
          // Ensure response.response is a String before parsing
          if (response.response is String) {
            return startWorkModelFromJson(response.response as String);
          } else {
            print("startWork() Error: Response is not a string");
            return StartWorkModel(
              status: 0,
              msg: "Invalid response format",
              data: null,
            );
          }
        } catch (e) {
          print("startWork() Parsing Error: $e");
          return StartWorkModel(
            status: 0,
            msg: "Failed to parse response",
            data: null,
          );
        }
      } else {
        // Try to parse error response
        try {
          if (response.response is String) {
            return startWorkModelFromJson(response.response as String);
          }
        } catch (_) {}
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
  Future<EndWorkModel?> endWork(
      {required double lat, required double long}) async {
    try {
      final response = await httpClient.post(
        endPoint: EndPoints.endWork,
        payload: {
          "lat": lat,
          "long": long,
        },
      );

      if (response.statusCode == 200) {
        try {
          // Ensure response.response is a String before parsing
          if (response.response is String) {
            return endWorkModelFromJson(response.response as String);
          } else {
            print("endWork() Error: Response is not a string");
            return EndWorkModel(
              status: 0,
              msg: "Invalid response format",
              data: null,
            );
          }
        } catch (e) {
          print("endWork() Parsing Error: $e");
          return EndWorkModel(
            status: 0,
            msg: "Failed to parse response",
            data: null,
          );
        }
      } else {
        // Try to parse error response
        try {
          if (response.response is String) {
            return endWorkModelFromJson(response.response as String);
          }
        } catch (_) {}
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
