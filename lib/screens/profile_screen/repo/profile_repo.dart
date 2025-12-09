import 'package:rep_visit/core/network/models/general_response_model.dart';
import 'package:rep_visit/screens/profile_screen/models/files_model.dart';
import 'package:rep_visit/screens/profile_screen/models/log_out_model.dart';

import '../../../core/network/constants/end_points.dart';
import '../../../core/network/http_client.dart';

class ProfileRepo {
  Future<LogOutModel> makeLogOut(Map<String, dynamic> body) async {
    LogOutModel logOutModel = LogOutModel(status: 0, msg: "", data: null);

    try {
      final response =
          await httpClient.post(endPoint: EndPoints.logOut, payload: body);
      if (response.statusCode == 200) {
        logOutModel = logOutModelFromJson(response.response);
        return logOutModel;
      } else {
        logOutModel.msg = "Error on Sign Out";
        return logOutModel;
      }
    } catch (e) {
      return LogOutModel(status: 0, msg: "Error on Sign Out", data: []);
    }
  }

  Future<GeneralResponseModel> updateInfo(Map<String, dynamic> body) async {
    GeneralResponseModel updateModel =
        GeneralResponseModel(status: 0, msg: "", data: null);

    try {
      final response = await httpClient.post(
          endPoint: EndPoints.updateProfile, payload: body);
      if (response.statusCode == 200) {
        updateModel = generalResponseModelFromJson(response.response);
        return updateModel;
      } else {
        updateModel.msg = "Error on update profile";
        return updateModel;
      }
    } catch (e) {
      return GeneralResponseModel(
        status: 0,
        msg: "Exception occurred while update info: $e",
        data: null,
      );
    }
  }
  Future<GeneralResponseModel> changePass(Map<String, dynamic> body) async {
    GeneralResponseModel updateModel =
        GeneralResponseModel(status: 0, msg: "", data: null);

    try {
      final response = await httpClient.post(
          endPoint: EndPoints.changePass, payload: body);
      updateModel = generalResponseModelFromJson(response.response);
      return updateModel;
    } catch (e) {
      return GeneralResponseModel(
        status: 0,
        msg: "Exception occurred while Change Password: $e",
        data: null,
      );
    }
  }

  Future<FilesModel> getFiles() async {
    try {
      final response = await httpClient.get(endPoint: EndPoints.getFiles);

      if (response.statusCode == 200) {
        return filesModelFromJson(response.response);
      } else {
        return FilesModel(
          status: 0,
          msg: "Error: Failed to fetch files",
          data: [],
        );
      }
    } catch (e) {
      return FilesModel(
        status: 0,
        msg: "Exception occurred while fetching files: $e",
        data: [],
      );
    }
  }
}
