import 'package:rep_visit/screens/reports/models/reports_model.dart';

import '../../../core/network/constants/end_points.dart';
import '../../../core/network/http_client.dart';

class ReportsRepo{

  Future<ReportsModel> getReports() async {
    ReportsModel reportsModel =
    ReportsModel(status: 0, msg: "", data:null, date: '' );
    print("----------------------");
    final response =
    await httpClient.get(endPoint: EndPoints.reportsApi);
    if (response.statusCode == 200) {
      reportsModel = reportsModelFromJson(response.response);
      return reportsModel;
    } else {
      reportsModel.msg = "Error on login";
      return reportsModel;
    }
  }
}