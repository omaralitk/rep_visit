import 'package:rep_visit/screens/doctors_screen/models/doctors_model.dart';

import '../../../core/network/constants/end_points.dart';
import '../../../core/network/http_client.dart';

class DoctorsRepo{
  Future<DoctorsModel> getDoctors() async {
    DoctorsModel doctorsModel =
    DoctorsModel(success: 0, data:null,  );
    print("----------------------");
    final response =
    await httpClient.get(endPoint: EndPoints.doctorsList);
    print("fffff ${response.response}");
    if (response.statusCode == 200) {
      doctorsModel = doctorsModelFromJson(response.response);
      return doctorsModel;
    } else {

      return doctorsModel;
    }
  }
}