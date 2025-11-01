import 'package:rep_visit/core/network/models/general_response_model.dart';
import 'package:rep_visit/screens/home_screen/models/summary_model.dart';

import '../../../core/network/constants/end_points.dart';
import '../../../core/network/http_client.dart';

class HomeRepo {
  Future<SummaryModel?> getSummary() async {
    SummaryModel summaryModel = SummaryModel(
        status: 0,
        msg: "",
        data: SummaryData(
            greeting: "",
            subgreeting: "",
            todaysVisits: null,
            progress: null,
            nextVisit: null));

    final response = await httpClient.get(
      endPoint: EndPoints.summaryPi,
    );

    if (response.statusCode == 200) {
      summaryModel = summaryModelFromJson(response.response);
      return summaryModel;
    } else {
      summaryModel.msg = "Something Error";
      // generalResponseModel = generalResponseModelFromJson(response.response);
      // onboardingModel.msg = generalResponseModel.msg;
      return summaryModel;
    }
  }

  Future<GeneralResponseModel?> startVisit(Map<String, dynamic> body) async {
    GeneralResponseModel generalResponseModel =
        GeneralResponseModel(data: "", msg: "", status: 0);

    final response =
        await httpClient.post(endPoint: EndPoints.summaryPi, payload: body);
    generalResponseModel = generalResponseModelFromJson(response.response);
    return generalResponseModel;
  }
}
