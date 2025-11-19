import 'package:rep_visit/screens/tracking_screen/models/traking_model.dart' show GetDailyVisitsModel;

import '../../../core/network/constants/end_points.dart';
import '../../../core/network/http_client.dart';
import '../models/traking_model.dart';

class GetDailyVisitsRepo {
  Future<GetDailyVisitsModel> getVisits() async {
    GetDailyVisitsModel getDailyVisitsModel =
    GetDailyVisitsModel(success: 0, msg: "", data: []);
    print("----------------------");
    final response = await httpClient.get(endPoint: EndPoints.dailyVisits);
    if (response.statusCode == 200) {
      getDailyVisitsModel = getDailyVisitsModelFromJson(response.response);
      return getDailyVisitsModel;
    } else {
      getDailyVisitsModel.msg = "Error in get daily visits";
      return getDailyVisitsModel;
    }
  }
}