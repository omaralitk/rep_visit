import 'package:rep_visit/core/network/http_client.dart';
import 'package:rep_visit/core/network/models/general_response_model.dart';
import 'package:rep_visit/screens/notifications/models/notifications_model.dart';
import 'package:rep_visit/core/network/constants/end_points.dart';

class NotificationsRepo {
  Future<NotificationsModel> getNotifications() async {
    NotificationsModel notificationsModel =
        NotificationsModel(success: 0, msg: "", data: null);

    final response = await httpClient.get(endPoint: EndPoints.notifications);
    print("omaaar ${response.response}");
    if (response.statusCode == 200) {
      notificationsModel = notificationsModelFromJson(response.response);
      return notificationsModel;
    } else {
      notificationsModel.msg = "Error on get notifications";
      return notificationsModel;
    }
  }

  Future<GeneralResponseModel> readNotification(String id) async {

    GeneralResponseModel generalResponseModel =
        GeneralResponseModel(status: 0, msg: "", data: null);
    final response = await httpClient
        .post(endPoint: EndPoints.readNotification, payload: {"id": id});
    print("salah ${response.response}");
    if (response.statusCode == 200) {
      print("salah ${response.response}");
      generalResponseModel = generalResponseModelFromJson(response.response);
      return generalResponseModel;
    } else {
      generalResponseModel.msg = "Error on read notification";
      return generalResponseModel;
    }
  }
}
