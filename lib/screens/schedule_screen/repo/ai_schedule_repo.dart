import 'package:rep_visit/core/network/models/general_response_model.dart';
import 'package:rep_visit/screens/schedule_screen/models/add_schedule_model.dart';
import 'package:rep_visit/screens/schedule_screen/models/ai_schedule_model.dart';
import 'package:rep_visit/screens/schedule_screen/models/get_ai_schedule_model.dart';

import '../../../core/network/constants/end_points.dart';
import '../../../core/network/http_client.dart';

class AiScheduleRepo {
  Future<GetAiScheduleModel> getVisits() async {
    GetAiScheduleModel getDailyVisitsModel =
        GetAiScheduleModel(success: 0, msg: "", data: []);
    print("----------------------");
    final response = await httpClient.get(endPoint: EndPoints.dailyVisits);
    if (response.statusCode == 200) {
      getDailyVisitsModel = getAiScheduleModelFromJson(response.response);
      return getDailyVisitsModel;
    } else {
      getDailyVisitsModel = getAiScheduleModelFromJson(response.response);
      return getDailyVisitsModel;
    }
  }

  Future<AiSchedulModel> getAiVisits(Map<String, double> body) async {
    AiSchedulModel aiSchedulModel = AiSchedulModel(success: 0, data: []);
    GeneralResponseModel generalResponseModel =
        GeneralResponseModel(data: null, msg: "", status: 0);
    print("----------------------");
    print("Request ${body}");

    final response =
        await httpClient.post(endPoint: EndPoints.letAiSchedule, payload: body);
    print("Response ${response.response}");
    if (response.statusCode == 200) {
      aiSchedulModel = aiSchedulModelFromJson(response.response);
      return aiSchedulModel;
    } else {
      aiSchedulModel = aiSchedulModelFromJson(response.response);
      return aiSchedulModel;
    }
  }

  Future<AddScheduleVisitsModel> addVisits(Map<String, dynamic> body) async {
    AddScheduleVisitsModel addScheduleVisitsModel =
        AddScheduleVisitsModel(success: 0, msg: "", data: []);

    final response =
        await httpClient.post(endPoint: EndPoints.dailyVisits, payload: body);
    if (response.statusCode == 200) {
      addScheduleVisitsModel =
          addScheduleVisitsModelFromJson(response.response);
      return addScheduleVisitsModel;
    } else {
      addScheduleVisitsModel.msg = "Error in Add visits";
      return addScheduleVisitsModel;
    }
  }
}
