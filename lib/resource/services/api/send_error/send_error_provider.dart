import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gov_tongdtkt_tongiao/common/utils/utils.dart';
import 'package:gov_tongdtkt_tongiao/resource/resource.dart';

class SendErrorProvider extends GetConnect {
  ///added by: tuannb 11/7/2024
  ///Thêm mới chức năng gửi lỗi;
  Future<Response> sendErrorData(Map body,
      {Function(double)? uploadProgress}) async {
    String loginData0 = AppPref.loginData;
    var json = jsonDecode(loginData0);
    TokenModel loginData = TokenModel.fromJson(json);
    Map<String, String>? headers = {
      'Authorization': 'Bearer ${AppPref.extraToken}',
      'Content-Type': 'application/json'
    };

    httpClient.timeout = const Duration(seconds: 40);
    String url =
        'http://${loginData.domainAPI}:${loginData.portAPI}/${ApiConstants.sendErrorData}';

    log('HEADER: $headers');
    log('url: $url');
    try {
      var response = await post(
        url,
        body,
        uploadProgress: uploadProgress,
        headers: headers,
      ).timeout(
        const Duration(seconds: 40),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return const Response(
              statusCode: HttpStatus.requestTimeout,
              statusText: "Request timeout");
        },
      );
      return response;
    } on TimeoutException catch (e) {
      // catch timeout here..
      return Response(
          statusCode: HttpStatus.requestTimeout, statusText: e.message);
    } catch (e) {
      // error
      return Response(
          statusCode: ApiConstants.errorException, statusText: e.toString());
    }
  }

  Future<Response> sendFullData(Map body,
      {Function(double)? uploadProgress}) async {
    String loginData0 = AppPref.loginData;
    var json = jsonDecode(loginData0);
    TokenModel loginData = TokenModel.fromJson(json);
    Map<String, String>? headers = {
      'Authorization': 'Bearer ${AppPref.extraToken}',
      'Content-Type': 'application/json'
    };

    httpClient.timeout = const Duration(seconds: 40);
    String url =
        'http://${loginData.domainAPI}:${loginData.portAPI}/${ApiConstants.sendFullData}';

    log('HEADER: $headers');
    log('url: $url');
    try {
      var response = await post(
        url,
        body,
        uploadProgress: uploadProgress,
        headers: headers,
      ).timeout(
        const Duration(seconds: 40),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return const Response(
              statusCode: HttpStatus.requestTimeout,
              statusText: "Request timeout");
        },
      );
      return response;
    } on TimeoutException catch (e) {
      // catch timeout here..
      return Response(
          statusCode: HttpStatus.requestTimeout, statusText: e.message);
    } catch (e) {
      // error
      return Response(
          statusCode: ApiConstants.errorException, statusText: e.toString());
    }
  }
}
