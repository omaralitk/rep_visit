import 'package:rep_visit/core/network/constants/end_points.dart';
import 'package:rep_visit/core/network/http_client.dart';
import 'package:rep_visit/core/network/models/general_response_model.dart';
import 'package:rep_visit/screens/login_screen/models/login_model.dart';

class LoginRepo {
  Future<LoginModel> makeLogin(Map<String, dynamic> body) async {
    LoginModel loginModel =
        LoginModel(status: 0, msg: "", token: "", data: null);


    try {
      final response =
          await httpClient.post(endPoint: EndPoints.login, payload: body);
      // --- SUCCESS CASE ---
      if (response.statusCode == 200) {
        try {
          loginModel = loginModelFromJson(response.response);
          return loginModel;
        } catch (e) {
          loginModel.msg = "Invalid server response";
          return loginModel;
        }
      } else {
        try {

          GeneralResponseModel generalResponseModel =
              generalResponseModelFromJson(response.response);

          loginModel.msg = generalResponseModel.msg;
        } catch (e) {
          loginModel.msg = "Something went wrong";
        }

        return loginModel;
      }
    } catch (e) {
      loginModel.msg = "Network error, please try again";
      return loginModel;
    }
  }
}
