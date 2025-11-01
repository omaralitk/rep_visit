

import 'package:rep_visit/core/network/models/request_status.dart';

class ApiResponseHandler {
  final RequestStatus status;
  final int? statusCode;
  final dynamic response;

  ApiResponseHandler({this.status = RequestStatus.initial, this.statusCode, this.response});

  ApiResponseHandler copyWith({RequestStatus? status, int? statusCode, dynamic response}) {
    return ApiResponseHandler(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      response: response ?? this.response,
    );
  }
}