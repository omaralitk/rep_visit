import 'package:rep_visit/core/network/constants/end_points.dart';
import 'package:rep_visit/core/network/http_client.dart';
import 'package:rep_visit/screens/login_screen/models/login_model.dart';

class LoginRepo {
  Future<LoginModel> makeLogin(Map<String, dynamic> body) async {
    LoginModel loginModel =
        LoginModel(status: 0, msg: "", token: "", data: null);
    print("body of request ${body}");
    print("----------------------");
    final response =
        await httpClient.post(endPoint: EndPoints.login, payload: body);
    if (response.statusCode == 200) {
      loginModel = loginModelFromJson(response.response);
      return loginModel;
    } else {
      loginModel.msg = "Error on login";
      return loginModel;
    }
  }
}
