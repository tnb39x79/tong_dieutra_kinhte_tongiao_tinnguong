import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:get/get.dart';
import 'package:gov_tongdtkt_tongiao/common/utils/app_pref.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/database_helper.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/provider_p07mau.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/provider_p08.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm_bkcoso_tongiao.dart';
import 'package:gov_tongdtkt_tongiao/resource/model/reponse/response_model.dart';
import 'package:gov_tongdtkt_tongiao/resource/model/reponse/response_sync_model.dart';
import 'package:gov_tongdtkt_tongiao/resource/model/senderror/senderror_model.dart';
import 'package:gov_tongdtkt_tongiao/resource/model/sync/file_model.dart';
import 'package:gov_tongdtkt_tongiao/resource/model/sync/sync_model.dart';
import 'package:gov_tongdtkt_tongiao/resource/services/api/api_constants.dart';
import 'package:gov_tongdtkt_tongiao/resource/services/api/send_error/send_error_repository.dart';
import 'package:gov_tongdtkt_tongiao/resource/services/api/sync_data/sync_data_repository.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

mixin SyncMixin {
  Map body = {};

  final bkCoSoTonGiaoMixProvider = BKCoSoTonGiaoProvider();
  final diaBanCoSoTonGiaoMixProvider = DiaBanCoSoTonGiaoProvider();

  ///Phiếu 07 mẫu
  final phieuMauMixProvider = PhieuMauProvider();
  final phieuMauA61MixProvider = PhieuMauA61Provider();
  final phieuMauA68MixProvider = PhieuMauA68Provider();
  final phieuMauSanPhamMixProvider = PhieuMauSanphamProvider();

  ///Phiếu 08 tôn giáo, tín ngưỡng
  final phieuTonGiaoMixProvider = PhieuTonGiaoProvider();
  final phieuTonGiaoA43MixProvider = PhieuTonGiaoA43Provider();

  final danhSachBkDiaBanTonGiaoInterviewed = <TableBkTonGiao>[].obs;

  Future<ResponseSyncModel> syncDataMixin(SyncRepository syncRepository,
      SendErrorRepository sendErrorRepository, progress,
      {bool isRetryWithSignIn = false}) async {
    await getData();

    return await uploadDataMixin(syncRepository, sendErrorRepository, progress,
        isRetryWithSignIn: false);
  }

  getData() async {
    await getListInterviewed();
    await getBody();
  }

  Future getBody() async {
    await Future.wait([
      getDataTonGiao(),
    ]);
    developer.log('GET BODY: ${jsonEncode(body)}');
  }

  Future getListInterviewed() async {
    List<Map>? interviewed =
        await bkCoSoTonGiaoMixProvider.selectAllListInterviewedSync();
    danhSachBkDiaBanTonGiaoInterviewed.clear();
    if (interviewed.isNotEmpty) {
      for (var element in interviewed) {
        danhSachBkDiaBanTonGiaoInterviewed
            .add(TableBkTonGiao.fromJson(element));
      }
    }
  }

  Future<Map> getPhieuMaus(String iDCoSo) async {
    Map mapP07Mau = {};

    Map phieuMau = await phieuMauMixProvider.selectByIdCoSo(iDCoSo);
    List<Map> phieuMauA61s =
        await phieuMauA61MixProvider.selectByIdCosoSync(iDCoSo);
    List<Map> phieuMauA68s =
        await phieuMauA68MixProvider.selectByIdCosoSync(iDCoSo);
    List<Map> phieuMauSanphams =
        await phieuMauSanPhamMixProvider.selectByIdCoSo(iDCoSo);
    if (phieuMau.isNotEmpty) {
      mapP07Mau['PhieuCaThe_Mau'] = phieuMau;
      mapP07Mau['PhieuCaThe_Mau_A61Dtos'] = phieuMauA61s;
      mapP07Mau['PhieuCaThe_Mau_A68Dtos'] = phieuMauA68s;
      mapP07Mau['PhieuCaThe_Mau_SanPhams'] = phieuMauSanphams;
    }

    return mapP07Mau;
  }

  Future getDataTonGiao() async {
    List<Map> tonGiao = [];

    await Future.wait(danhSachBkDiaBanTonGiaoInterviewed.map((item) async {
      var map = {
        "IDCoso": item.iDCoSo,
        "TenCoSo": item.tenCoSo,
        "MaTinh": item.maTinh,
        "MaHuyen": item.maHuyen,
        "MaXa": item.maXa,
        "MaThon": item.maThon,
        "TenThon": item.tenThon,
        "DiaChi": item.diaChi,
        "DienThoai": item.dienThoai,
        "Email": item.email,
        "MaTinhTrangHD": item.maTinhTrangHD
      };

      Map phieuTonGiaos = await getPhieuTonGiaos(item.iDCoSo!);
      if (phieuTonGiaos.isNotEmpty) map['PhieuTonGiaos'] = phieuTonGiaos;
      tonGiao.add(map);
    }));
    body['TonGiaoData'] = tonGiao;
    return tonGiao;
  }

  Future<Map> getPhieuTonGiaos(String idCoSo) async {
    Map mapPhieuTonGiao = {};
    Map phieuTonGiao = await phieuTonGiaoMixProvider.selectByIdCoSo(idCoSo);

    List<Map> phieuso05SanphamC16s =
        await phieuTonGiaoA43MixProvider.selectByIdCoSoSync(idCoSo);
    if (phieuTonGiao.isNotEmpty) {
      mapPhieuTonGiao['PhieuTonGiao'] = phieuTonGiao;
      mapPhieuTonGiao['PhieuTonGiao_A4_3Dtos'] = phieuso05SanphamC16s;
    }
    return mapPhieuTonGiao;
  }

  Future<ResponseSyncModel> uploadDataMixin(SyncRepository syncRepository,
      SendErrorRepository sendErrorRepository, progress,
      {bool isRetryWithSignIn = false}) async {
    developer.log('BODY: ${json.encode(body)}');
    // developer.log('BODY: $body');
    print('$body');
    var resCode = '';
    var errorMessage = '';
    var mustSendErrorToServer = false;

    //  await Future.delayed(const Duration(milliseconds: 1000000));
    ResponseModel request = await syncRepository.syncDataV2(body,
        uploadProgress: (value) => progress.value = value);

    ///TRẢ LẠI SAU
    developer.log('SYNC SUCCESS: ${request.body}');
    if (request.statusCode == ApiConstants.errorToken && !isRetryWithSignIn) {
      var resp = await syncRepository.getToken(
          userName: AppPref.userName ?? '', password: AppPref.password ?? '');
      AppPref.extraToken = resp.body?.accessToken;
      uploadDataMixin(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: true);
    }

    if (request.statusCode == 200) {
      SyncModel syncData = SyncModel.fromJson(jsonDecode(request.body));

      if (syncData.responseCode == ApiConstants.responseSuccess) {
        var coSoTGSuccess =
            jsonDecode(request.body)["Data"]["TonGiaoData"] as List;

        var idCoSoTGs = coSoTGSuccess
            .where((element) => element["ErrorMessage"] == null)
            .map((e) => e['IDCoSo'])
            .toList();

        bkCoSoTonGiaoMixProvider.updateSuccess(idCoSoTGs);

        ResponseSyncModel responseSyncModel = ResponseSyncModel(
            isSuccess: true,
            responseCode: syncData.responseCode,
            responseMessage: syncData.responseMessage,
            syncResults: syncData.syncResults);

        return responseSyncModel;
      } else {
        if (syncData.responseCode == ApiConstants.invalidModelSate) {
          errorMessage = "Dữ liệu đầu vào không đúng định dạng.";
          developer
              .log('syncData.responseMessage: ${syncData.responseMessage}');
        } else if (syncData.responseCode == ApiConstants.khoaCAPI) {
          errorMessage = "Khóa CAPI đang bật.";
        } else if (syncData.responseCode == ApiConstants.duLieuDongBoRong) {
          errorMessage = "${syncData.responseMessage}";
        } else {
          errorMessage = "Lỗi đồng bộ:${syncData.responseMessage}";
        }
        uploadFullDataJson(syncRepository, sendErrorRepository, progress,
            isRetryWithSignIn: false);
        ResponseSyncModel responseSyncModel = ResponseSyncModel(
            isSuccess: false,
            responseCode: syncData.responseCode,
            responseMessage: errorMessage);
        return responseSyncModel;
      }
    } else if (request.statusCode == 401) {
      errorMessage = 'Tài khoản đã hết hạn, vui lòng đăng nhập và đồng bộ lại.';
    } else if (request.statusCode == ApiConstants.errorDisconnect) {
      errorMessage = 'Kết nối mạng đã bị ngắt. Vui lòng kiểm tra lại.';
    } else if (request.statusCode == ApiConstants.errorException) {
      mustSendErrorToServer = true;
      errorMessage = 'Có lỗi: ${request.message}';
    } else if (request.statusCode == HttpStatus.requestTimeout) {
      mustSendErrorToServer = true;
      resCode = request.statusCode.toString();
      errorMessage = 'Request timeout.';
    } else if (request.statusCode == HttpStatus.internalServerError) {
      mustSendErrorToServer = true;
      errorMessage = 'Có lỗi: ${request.message}';
    } else {
      mustSendErrorToServer = true;
      errorMessage =
          'Đã có lỗi xảy ra, vui lòng kiểm tra kết nối internet và thử lại!';
    }
    if (mustSendErrorToServer) {
      uploadDataJsonMixin(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: false);
      uploadFullDataJson(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: false);
    }
    ResponseSyncModel responseSyncModel = ResponseSyncModel(
        isSuccess: false,
        responseCode: request.statusCode.toString(),
        responseMessage: errorMessage);
    return responseSyncModel;
  }

  /// uploadDataJson sử dụng khi đồng bộ dữ liệu phát sinh lỗi;
  Future<ResponseSyncModel> uploadDataJsonMixin(SyncRepository syncRepository,
      SendErrorRepository sendErrorRepository, progress,
      {bool isRetryWithSignIn = false}) async {
    developer.log('BODY: ${json.encode(body)}');
    developer.log('BODY: $body');
    print('$body');
    var errorMessage = '';
    var responseCode = '';
    var isSuccess = false;
    ResponseModel request = await sendErrorRepository.sendErrorData(body,
        uploadProgress: (value) => progress.value = value);
    developer.log('SEND DATA JSON SYNCERROR SUCCESS: ${request.body}');

    if (request.statusCode == ApiConstants.errorToken && !isRetryWithSignIn) {
      var resp = await syncRepository.getToken(
          userName: AppPref.userName, password: AppPref.password);
      AppPref.accessToken = resp.body?.accessToken;
      uploadDataJsonMixin(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: true);
    }
    responseCode = request.statusCode.toString();
    if (request.statusCode == 200) {
      SendErrorModel dataSend =
          SendErrorModel.fromJson(jsonDecode(request.body));
      errorMessage = dataSend.responseMessage ?? '';
      responseCode = dataSend.responseCode ?? '';

      if (dataSend.responseCode == ApiConstants.responseSuccess) {
        errorMessage = dataSend.responseMessage ?? '';
        isSuccess = true;
      } else {}
    } else if (request.statusCode == 401) {
      errorMessage = 'Tài khoản đã hết hạn, vui lòng đăng nhập và đồng bộ lại.';
    } else if (request.statusCode == ApiConstants.errorDisconnect) {
      errorMessage = 'Kết nối mạng đã bị ngắt. Vui lòng kiểm tra lại.';
    } else if (request.statusCode == ApiConstants.errorException) {
      errorMessage = 'Có lỗi: ${request.message}';
    } else if (request.statusCode.toString() ==
        ApiConstants.notAllowSendFile) {
      errorMessage = request.message ??
          'Bạn chưa được phân quyền thực hiện chức năng này.';
    } else if (request.statusCode.toString() ==
        ApiConstants.errorMaDTVNotFound) {
      errorMessage = request.message ?? 'Không tìm thấy dữ liệu';
    } else if (request.statusCode == HttpStatus.requestTimeout) {
      errorMessage = 'Request timeout.';
    } else if (request.statusCode == HttpStatus.internalServerError) {
      errorMessage = 'Có lỗi: ${request.message}';
    } else {
      errorMessage =
          'Đã có lỗi xảy ra, vui lòng kiểm tra kết nối internet và thử lại!';
    }
    developer.log('_request.statusCode uploadDataJson ${request.statusCode}');
    ResponseSyncModel responseSyncModel = ResponseSyncModel(
        isSuccess: isSuccess,
        responseCode: responseCode,
        responseMessage: errorMessage);
    return responseSyncModel;
  }

  Future<ResponseSyncModel> uploadFullDataJson(SyncRepository syncRepository,
      SendErrorRepository sendErrorRepository, progress,
      {bool isRetryWithSignIn = false}) async { 
    var errorMessage = '';
    var responseCode = '';
    var isSuccess = false;

    var fileModel = await getDbFileContent();
    developer.log('FILE MODEL: ${fileModel.toJson()}');

    ResponseModel request = await sendErrorRepository.sendFullData(fileModel,
        uploadProgress: (value) => progress.value = value);
    developer.log('SEND FULL DATA SUCCESS: ${request.body}');

    if (request.statusCode == ApiConstants.errorToken && !isRetryWithSignIn) {
      var resp = await syncRepository.getToken(
          userName: AppPref.userName, password: AppPref.password);
      AppPref.accessToken = resp.body?.accessToken;
      uploadFullDataJson(syncRepository, sendErrorRepository, progress,
          isRetryWithSignIn: true);
    }
    responseCode = request.statusCode.toString();
    if (request.statusCode == 200) {
      SendErrorModel dataSend =
          SendErrorModel.fromJson(jsonDecode(request.body));
      errorMessage = dataSend.responseMessage ?? '';
      responseCode = dataSend.responseCode ?? '';

      if (dataSend.responseCode == ApiConstants.responseSuccess) {
        errorMessage = dataSend.responseMessage ?? '';
        isSuccess = true;
      } else {}
    } else if (request.statusCode == 401) {
      errorMessage = 'Tài khoản đã hết hạn, vui lòng đăng nhập và đồng bộ lại.';
    } else if (request.statusCode == ApiConstants.errorDisconnect) {
      errorMessage = 'Kết nối mạng đã bị ngắt. Vui lòng kiểm tra lại.';
    } else if (request.statusCode == ApiConstants.errorException) {
      errorMessage = 'Có lỗi: ${request.message}';
    } else if (request.statusCode.toString() ==
        ApiConstants.notAllowSendFile) {
      errorMessage = request.message ??
          'Bạn chưa được phân quyền thực hiện chức năng này.';
    } else if (request.statusCode.toString() ==
        ApiConstants.errorMaDTVNotFound) {
      errorMessage = request.message ?? 'Không tìm thấy dữ liệu';
    } else if (request.statusCode == HttpStatus.requestTimeout) {
      errorMessage = 'Request timeout.';
    } else if (request.statusCode == HttpStatus.internalServerError) {
      errorMessage = 'Có lỗi: ${request.message}';
    } else {
      errorMessage =
          'Đã có lỗi xảy ra, vui lòng kiểm tra kết nối internet và thử lại!';
    }
    developer.log('_request.statusCode uploadDataJson ${request.statusCode}');
    ResponseSyncModel responseSyncModel = ResponseSyncModel(
        isSuccess: isSuccess,
        responseCode: responseCode,
        responseMessage: errorMessage);
    return responseSyncModel;
  }

  Future<FileModel> getDbFileContent() async {
    String dbBackUpDir = 'dbbackup';
    String dbPath = await DatabaseHelper.instance.getMyDatabasePath();
    String dbFilePath=p.join(dbPath,'DTKinhTeTonGiao.db');
    final dbFile = File(dbFilePath);
    final dbFileName = p.basename(dbFile.path);

    // Directory directory = Directory("");
    // if (Platform.isAndroid) {
    //   directory = (await getExternalStorageDirectory())!;
    // } else {
    //   directory = (await getApplicationDocumentsDirectory());
    // }
    // var dirPath = await createFolder(dbBackUpDir);
    // try {
    //   final dir = Directory(dirPath);
    //   final List<FileSystemEntity> files = dir.listSync();
    //   for (final FileSystemEntity file in files) {
    //     await file.delete();
    //   }
    // } catch (e) {
    //   // Error in getting access to the file.
    // }
    // //String dtNow= DateTime.now().toIso8601String();
    // String dtNow = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    // String filePathBk = p.join(dirPath,'bk_dtkt_$dtNow.db');
   // File dbFileCopied = await dbFile.copy(filePathBk);
var isexistDbFile=   dbFile.existsSync();

    final fileBytes = dbFile.readAsBytesSync();
    final fileBase64 = base64Encode(fileBytes);

    var fileModel =
        FileModel(fileName: dbFileName, dataFileContent: fileBase64);
    return fileModel;
  }

  // Future<String> createFolder(String cow) async {
  //   final dir = Directory(
  //       '${(Platform.isAndroid ? await getExternalStorageDirectory() //FOR ANDROID
  //               : await getApplicationDocumentsDirectory() //FOR IOS
  //           )!.path}/$cow');
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     await Permission.storage.request();
  //   }
  //   if ((await dir.exists())) {
  //     return dir.path;
  //   } else {
  //     dir.create();
  //     return dir.path;
  //   }
  // }
}
