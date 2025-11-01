import 'package:rep_visit/screens/forget_password_screen/models/forget_pass_model.dart';

import '../../../core/network/constants/end_points.dart';
import '../../../core/network/http_client.dart';

class ForgetPassRepo {
  Future<ForgetPassModel> forgetPass(Map<String, dynamic> body) async {
    ForgetPassModel forgetPass =
        ForgetPassModel(status: 0, msg: "", newPassword: "");
    print("body of request ${body}");
    print("----------------------");
    final response =
        await httpClient.post(endPoint: EndPoints.forgetPass, payload: body);
    if (response.statusCode == 200) {
      forgetPass = forgetPassModelFromJson(response.response);
      return forgetPass;
    } else {
      forgetPass.msg = "Error";
      return forgetPass;
    }
  }
}
