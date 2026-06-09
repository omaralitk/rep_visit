import 'dart:convert';
import 'package:rep_visit/core/network/constants/end_points.dart';
import 'package:rep_visit/core/network/http_client.dart';
import 'package:rep_visit/core/network/models/general_response_model.dart';

import '../models/onboarding_model.dart';

class OnboardingRepository {
  Future<OnboardingModel?> getOnboardingScreens() async {
    OnboardingModel onboardingModel =
        OnboardingModel(status: 0, msg: "", data: []);
    GeneralResponseModel generalResponseModel =
        GeneralResponseModel(data: "", msg: "", status: 0);
    final response = await httpClient.get(
      endPoint: EndPoints.onboarding,
    );
    // final jsonData = json.decode(response.response);
    if (response.statusCode == 200) {
      onboardingModel = onboardingModelFromJson(response.response);
      return onboardingModel;
    } else {
      generalResponseModel = generalResponseModelFromJson(response.response);
      onboardingModel.msg = generalResponseModel.msg;
      return onboardingModel;
    }
  }
}
