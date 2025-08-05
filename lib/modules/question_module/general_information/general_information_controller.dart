import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gov_tongdtkt_tongiao/config/constants/app_define.dart';
import 'package:gov_tongdtkt_tongiao/modules/question_module/question_no07/question_no07_controller.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/dm_bkcoso_sxkd_nganh_sanpham_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/dm_mota_sanpham_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/phieu_07_mau_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/phieu_08_tongiao_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/provider_p07mau.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/provider_p07mau_dm.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_data.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm.dart';
import 'package:gov_tongdtkt_tongiao/common/common.dart';
import 'package:gov_tongdtkt_tongiao/modules/modules.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm_bkcoso_sxkd_nganh_sanpham.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm_bkcoso_tongiao.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_phieu_07_mau_sanpham.dart';
import 'package:gov_tongdtkt_tongiao/resource/resource.dart';
import 'package:gov_tongdtkt_tongiao/routes/routes.dart';

class GeneralInformationController extends BaseController {
  static const giMaDoiTuongDTKey = 'maDoiTuongDT';
  static const giMaDiaBanKey = 'maDiaBan';
  static const giMaDiaBanTGKey = 'maDiaBanTG';
  static const giMaXaKey = 'maXa';
  static const giTenDoiTuongDTKey = "tenDoiTuongDT";
  static const giCoSoSXKDIdKey = "coSoSXKDId";
  static const giMaTinhTrangDTKey = "maTinhTrangDT";

  ///BEGIN::Thông tin cơ sở sxkd
  final maTinhController = TextEditingController();
  final tenTinhController = TextEditingController();
  final maHuyenController = TextEditingController();
  final tenHuyenController = TextEditingController();
  final maXaController = TextEditingController();
  final tenXaController = TextEditingController();
  final coSoSoTextController = TextEditingController();
  final coSoSoGiaTriController = TextEditingController();
  final tenCoSoController = TextEditingController();
  final dienThoaiController = TextEditingController();
  final emailController = TextEditingController();
  final maThonController = TextEditingController();
  final tenThonController = TextEditingController();
  final tenNganhVSIC5SoController = TextEditingController();
  final maNganhController = TextEditingController();

  ///END::Thông tin cơ sở sxkd
  ///
  ///BEGIN::Thông tin hộ
  final maDiaBanController = TextEditingController();
  final tenDiaBanController = TextEditingController();
  final hoSoController = TextEditingController();
  final tenChuHoController = TextEditingController();
  final maDanTocController = TextEditingController();
  final tenDanTocController = TextEditingController();
  final diaChiChuHoController = TextEditingController();
  final ttNTController = TextEditingController();

  final tenNganhController = TextEditingController();
  final moTaSPDuocChonController = TextEditingController();

  ///END::Thông tin hộ
  ///
  final HomeController homeController = Get.find();
  final MainMenuController mainMenuController = Get.find();

  /// RX
  final tblBkTonGiao = TableBkTonGiao().obs;
  final tblBkCoSoSXKD = TableBkCoSoSXKD().obs;
  //final tblBkCoSoSXKDNganhSanPham = <TableBkCoSoSXKDNganhSanPham>[].obs;
  final tblBkCoSoSXKDNganhSanPham = TableBkCoSoSXKDNganhSanPham().obs;
  final screenNos = <int>[].obs;
  final currentScreenNo = 0.obs;

  /// provider
  final dataProvider = DataProvider();
  final bkCoSoTonGiaoProvider = BKCoSoTonGiaoProvider();
  final bkCoSoSXKDProvider = BKCoSoSXKDProvider();
  final bkCoSoSXKDNganhSanPhamProvider = BKCoSoSXKDNganhSanPhamProvider();

  final phieuMauProvider = PhieuMauProvider();
  final phieuMauSanphamProvider = PhieuMauSanphamProvider();
  final phieuTonGiaoProvider = PhieuTonGiaoProvider();
  //final dmNhomNganhVcpaProvider = CTDmNhomNganhVcpaProvider();
  final dmMotaSanphamProvider = DmMotaSanphamProvider();

  /// param
  String? currentIdHoDuPhong;
  String? currentIdCoSoDuPhong;
  String? currentMaDoiTuongDT;
  String? currentTenDoiTuongDT;
  String? currentMaTinhTrangDT;
  String? currentMaDiaBan;
  String? currentMaDiaBanTG;
  String? currentIdCoSoTG;
  String? currentIdCoSo;
  String? currentMaXa;
  String? currentMaVCPACap1;

  @override
  void onInit() async {
    setLoading(true);
    if (homeController.isDefaultUserType()) {
      final interviewListDetailController =
          Get.find<InterviewListDetailController>();
      currentMaDoiTuongDT = interviewListDetailController.currentMaDoiTuongDT;
      currentTenDoiTuongDT = interviewListDetailController.currentTenDoiTuongDT;
      currentMaTinhTrangDT = interviewListDetailController.currentMaTinhTrangDT;
      currentIdCoSo = interviewListDetailController.currentIdCoSo;
      currentMaXa = interviewListDetailController.currentMaXa;
      currentMaDiaBan = interviewListDetailController.currentMaDiaBan;
      currentMaDiaBanTG = interviewListDetailController.currentMaDiaBanTG;
      currentIdCoSoTG = interviewListDetailController.currentIdCoSoTG ?? '';
    } else {
      currentMaDoiTuongDT = Get.parameters[giMaDoiTuongDTKey]!;
      currentTenDoiTuongDT = Get.parameters[giTenDoiTuongDTKey]!;
      currentMaTinhTrangDT = Get.parameters[giMaTinhTrangDTKey]!;
      currentIdCoSo = Get.parameters[giCoSoSXKDIdKey]!;
      currentMaXa = Get.parameters[giMaXaKey]!;
      currentMaDiaBan = Get.parameters[giMaDiaBanKey]!;
      //currentMaDiaBanTG = interviewListDetailController.currentMaDiaBanTG;
      // currentIdCoSoTG = interviewListDetailController.currentIdCoSoTG ?? '';
    }
    await getGeneralInformation();
    await getScreenNo();
    setLoading(false);
    super.onInit();
  }

  Future getGeneralInformation() async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString() ||
        currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      // String idCoso =
      //     currentIdCoSoDuPhong != null ? currentIdCoSoDuPhong! : currentIdCoSo!;

      var map = await bkCoSoSXKDProvider.getInformation(currentIdCoSo!);
      log(map.toString());
      if (map != null) {
        tblBkCoSoSXKD.value = TableBkCoSoSXKD.fromJson(map);

        maTinhController.text = tblBkCoSoSXKD.value.maTinh ?? '';
        tenTinhController.text = tblBkCoSoSXKD.value.tenTinh ?? '';

        maHuyenController.text = tblBkCoSoSXKD.value.maHuyen ?? '';
        tenHuyenController.text = tblBkCoSoSXKD.value.tenHuyen ?? '';

        maXaController.text = tblBkCoSoSXKD.value.maXa ?? '';
        tenXaController.text = tblBkCoSoSXKD.value.tenXa ?? '';

        maThonController.text = tblBkCoSoSXKD.value.maThon ?? '';
        tenThonController.text = tblBkCoSoSXKD.value.tenThon ?? '';
        coSoSoTextController.text = tblBkCoSoSXKD.value.tenThon ?? '';
        maDiaBanController.text = tblBkCoSoSXKD.value.maDiaBan ?? '';
        tenDiaBanController.text = tblBkCoSoSXKD.value.tenDiaBan ?? '';
        coSoSoGiaTriController.text = '';
        tenCoSoController.text = tblBkCoSoSXKD.value.tenCoSo ?? '';
        diaChiChuHoController.text = tblBkCoSoSXKD.value.diaChi ?? '';
        dienThoaiController.text = tblBkCoSoSXKD.value.dienThoai ?? '';
        emailController.text = tblBkCoSoSXKD.value.email ?? '';

        var mapMaNganhs =
            await bkCoSoSXKDNganhSanPhamProvider.selectByIdCoSo(currentIdCoSo!);
        if (mapMaNganhs != null) {
          var nganhSP =
              TableBkCoSoSXKDNganhSanPham.listFromJson(mapMaNganhs).firstOrNull;
          if (nganhSP != null) {
            tblBkCoSoSXKDNganhSanPham.value = nganhSP;
          }
          maNganhController.text =
              tblBkCoSoSXKDNganhSanPham.value.maNganh ?? '';
          tenNganhController.text =
              tblBkCoSoSXKDNganhSanPham.value.tenNganh ?? '';
        }
      }
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_08.toString()) {
      var map = await bkCoSoTonGiaoProvider.getInformation(currentIdCoSoTG!);
      if (map != null) {
        tblBkTonGiao.value = TableBkTonGiao.fromJson(map);
        maTinhController.text = tblBkTonGiao.value.maTinh ?? '';
        tenTinhController.text = tblBkTonGiao.value.tenTinh ?? '';
        maHuyenController.text = tblBkTonGiao.value.maHuyen ?? '';
        tenHuyenController.text = tblBkTonGiao.value.tenHuyen ?? '';
        maXaController.text = tblBkTonGiao.value.maXa ?? '';
        tenXaController.text = tblBkTonGiao.value.tenXa ?? '';
        maThonController.text = tblBkTonGiao.value.maThon ?? '';
        tenThonController.text = tblBkTonGiao.value.tenThon ?? '';
        tenChuHoController.text = tblBkTonGiao.value.tenCoSo ?? '';
        diaChiChuHoController.text = tblBkTonGiao.value.diaChi ?? '';
        dienThoaiController.text = tblBkTonGiao.value.dienThoai ?? '';
        emailController.text = tblBkTonGiao.value.email ?? '';
        coSoSoGiaTriController.text = tblBkTonGiao.value.maCoSo != null
            ? tblBkTonGiao.value.maCoSo.toString()
            : '';
        String ttNT = '';
        if (tblBkTonGiao.value.ttNT != null) {
          if (tblBkTonGiao.value.ttNT == 1) {
            ttNT = 'Thành thị';
          } else if (tblBkTonGiao.value.ttNT == 2) {
            ttNT = 'Nông thôn';
          }
        }
        ttNTController.text = ttNT;
        //phieuTonGiaoProvider
      }
    }
  }

  // Future<bool> checkMaNganhCap1BCEByMaVCPA() async {
  //   var maNganhs = await bkCoSoSXKDNganhSanPhamProvider
  //       .selectMaNganhByIdCoSo(tblBkCoSoSXKD.value.iDCoSo!);
  //   if (maNganhs.isNotEmpty) {
  //     var res =
  //         await dmNhomNganhVcpaProvider.kiemTraMaNganhCap1BCEByMaVCPA(maNganhs);
  //     return res;
  //   }
  //   return false;
  // }
  Future<bool> checkMaNganhCap1BCEByMaVCPA() async {
    var maNganhs = await bkCoSoSXKDNganhSanPhamProvider
        .selectMaNganhByIdCoSo(tblBkCoSoSXKD.value.iDCoSo!);
    if (maNganhs.isNotEmpty) {
      var res =
          await dmMotaSanphamProvider.kiemTraMaNganhCap1BCEByMaVCPA(maNganhs);
      return res;
    }
    return false;
  }

  Future getScreenNo({int screenNo = 2}) async {
    try {
      dynamic map = await dataProvider.selectTop1();
      TableData tableData = TableData.fromJson(map);
      if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
        dynamic question04 = tableData.toCauHoiPhieu07Mau();

        List<QuestionCommonModel> questionsTemp =
            QuestionCommonModel.listFromJson(jsonDecode(question04));

        screenNos.value = questionsTemp.map((e) => e.manHinh!).toSet().toList();
      } else if (currentMaDoiTuongDT ==
          AppDefine.maDoiTuongDT_07TB.toString()) {
        dynamic question04 = tableData.toCauHoiPhieu07TB();

        List<QuestionCommonModel> questionsTemp =
            QuestionCommonModel.listFromJson(jsonDecode(question04));

        screenNos.value = questionsTemp.map((e) => e.manHinh!).toSet().toList();
      } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_08.toString()) {
        dynamic question05 = tableData.toCauHoiPhieu08();

        List<QuestionCommonModel> questionsTemp =
            QuestionCommonModel.listFromJson(jsonDecode(question05));

        screenNos.value = questionsTemp.map((e) => e.manHinh!).toSet().toList();
      }
      // return questionSceenNo;
    } catch (e) {
      log('ERROR lấy danh sách câu hỏi phiếu: $e');
      return [];
    }
  }

  Future onPressNext() async {
    // var phoneValidate = Valid.validateMobile(dienThoaiController.text);
    // if (phoneValidate != null && phoneValidate != '') {
    //   return showError(phoneValidate);
    // }
    // setLoading(true);

    /// ! HỎI LẠI: CÓ CẬP NHẬT CÁC THÔNG TIN NÀY KHÔNG? CÁC Ô NHẬP NÀO ĐƯỢC PHÉP NHẬP ?????
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString() ||
        currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      // await bkCoSoSXKDProvider.updateValues(currentIdCoSo!, multiValue: {
      //   "DienThoai": dienThoaiController.text,
      //   "TenThon": tenThonController.text,
      //   "DiaChi": diaChiChuHoController.text
      //});
      // await phieuMauProvider
      //     .updateValuesMultiFields('', 1, currentIdCoSo!, multiValue: {
      //   "A1_1": tenChuHoController.text,
      //   "A1_2": diaChiChuHoController.text
      // });
      await insertNewRecordSanPham();
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_08.toString()) {
      // await bkCoSoTonGiaoProvider.updateValues('', 1, currentIdCoSoTG!, multiValue: {
      //   "DiaChi": diaChiChuHoController.text,
      //   "TenThon": tenThonController.text
      // });
      // var phoneValidate = Valid.validateMobile(dienThoaiController.text);
      // if (phoneValidate != null && phoneValidate != '') {
      //   return showError(phoneValidate);
      // }
      // var emailValidate = Valid.validateEmail(emailController.text);
      // if (emailValidate != null && emailValidate != '') {
      //   return showError(emailValidate);
      // }
      // await phieuTonGiaoProvider
      //     .updateValuesMultiFields('', 1, currentIdCoSoTG!, multiValue: {
      //   "A1_1": tenChuHoController.text,
      //   "A1_2": diaChiChuHoController.text,
      //   "A1_3": dienThoaiController.text,
      //   "A1_4": emailController.text
      // });
    }
    setLoading(false);
    if (screenNos.isEmpty) {
      String msgContent =
          'Cơ sở chưa có câu hỏi phỏng vấn, vui lòng thử lại sau.';
      Get.dialog(DialogWidget(
        isCancelButton: false,
        onPressedPositive: () {
          Get.back();
        },
        onPressedNegative: () {
          Get.back();
        },
        title: 'Không có câu hỏi',
        content: msgContent,
      ));

      return;
    }
    currentScreenNo.value = screenNos[0];
    await getNextScreen(currentScreenNo.value);
  }

  getNextScreen(int screenNoValue) async {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      var isCap1BCE = await checkMaNganhCap1BCEByMaVCPA();
      Get.toNamed(AppRoutes.question07, parameters: {
        QuestionNo07Controller.idCoSoKey: currentIdCoSo!,
        QuestionNo07Controller.isNhomNganhCap1BCEKey: isCap1BCE ? '1' : '0',
      });
    }
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      Get.toNamed(AppRoutes.question07, parameters: {
        QuestionNo07Controller.idCoSoKey: currentIdCoSo!,
        QuestionNo07Controller.isNhomNganhCap1BCEKey: '',
      });
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_08.toString()) {
      Get.toNamed(AppRoutes.question08,
          parameters: {QuestionNo08Controller.idCoSoKey: currentIdCoSoTG!});
    }
  }

/***********/
  ///San pham

  ///
  Future insertNewRecordSanPham() async {
    var res = await phieuMauSanphamProvider.isExistProduct(currentIdCoSo!);
    if (res == false) {
      //var maNganhs = await bkCoSoSXKDNganhSanPhamProvider
      //     .selectMaNganhByIdCoSo(tblBkCoSoSXKD.value.iDCoSo!);
      // var maNganhVcpa = '';
      // if (maNganhs.isNotEmpty) {
      //   maNganhVcpa = maNganhs.first;
      // }
      var maxStt =
          await phieuMauSanphamProvider.getMaxSTTByIdCoso(currentIdCoSo!);
      maxStt = maxStt + 1;
      var tblSp = TablePhieuMauSanPham(
          iDCoSo: currentIdCoSo,
          sTTSanPham: maxStt,
          isDefault: 1,
          maDTV: AppPref.uid);
      List<TablePhieuMauSanPham> tblSps = [];
      tblSps.add(tblSp);

      await phieuMauSanphamProvider.insert(tblSps, AppPref.dateTimeSaveDB!);
    }
  }

  onBackPage() async {
    if (homeController.isDefaultUserType()) {
      Get.back();
    } else {
      Get.offAllNamed(AppRoutes.mainMenu);
    }
  }

  ///
/**********/
  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }

  ///END::
  ///
  ///
}
