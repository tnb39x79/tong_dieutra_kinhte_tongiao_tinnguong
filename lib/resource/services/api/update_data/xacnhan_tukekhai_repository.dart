import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gov_tongdtkt_tongiao/common/utils/utils.dart';
import 'package:gov_tongdtkt_tongiao/resource/resource.dart';

import 'xacnhan_tukekhai_provider.dart';

class XacnhanTukekhaiRepository {
  XacnhanTukekhaiRepository({required this.provider});
  final XacnhanTukekhaiProvider provider;

  Future<ResponseModel<String>> xacNhanTuKeKhaiCsSxkd(Map body,
      {Function(double)? uploadProgress}) async {
    if (NetworkService.connectionType == Network.none) {
      return ResponseModel.withDisconnect();
    }
    try {
      final data = await provider.xacNhanTuKeKhaiCsSxkd(body,
          uploadProgress: uploadProgress);
      if (data.statusCode == ApiConstants.success) {
        return ResponseModel(
          statusCode: ApiConstants.success,
          body: jsonEncode(data.body),
        );
      } else if (data.statusCode == HttpStatus.requestTimeout) {
        return ResponseModel.withRequestTimeout();
      } else {
        log('error: ${data.body}');
        return ResponseModel.withErrorV2(data);
      }
    } on TimeoutException catch (_) {
      return ResponseModel.withRequestTimeout();
    } catch (e) {
      return ResponseModel.withRequestException(e);
    }
  }
}
