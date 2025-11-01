import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:rep_visit/core/network/constants/network_constants.dart';

import 'models/api_response_handler.dart';

class HttpClient {
  static final http.Response _timeoutResponse =
      http.Response('Timeout', HttpStatus.networkConnectTimeoutError);

  Future<ApiResponseHandler> get({required String endPoint}) async {
    try {
      var header = await NetworkConstants.getHeaders();

      final response = await http
          .get(Uri.parse(endPoint), headers: header)
          .timeout(const Duration(minutes: 1),
              onTimeout: () => _responseHandler(_timeoutResponse));

      return _responseHandler(response);
    } on TimeoutException catch (_) {
      return _responseHandler(_timeoutResponse);
    } catch (ex) {
      return _responseHandler(http.Response(ex.toString(), 9999));
    }
  }

  Future<ApiResponseHandler> post({
    required String endPoint,
    dynamic payload,
  }) async
  {
    try {
      var header = await NetworkConstants.getHeaders();

      final response = await http
          .post(
        Uri.parse(endPoint),
        headers: header,
        body: jsonEncode(payload),
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () => _responseHandler(_timeoutResponse),
      );

      return _responseHandler(response);
    } on TimeoutException catch (_) {
      return _responseHandler(_timeoutResponse);
    } catch (ex) {
      return _responseHandler(http.Response(ex.toString(), 9999));
    }
  }


  _responseHandler(http.Response response) {
    log('____________________________________________________');
    log('${response.request?.headers}');
    log('${response.request?.url.toString()}: ${response.statusCode.toString()}');
    // log(response.body);
    log('____________________________________________________');

    return ApiResponseHandler(
        statusCode: response.statusCode, response: _handleBody(response));
  }

  _handleBody(http.Response response) {
    if (response.statusCode == HttpStatus.ok) {
      return response.body;
    } else {
      return Exception(response.body);
    }
  }
}

HttpClient httpClient = HttpClient();
