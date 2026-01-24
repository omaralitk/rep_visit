import 'package:rep_visit/screens/reports/models/export_model.dart';
import 'package:rep_visit/screens/reports/models/reports_model.dart';

import '../../../core/network/constants/end_points.dart';
import '../../../core/network/http_client.dart';

class ReportsRepo {
  Future<ReportsModel> getReports() async {
    ReportsModel reportsModel =
        ReportsModel(status: 0, msg: "", data: null, date: '');
    print("----------------------");
    final response = await httpClient.get(endPoint: EndPoints.reportsApi);

    print("reports body ${response.response}");
    if (response.statusCode == 200) {
      reportsModel = reportsModelFromJson(response.response);
      return reportsModel;
    } else {

      reportsModel.msg = "Error on get reports";
      return reportsModel;
    }

  }

  Future<ExportModel> exportNote(Map<String, dynamic> body) async {
    ExportModel exportModel = ExportModel(success: 0, msg: "", data: null);
    final response =
        await httpClient.post(endPoint: EndPoints.exportNote, payload: body);
    if (response.statusCode == 200) {
      exportModel = exportModelFromJson(response.response);
      return exportModel;
    } else {
      exportModel.msg = "Error on export note";
      return exportModel;
    }
  }
}
