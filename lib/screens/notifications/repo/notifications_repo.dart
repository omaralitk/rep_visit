import 'package:rep_visit/core/network/http_client.dart';
import 'package:rep_visit/core/network/models/general_response_model.dart';
import 'package:rep_visit/screens/notifications/models/notifications_model.dart';
import 'package:rep_visit/core/network/constants/end_points.dart';

import '../models/read_notification_model.dart';

class NotificationsRepo {
  Future<NotificationsModel> getNotifications() async {
    NotificationsModel notificationsModel =
        NotificationsModel(success: 0, msg: "", data: null);

    final response = await httpClient.get(endPoint: EndPoints.notifications);
    if (response.statusCode == 200) {
      print("notifications model ${response.response}");
      notificationsModel = notificationsModelFromJson(response.response);
      return notificationsModel;
    } else {
      notificationsModel.msg = "Error on get notifications";
      return notificationsModel;
    }
  }

  Future<ReadNotificationModel> readNotification(String id) async {

    ReadNotificationModel readNotificationModel =
    ReadNotificationModel(success: 0, msg: "", data: null);
    final response = await httpClient
        .post(endPoint: EndPoints.readNotification, payload: {"id": id});
    if (response.statusCode == 200) {
      readNotificationModel = readNotificationModelFromJson(response.response);
      return readNotificationModel;
    } else {
      readNotificationModel.msg = "Error on read notification";
      return readNotificationModel;
    }
  }
}
