import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:rep_visit/base/ui/widgets/loading_widget.dart';
import 'package:rep_visit/screens/doctors_screen/models/add_to_list_model.dart';
import 'package:rep_visit/screens/doctors_screen/models/doctors_model.dart';
import 'package:rep_visit/screens/doctors_screen/models/doctors_request_model.dart';
import 'package:rep_visit/screens/doctors_screen/models/my_doctors_model.dart';

import '../../../core/network/constants/end_points.dart';
import '../../../core/network/http_client.dart';
import '../models/bulk_model.dart';
import '../models/filters_model.dart' show FiltersModel, filtersModelFromJson;
import '../models/individual_model.dart' as individual;

class DoctorsRepo {
  Future<DoctorsModel> getDoctors({
    String? category,
    String? speciality,
    String? area,
    String? search,
  }) async {
    DoctorsModel doctorsModel = DoctorsModel(
      status: 0,
      msg: "",
      data: [],
      companyId: 0,
    );

    final uri = Uri.parse(EndPoints.doctorsList);

    final queryParams = <String, String>{};
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    if (speciality != null && speciality.isNotEmpty) {
      queryParams['speciality'] = speciality;
    }
    if (area != null && area.isNotEmpty) {
      queryParams['area'] = area;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final url = uri.replace(queryParameters: {
      ...uri.queryParameters,
      ...queryParams,
    }).toString();

    final response = await httpClient.get(endPoint: url);
    if (response.statusCode == 200) {
      doctorsModel = doctorsModelFromJson(response.response);
    }

    return doctorsModel;
  }

  Future<BulkResponse> saveDoctorSchedule(Map<String, dynamic> body) async {
    BulkResponse bulkResponse = BulkResponse(
      success: 0,
      msg: "",
      data: null,
    );

    final response = await httpClient.post(
        endPoint: EndPoints.saveDoctorSchedule, payload: body);

    if (response.statusCode == 200) {

      bulkResponse = bulkResponseFromJson(response.response);
    } else {
      bulkResponse.msg = "Error in save doctor schedule".tr();
    }
    return bulkResponse;
  }

  Future<individual.IndividualModel> saveIndividualSchedule(
      Map<String, dynamic> body) async {
    individual.IndividualModel individualModel = individual.IndividualModel(
      success: 0,
      msg: "",
      data: individual.Data(
        doctorId: 0,
        doctorName: "",
        scheduleType: "",
        schedules: [],
        message: "",
      ),
    );

    final response = await httpClient.post(
        endPoint: EndPoints.saveDoctorSchedule, payload: body);
    if (response.statusCode == 200) {

      individualModel = individual.individualModelFromJson(response.response);
    } else {
      individualModel.msg = "Error in save individual schedule".tr();
    }
    return individualModel;
  }

  Future<FiltersModel> getFilters() async {
    FiltersModel filtersModel = FiltersModel(
      status: 0,
      msg: "",
      data: null,
    );
    final response = await httpClient.get(endPoint: EndPoints.getFilters);
    if (response.statusCode == 200) {
      filtersModel = filtersModelFromJson(response.response);
    } else {
      filtersModel.msg = "Error in get filters".tr();
      filtersModel.status = 0;
      filtersModel.data = null;
    }
    return filtersModel;
  }

  Future<GetMyDoctorsModel> getMyDoctors() async {
    GetMyDoctorsModel getMyDoctorsModel = GetMyDoctorsModel(
      status: 0,
      msg: "",
      data: [],
      count: 0,
    );
    final response = await httpClient.get(endPoint: EndPoints.myDoctors);
    if (response.statusCode == 200) {
      getMyDoctorsModel = getMyDoctorsModelFromJson(response.response);
    } else {
      getMyDoctorsModel.msg = "Error in get my doctors".tr();
      getMyDoctorsModel.status = 0;
      getMyDoctorsModel.data = [];
      getMyDoctorsModel.count = 0;
    }
    return getMyDoctorsModel;
  }

  Future<DoctorRequestModel> addDoctorRequest(Map<String, dynamic> body) async {
    DoctorRequestModel doctorRequestModel = DoctorRequestModel(
      status: 0,
      msg: "",
      data: null,
    );
    LoadingWidget.show();

    // Format request body as readable string
    print("omar request doctor ${jsonEncode(body)}");
    final response = await HttpClient()
        .post(endPoint: EndPoints.addDoctorRequest, payload: body);
    print("Response: ${response.response}");
    print("Status code: ${response.statusCode}");
    LoadingWidget.hide();
    if (response.statusCode == 201 || response.statusCode == 200) {
      print("omar doctor request model ${response.response}");
      doctorRequestModel = doctorRequestModelFromJson(response.response);
    } else {}
    return doctorRequestModel;
  }

  Future<AddToListModel> addToMyList(Map<String, dynamic> body) async {
    AddToListModel addToListModel = AddToListModel(
      status: 0,
      msg: "",
      data: null,
    );

    LoadingWidget.show();

    // Format request body as readable string
    print("Add to my list request: ${jsonEncode(body)}");
    final response =
        await HttpClient().post(endPoint: EndPoints.myDoctors, payload: body);
    print("Add to my list response: ${response.response}");
    print("Status code: ${response.statusCode}");
    LoadingWidget.hide();
    if (response.statusCode == 201 || response.statusCode == 200) {
      print("Add to my list model: ${response.response}");
      try {
        addToListModel = addToListModelFromJson(response.response);
      } catch (e) {
        print("Error parsing add to list response: $e");
        // If parsing fails, try to extract status and msg manually
        try {
          final jsonData = jsonDecode(response.response);
          addToListModel.status = jsonData["status"] ?? 0;
          addToListModel.msg =
              jsonData["msg"] ?? "Error adding doctors to list".tr();
          addToListModel.data = null;
        } catch (e2) {
          print("Error parsing JSON: $e2");
          addToListModel.msg = "Error adding doctors to list".tr();
        }
      }
    } else {
      addToListModel.msg = "Error adding doctors to list".tr();
    }
    return addToListModel;
  }
}
