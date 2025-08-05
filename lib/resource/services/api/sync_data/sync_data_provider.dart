import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gov_tongdtkt_tongiao/common/utils/utils.dart';
import 'package:gov_tongdtkt_tongiao/resource/resource.dart';
import 'package:http/http.dart' as http;

class SyncProvider extends GetConnect {
  // @override
  // void onInit() {
  //   httpClient.timeout = const Duration(seconds: 20); // default timeout = 8 s,
  //   httpClient.addAuthenticator(authInterceptor);
  //   httpClient.addResponseModifier(responseInterceptor);
  // }

  ///added by: tuannb 10/7/2024
  ///Thêm mới: syncDataV2 thông báo khi gọi api bị timeout;
  Future<Response> syncDataV2(Map body,
      {Function(double)? uploadProgress}) async {
    String loginData0 = AppPref.loginData;
    var json = jsonDecode(loginData0);
    TokenModel loginData = TokenModel.fromJson(json);
    Map<String, String>? headers = {
      'Authorization': 'Bearer ${AppPref.extraToken}',
      'Content-Type': 'application/json'
    };
    httpClient.timeout = const Duration(seconds: 30);
    String url =
        'http://${loginData.domainAPI}:${loginData.portAPI}/${ApiConstants.sync}';

    log('HEADER: $headers');
    log('url: $url');
    try {
      var response = await post(
        url,
        body,
        uploadProgress: uploadProgress,
        headers: headers,
      ).timeout(
        const Duration(seconds: 30),
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

  Future<http.StreamedResponse> getToken({
    required Map<String, String> params,
    required Map<String, String> body,
  }) async {
    String credentials =
        "${ApiConstants.basicUserName}:${ApiConstants.basicPass}";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);

    //header
    var headers = {
      'Authorization': 'Basic $encoded',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    String loginData = AppPref.loginData;
    TokenModel model = loginData.isNotEmpty
        ? TokenModel.fromJson(jsonDecode(loginData))
        : TokenModel();

    var request = http.Request(
        'POST',
        Uri.parse(
            '${'http://${model.domainAPI}:${model.portAPI}/'}${ApiConstants.getToken}'));
    request.headers.addAll(headers);
    request.followRedirects = false;
    request.bodyFields = body;

    http.StreamedResponse response = await request.send();

    return response;
  }
}
