import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_tongdtkt_tongiao/common/utils/app_enum.dart';

import 'package:gov_tongdtkt_tongiao/common/utils/app_pref.dart';
import 'package:gov_tongdtkt_tongiao/common/utils/app_utils.dart';
import 'package:gov_tongdtkt_tongiao/common/valid/valid.dart';
import 'package:gov_tongdtkt_tongiao/common/widgets/dialogs/dialog_barrier_widget.dart';
import 'package:gov_tongdtkt_tongiao/common/widgets/dialogs/dialog_customize_widget.dart';
import 'package:gov_tongdtkt_tongiao/common/widgets/question/select_one.dart';
import 'package:gov_tongdtkt_tongiao/common/widgets/searchable/dropdown_category.dart';
import 'package:gov_tongdtkt_tongiao/common/widgets/searchable/search_sp_vcpa.dart';

import 'package:gov_tongdtkt_tongiao/config/config.dart';
import 'package:gov_tongdtkt_tongiao/modules/modules.dart';

import 'package:gov_tongdtkt_tongiao/modules/question_module/question_utils.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/ct_dm_hoatdong_logistic_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/dm_cokhong_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/dm_dantoc_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/dm_gioitinh_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/dm_linhvuc_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/dm_mota_sanpham_provider.dart'; 

import 'package:gov_tongdtkt_tongiao/resource/database/provider/provider_p08.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/provider_p08dm.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/tg_dm_loai_tongiao_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/xacnhan_logic_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/filed_common.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_ct_dm_hoatdong_logistic.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_ct_dm_nhomnganh_vcpa.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_data.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm08.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm_bkcoso_tongiao.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm_linhvuc.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm_mota_sanpham.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_p08.dart';
import 'package:gov_tongdtkt_tongiao/resource/model/question/question_group.dart';
import 'package:gov_tongdtkt_tongiao/resource/model/vcpa_offline_ai/models/predict_model.dart';
import 'package:gov_tongdtkt_tongiao/resource/model/vcpa_offline_ai/services/industry_code_evaluator.dart';

import 'package:gov_tongdtkt_tongiao/resource/resource.dart';
import 'package:gov_tongdtkt_tongiao/resource/services/api/search_sp/vcpa_vsic_ai_search_repository.dart';
import 'package:gov_tongdtkt_tongiao/routes/app_pages.dart';

class QuestionNo08Controller extends BaseController with QuestionUtils {
  QuestionNo08Controller({required this.vcpaVsicAIRepository});
  MainMenuController mainMenuController = Get.find();
  static const idCoSoKey = 'idCoSo';
  DateTime startTime = DateTime.now();

  /// param
  String? currentIdHoDuPhong;
  String? currentIdCoSoDuPhong;
  String? currentMaDoiTuongDT;
  String? currentTenDoiTuongDT;
  String? currentMaDiabanTG;
  String? currentIdCoSo;
  String? currentMaXa;
  String? currentMaTinhTrangDT;

  final scrollController = ScrollController();
  final interviewListDetailController =
      Get.find<InterviewListDetailController>();
  final generalInformationController = Get.find<GeneralInformationController>();

  // Provider
  final dataProvider = DataProvider();
  final bkCoSoTonGiaoProvider = BKCoSoTonGiaoProvider();

  final phieuTonGiaoProvider = PhieuTonGiaoProvider();
  final phieuTonGiaoA43Provider = PhieuTonGiaoA43Provider();
  final xacNhanLogicProvider = XacNhanLogicProvider();

  ///Danh mucj
  final dmDanTocProvider = DmDanTocProvider();
  final dmCoKhongProvider = DmCoKhongProvider();
  final dmGioiTinhProvider = DmGioiTinhProvider();

  final tgDmCapCongNhanProvider = TGDmCapCongNhanProvider();
  final tgDmLoaiCoSoProvider = TGDmLoaiCoSoProvider();
  final tgDmLoaiHinhTonGiaoProvider = TGDmLoaiHinhTonGiaoProvider();
  final tgDmNangLuongProvider = TGDmNangLuongProvider();
  final tgDmSuDungPhanMemProvider = TGDmSuDungPhanMemProvider();
  final tgDmTrinhDoChuyenMonProvider = TGDmTrinhDoChuyenMonProvider();
  final tgDmXepHangProvider = TGDmXepHangProvider();
  final tgDmXepHangDiTichProvider = TGDmXepHangDiTichProvider();
  final tgDmLoaiTonGiaoProvider = TGDmLoaiTonGiaoProvider();
  //final dmNhomNganhVcpaProvider = CTDmNhomNganhVcpaProvider();
  final dmMotaSanphamProvider = DmMotaSanphamProvider();
  final dmLinhvucSpProvider = DmLinhvucProvider();
  final dmHoatDongLogisticProvider = CTDmHoatDongLogisticProvider();

  ///search by AI
  final VcpaVsicAIRepository vcpaVsicAIRepository;

  ///table
  ///
  final tblBkTonGiao = TableBkTonGiao().obs;

  final questions = <QuestionCommonModel>[].obs;
  final tblPhieuTonGiao = TablePhieuTonGiao().obs;
  final tblPhieuTonGiaoA43 = <TablePhieuTonGiaoA43>[].obs;

  final tblDmGioiTinh = <TableDmGioiTinh>[].obs;
  final tblDmDanToc = <TableDmDanToc>[].obs;
  final tblDmCoKhong = <TableDmCoKhong>[].obs;

  final tblDmCapCongNhan = <TableTGDmCapCongNhan>[].obs;
  final tblDmLoaiCoSo = <TableTGDmLoaiCoSo>[].obs;
  final tblDmLoaiHinhTonGiao = <TableTGDmLoaiHinhTonGiao>[].obs;
  final tblDmNangLuong = <TableTGDmNangLuong>[].obs;
  final tblDmSuDungPhanMem = <TableTGDmSudDngPhanMem>[].obs;
  final tblDmTrinhDoChuyenMon = <TableTGDmTrinhDoChuyenMon>[].obs;
  final tblDmXepHang = <TableTGDmXepHang>[].obs;
  final tblDmXepHangDiTich = <TableTGDmXepHangDiTich>[].obs;
  final tblDmLoaiTonGiao = <TableDmLoaiTonGiao>[].obs;
  final tblDmHoatDongLogistic = <TableCTDmHoatDongLogistic>[].obs;
  final tblCTDmNhomNganhVcpaSearch = <TableCTDmNhomNganhVcpa>[].obs;

  final tblDmMoTaSanPham = <TableDmMotaSanpham>[].obs;
  final tblDmMoTaSanPhamSearch = <TableDmMotaSanpham>[].obs;
  final tblLinhVucSp = <TableDmLinhvuc>[].obs;

  final currentScreenNo = 0.obs;
  final currentScreenIndex = 0.obs;
  final questionIndex = 0.obs;

  final keywordDanToc = ''.obs;
  final searchResult = false.obs;
  final keywordVcpaCap5 = ''.obs;
  final searchResultCap5 = false.obs;

  ///Chọn search từ danh mục hay AI
  final searchVcpaType = 0.obs;
  final startSearch = true.obs;
  final limitNumSearchAI = 10.obs;
  final responseMessageAI = ''.obs;

  final tblDmDanTocSearch = <TableDmDanToc>[].obs;
//* Chứa các giá trị
  RxMap<dynamic, dynamic> answerTblTonGiao = {}.obs;

//* Chứa danh sách nhóm câu hỏi
  final questionGroupList = <QuestionGroup>[].obs;
//* Chứa thông tin hoàn thành phiếu
  final completeInfo = {}.obs;
  String subTitleBar = '';

  final a1_6BuocNhay = ["12", "13", "14", "15", "16"];
  final a1_5_6MaTDCM = [6, 7, 8, 9, 10];

  final a1_6MaWarningL1 = [1, 2, 3, 4, 5];
  final a1_6MaWarningL2 = [7, 8, 9, 10];
  final a1_7MaWarningL1 = [2, 3, 6, 7, 13, 14, 16];
  final a1_7MaWarningL2 = [1, 5, 8, 9, 10, 11, 15];

  ///LinhVuc item đang chọn

  final linhVucSelected =
      TableDmLinhvuc(id: 0, maLV: '0', tenLinhVuc: "Chọn lĩnh vực").obs;

  final sanPhamIdSelected = 0.obs;
  final moTaSpSelected = ''.obs;
  final maLVSelected = ''.obs;

  ///Tìm kiếm vcpa offline AI
  final _evaluator = IndustryCodeEvaluator(isDebug: true);
  final isInitializedEvaluator = false.obs;

  @override
  void onInit() async {
    setLoading(true);
    currentMaDoiTuongDT = interviewListDetailController.currentMaDoiTuongDT;
    currentTenDoiTuongDT = interviewListDetailController.currentTenDoiTuongDT;
    currentIdCoSo = interviewListDetailController.currentIdCoSoTG;
    currentMaXa = interviewListDetailController.currentMaXa;
    currentMaDiabanTG = interviewListDetailController.currentMaDiaBanTG;
    currentMaTinhTrangDT = interviewListDetailController.currentMaTinhTrangDT;

    startTime = getStartDate(
        currentIdCoSo!, int.parse(currentMaDoiTuongDT!), startTime);

    if (currentScreenNo.value == 0) {
      currentScreenNo.value = generalInformationController.screenNos()[0];
    }
    subTitleBar =
        'Mã xã: ${generalInformationController.tblBkTonGiao.value.maXa} - ${generalInformationController.tblBkTonGiao.value.tenCoSo}';

    log('Màn hình ${currentScreenNo.value}');
    await getDanhMuc();
    await fetchData();
    await getQuestionContent();
    await assignAllQuestionGroup();
    if (generalInformationController.tblBkTonGiao.value.maTrangThaiDT ==
        AppDefine.hoanThanhPhongVan) {
      var trangThaiLogic = await bkCoSoTonGiaoProvider.selectTrangThaiLogicById(
          idCoSo: currentIdCoSo!);
      if (trangThaiLogic != 1) {
        ///Insert các màn hình đã hoàn thành logic nếu  trạng thái cơ sở SX đã hoàn thành phỏng vấn
        updateXacNhanLogicByMaTrangThaiDT(
            questionGroupList.value,
            int.parse(currentMaDoiTuongDT!),
            currentIdCoSo!,
            AppDefine.hoanThanhPhongVan);
        bkCoSoTonGiaoProvider.updateTrangThaiLogic(
            columnBkTonGiaoTrangThaiLogic, 1, currentIdCoSo!);
      }
    }
    //}

    await setSelectedQuestionGroup();
    await getLinhVucSanPham();
    await getMoTaSanPham();
    setLoading(false);
    super.onInit();
  }

  Future getMoTaSanPham() async {
    var res = await dmMotaSanphamProvider.selectAll();
    var mtAll = TableDmMotaSanpham.listFromJson(res);

    tblDmMoTaSanPham.assignAll(mtAll);
  }

  Future getLinhVucSanPham() async {
    var res = await dmLinhvucSpProvider.selectAll();
    var mtAll = TableDmLinhvuc.listFromJson(res);
    mtAll.insert(0, TableDmLinhvuc.defaultLinhVuc());
    tblLinhVucSp.assignAll(mtAll);
  }

  /// Fetch Data các bảng của phiếu ton giao
  Future fetchData() async {
    Map question08Map =
        await phieuTonGiaoProvider.selectByIdCoSo(currentIdCoSo!);
    if (question08Map.isNotEmpty) {
      answerTblTonGiao.addAll(question08Map);
      var hasFieldTenDanToc = answerTblTonGiao.containsKey('A1_5_5_tendantoc');
      if (!hasFieldTenDanToc) {
        var maDanToc = answerTblTonGiao['A1_5_5'];
        if (maDanToc != null && maDanToc != '') {
          var danTocItems = await dmDanTocProvider.selectByMaDanToc(maDanToc);
          var result = danTocItems.map((e) => TableDmDanToc.fromJson(e));
          var dtM = result.toList();
          log('fetchData getValueDanTocByFieldName: ${danTocItems.length}');
          var res = dtM.firstOrNull;
          if (res != null) {
            log('Ten Dan Toc: ${res.tenDanToc!}');
            updateAnswerTblTonGiao('A1_5_5_tendantoc', res.tenDanToc!);
          }
        }
      }
      tblPhieuTonGiao.value = TablePhieuTonGiao.fromJson(question08Map);
      await getThongTinNguoiPV();
      await getTablePhieuTonGiaoA43();
    }
  }

  Future getThongTinNguoiPV() async {
    String? soDienThoaiDTV = tblPhieuTonGiao.value.soDienThoaiDTV;
    String? hoTenDTV = tblPhieuTonGiao.value.hoTenDTV;
    if (soDienThoaiDTV == null || soDienThoaiDTV == '') {
      soDienThoaiDTV = mainMenuController.userModel.value.sDT;
    }
    if (hoTenDTV == null || hoTenDTV == '') {
      hoTenDTV = mainMenuController.userModel.value.tenNguoiDung;
    }
    mapCompleteInfo(soDienThoaiBase, tblPhieuTonGiao.value.soDienThoai);
    mapCompleteInfo(nguoiTraLoiBase, tblPhieuTonGiao.value.nguoiTraLoi);
    mapCompleteInfo(kinhDoBase, tblPhieuTonGiao.value.kinhDo);
    mapCompleteInfo(viDoBase, tblPhieuTonGiao.value.viDo);
    mapCompleteInfo(soDienThoaiDTVBase, soDienThoaiDTV);
    mapCompleteInfo(hoTenDTVBase, hoTenDTV);
  }

  Future getTablePhieuTonGiao() async {
    Map question08Map =
        await phieuTonGiaoProvider.selectByIdCoSo(currentIdCoSo!);

    if (question08Map.isNotEmpty) {
      tblPhieuTonGiao.value = TablePhieuTonGiao.fromJson(question08Map);
    }
  }

  Future getTablePhieuTonGiaoA43() async {
    List<Map> questionC1Map =
        await phieuTonGiaoA43Provider.selectByIdCoso(currentIdCoSo!);

    tblPhieuTonGiaoA43
        .assignAll(TablePhieuTonGiaoA43.fromListJson(questionC1Map)!);
    tblPhieuTonGiaoA43.refresh();
  }

  Future<List<QuestionCommonModel>> getQuestionContent() async {
    try {
      dynamic map = await dataProvider.selectTop1();
      TableData tableData = TableData.fromJson(map);
      dynamic question08 = tableData.toCauHoiPhieu08();

      List<QuestionCommonModel> questionsTemp =
          QuestionCommonModel.listFromJson(jsonDecode(question08));
      List<QuestionCommonModel> questionsTemp2 = [];
      if (questionsTemp.isNotEmpty) {
        questionsTemp2.addAll(questionsTemp);
        questions.clear();

        questionsTemp2.retainWhere((x) {
          return (x.manHinh == currentScreenNo.value);
        });
      }
      questions.addAll(questionsTemp2);

      return questions;
    } catch (e) {
      log('ERROR lấy danh sách câu hỏi phiếu: $e');
      return [];
    }
  }

  Future getDanhMuc() async {
    await Future.wait([
      getDmCoKhong(),
      getDmDanToc(),
      getDmGioiTinh(),
      getDmCapCongNhan(),
      getDmLoaiCoSo(),
      getDmNangLuong(),
      getDmLoaiHinhTonGiao(),
      getDmSuDungPhanMem(),
      getDmTrinhDoChuyenMon(),
      getDmXepHang(),
      getDmXepHangDiTich(),
      getDmLoaiTonGiao(),
      getDmHoatDongLogistic()
    ]);
  }

  Future getDmCoKhong() async {
    try {
      dynamic map = await dmCoKhongProvider.selectAll();
      tblDmCoKhong.value = TableDmCoKhong.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmCoKhong: $e');
    }
  }

  Future getDmDanToc() async {
    try {
      dynamic map = await dmDanTocProvider.selectAll();
      tblDmDanToc.value = TableDmDanToc.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmDanToc: $e');
    }
  }

  Future getDmGioiTinh() async {
    try {
      dynamic map = await dmGioiTinhProvider.selectAll();
      tblDmGioiTinh.value = TableDmGioiTinh.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmGioiTinh: $e');
    }
  }

  Future getDmXepHangDiTich() async {
    try {
      dynamic map = await tgDmXepHangDiTichProvider.selectAll();
      tblDmXepHangDiTich.value = TableTGDmXepHangDiTich.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmXepHang: $e');
    }
  }

  Future getDmXepHang() async {
    try {
      dynamic map = await tgDmXepHangProvider.selectAll();
      tblDmXepHang.value = TableTGDmXepHang.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmXepHang: $e');
    }
  }

  Future getDmTrinhDoChuyenMon() async {
    try {
      dynamic map = await tgDmTrinhDoChuyenMonProvider.selectAll();
      tblDmTrinhDoChuyenMon.value = TableTGDmTrinhDoChuyenMon.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmTrinhDoChuyenMon: $e');
    }
  }

  Future getDmSuDungPhanMem() async {
    try {
      dynamic map = await tgDmSuDungPhanMemProvider.selectAll();
      tblDmSuDungPhanMem.value = TableTGDmSudDngPhanMem.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmSuDungPhanMem: $e');
    }
  }

  Future getDmLoaiHinhTonGiao() async {
    try {
      dynamic map = await tgDmLoaiHinhTonGiaoProvider.selectAll();
      tblDmLoaiHinhTonGiao.value = TableTGDmLoaiHinhTonGiao.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmLoaiHinhTonGiao: $e');
    }
  }

  Future getDmNangLuong() async {
    try {
      dynamic map = await tgDmNangLuongProvider.selectAll();
      tblDmNangLuong.value = TableTGDmNangLuong.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmNangLuong: $e');
    }
  }

  Future getDmCapCongNhan() async {
    try {
      dynamic map = await tgDmCapCongNhanProvider.selectAll();
      tblDmCapCongNhan.value = TableTGDmCapCongNhan.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmCapCongNhan: $e');
    }
  }

  Future getDmLoaiCoSo() async {
    try {
      dynamic map = await tgDmLoaiCoSoProvider.selectAll();
      tblDmLoaiCoSo.value = TableTGDmLoaiCoSo.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmLoaiCoSo: $e');
    }
  }

  Future getDmLoaiTonGiao() async {
    try {
      dynamic map = await tgDmLoaiTonGiaoProvider.selectAll();
      tblDmLoaiTonGiao.value = TableDmLoaiTonGiao.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmLoaiTonGiao: $e');
    }
  }

  Future getDmHoatDongLogistic() async {
    try {
      dynamic map = await dmHoatDongLogisticProvider.selectAll();
      tblDmHoatDongLogistic.value = TableCTDmHoatDongLogistic.listFromJson(map);
    } catch (e) {
      log('ERROR lấy getDmHoatDongLogistic: $e');
    }
  }

  Future assignAllQuestionGroup() async {
    var qGroups = await getQuestionGroups(currentMaDoiTuongDT!, currentIdCoSo!);
    questionGroupList.assignAll(qGroups);
  }

  Future onOpenDrawerQuestionGroup() async {
    scaffoldKey.currentState?.openDrawer();
  }

  Future onMenuPress(int id) async {
    await fetchData();
    String validateResult = await validateAllFormV2();
    if (validateResult != '') {
      insertUpdateXacNhanLogicWithoutEnable(
          currentScreenNo.value,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          0,
          validateResult,
          int.parse(currentMaTinhTrangDT!));
      return showError(validateResult);
    }
    await clearSelectedQuestionGroup();
    var qItem = questionGroupList.where((x) => x.id == id).first;
    if (qItem != null) {
      if (qItem.enable!) {
        qItem.isSelected = true;
        currentScreenNo.value = qItem.manHinh!;
        if (currentScreenNo.value > 0) {
          currentScreenIndex.value = currentScreenNo.value - 1;
        }
        await getQuestionContent();
        if (currentScreenIndex.value ==
            generalInformationController.screenNos().length - 1) {}
      } else {
        snackBar('Thông báo', 'Danh sách cấu hỏi này chưa nhập');
      }
    }
    questionGroupList.refresh();
    scaffoldKey.currentState?.closeDrawer();
  }

  Future clearSelectedQuestionGroup() async {
    for (var item in questionGroupList) {
      item.isSelected = false;
    }
    questionGroupList.refresh();
  }

  Future setSelectedQuestionGroup() async {
    if (currentScreenNo.value > 0) {
      await clearSelectedQuestionGroup();
      var questionGroupItem = questionGroupList
          .where((x) => x.manHinh == currentScreenNo.value)
          .firstOrNull;
      if (questionGroupItem != null) {
        if (questionGroupItem.enable!) {
          questionGroupItem.isSelected = true;
          questionGroupList.refresh();
        }
      }
    }
  }

  Future onBackStart() async {
    await fetchData();
    String validateResult = await validateAllFormV2();
    if (validateResult != '') {
      await insertUpdateXacNhanLogicWithoutEnable(
          currentScreenNo.value,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          0,
          validateResult,
          int.parse(currentMaTinhTrangDT!));
    } else {
      await insertUpdateXacNhanLogicWithoutEnable(
          currentScreenNo.value,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          '',
          int.parse(currentMaTinhTrangDT!));
    }
    Get.back();
  }

  /// Handle onPressed [Quay lại] button
  Future onBack() async {
    await fetchData();
    String validateResult = await validateAllFormV2();
    if (validateResult != '') {
      await insertUpdateXacNhanLogicWithoutEnable(
          currentScreenNo.value,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          0,
          validateResult,
          int.parse(currentMaTinhTrangDT!));
    } else {
      await insertUpdateXacNhanLogicWithoutEnable(
          currentScreenNo.value,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          '',
          int.parse(currentMaTinhTrangDT!));
    }
    if (currentScreenNo.value > 0) {
      currentScreenNo.value--;
      currentScreenIndex.value--;
      if (currentScreenNo.value == 0) {
        Get.back();
      }
      await getQuestionContent();
      await scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      await setSelectedQuestionGroup();
    } else {
      // currentScreenIndex.value = 0;
      Get.back();
    }
  }

  void onNext() async {
    ///Lấy lại dữ liệu từ db
    await fetchData();
    String validateResult = await validateAllFormV2();

    ///
    ///Kiểm tra màn hình để đến màn hình tiếp hoặc hiện màn hình kết thúc phỏng vấn
    ///
    if (currentScreenNo.value == 0) {
      currentScreenNo.value = generalInformationController.screenNos()[0];
    }
    if (validateResult != '') {
      insertUpdateXacNhanLogicWithoutEnable(
          currentScreenNo.value,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          0,
          validateResult,
          int.parse(currentMaTinhTrangDT!));
      return showError(validateResult);
    } else {
      ///Đã vượt qua validate xong thì update/add thông tin vào bảng tableXacNhanLogic
      await insertUpdateXacNhanLogic(
          currentScreenNo.value,
          currentIdCoSo!,
          int.parse(currentMaDoiTuongDT!),
          1,
          1,
          '',
          int.parse(currentMaTinhTrangDT!));
    }
    await assignAllQuestionGroup();
    if (currentScreenIndex.value <
        generalInformationController.screenNos().length - 1) {
      currentScreenNo(currentScreenNo.value + 1);
      currentScreenIndex(currentScreenIndex.value + 1);
      await getQuestionContent();

      ///
      // var res = await getListFieldToValidate();
      scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn);

      await setSelectedQuestionGroup();
      // await getTablePhieu04SanPhamByFieldNames();

      /// GỌI HÀM TÍNH CÁC CHỈ TIÊU .....
      if (currentScreenIndex.value ==
          generalInformationController.screenNos().length - 1) {}
    } else {
      await setSelectedQuestionGroup();
      var result = await validateCompleted();
      if (result != null && result != '') {
        result = result.replaceAll('^', '\r\n');
        return showError(result);
      }
      onKetThucPhongVan();
    }
  }

  Future<String?> validateCompleted() async {
    var result = xacNhanLogicProvider.kiemTraLogicByIdDoiTuongDT(
        maDoiTuongDT: currentMaDoiTuongDT!, idDoiTuongDT: currentIdCoSo!);
    return result;
  }

  updateAnswerCompletedToDb(key, value) async {
    log("Update to db: $key $value");
    await phieuTonGiaoProvider.updateValue(key, value, currentIdCoSo);
  }

  onChangeCompleted(key, value) {
    log('ON CHANGE COMPLETED: $key $value', name: "onChangeCompleted");
    Map<String, dynamic> map = Map<String, dynamic>.from(completeInfo);
    try {
      map.update(key, (val) => value, ifAbsent: () => value);
      completeInfo.value = map;
      updateAnswerCompletedToDb(key, value);
    } catch (e) {
      log('onChangeCompleted error: ${e.toString()}');
    }
  }

  Future mapCompleteInfo(key, value) async {
    Map<String, dynamic> map = Map<String, dynamic>.from(completeInfo);
    map.update(key, (val) => value, ifAbsent: () => value);
    completeInfo.value = map;
  }

  ///BEBGIN::Event câu hỏi

  onChangeInput(String table, String? maCauHoi, String? fieldName, value,
      {String? fieldNameTotal}) {
    log('ON onChangeInput: $fieldName $value');

    try {
      updateAnswerToDB(table, fieldName ?? "", value);
    } catch (e) {
      printError(info: e.toString());
    }
  }

  /// Update giá trị của 1 trường
  updateAnswerToDB(String table, String fieldName, value,
      {List<String>? fieldNames, String? fieldNameTotal}) async {
    if (fieldName == '') return;
    if (table == tablePhieuTonGiao) {
      await phieuTonGiaoProvider.updateValue(fieldName, value, currentIdCoSo);
      await updateAnswerTblTonGiao(fieldName, value);
    } else if (table == tablePhieuTonGiaoA43) {
    } else {
      snackBar("dialog_title_warning".tr, "data_table_undefine".tr);
    }
  }

// * Update lại giá trị cho answerTblSanpham khi onchangexxx
  Future updateAnswerTblTonGiao(fieldName, value) async {
    Map<String, dynamic> map = Map<String, dynamic>.from(answerTblTonGiao);
    map.update(fieldName, (val) => value, ifAbsent: () => value);
    answerTblTonGiao.value = map;
    answerTblTonGiao.refresh();
  }
/************/
  ///Begin::A4_3
/************/

  onOpenDialogSearchType(
      QuestionCommonModel question,
      String fieldName,
      TablePhieuTonGiaoA43 product,
      int idValue,
      int stt,
      String motaSp,
      value) async {
    var sType = getSearchType();
    Get.dialog(DialogCustomizeWidget(
      onPressedNegative: () async {
        Get.back();
      },
      onPressedPositive: () async {
        // if (searchVcpaType.value == 1) {
        //   await onFocusOpenDialogVcpa(
        //       question, fieldName, product, idValue, stt, motaSp, value);
        // }
        if (searchVcpaType.value == 2) {
          if (NetworkService.connectionType == Network.none) {
            // return snackBar('Thông báo', 'no_connect_internet'.tr,
            //     style: ToastSnackType.error);
            if (isInitializedEvaluator.value) {
              Get.key.currentState?.pop();
              await onFocusOpenDialogVcpa(
                  question, fieldName, product, idValue, stt, motaSp, value);
            } else {
              snackBar(
                  'Thông báo',
                  responseMessageAI.value == ''
                      ? 'Khởi tạo dữ liệu AI bị lỗi'
                      : responseMessageAI.value,
                  style: ToastSnackType.error);
            }
          } else {
            Get.key.currentState?.pop();
            await onFocusOpenDialogVcpa(
                question, fieldName, product, idValue, stt, motaSp, value);
          }
        } else {
          Get.key.currentState?.pop();
          await onFocusOpenDialogVcpa(
              question, fieldName, product, idValue, stt, motaSp, value);
        }
      },
      title: 'Chọn hình thức tìm kiếm',
      body: Obx(() => SelectOne(
          onChange: onChangeSearhType,
          listValue: sType,
          value: searchVcpaType.value)),
    ));
  }

  onChangeSearhType(int value) async {
    debugPrint('Search type: $value');
    searchVcpaType.value = value;
    if (searchVcpaType.value == 2) {
      if (NetworkService.connectionType == Network.none) {
        // return snackBar('Thông báo', 'no_connect_internet'.tr,
        //     style: ToastSnackType.error);
        debugPrint(
            'isInitializedEvaluator.value = ${isInitializedEvaluator.value}');
        if (isInitializedEvaluator.value == false) {
          setLoading(true);
          await initializeEvaluator();
          setLoading(false);
        }
      }
    }
  }

// Initialization methods
  Future<void> initializeEvaluator() async {
    isInitializedEvaluator.value = false;
    log('Loading model and resources...');
    try {
      final currentFilePath =
          '${AppPref.dataModelAIFilePath}/${AppPref.dataModelAIVersionFileName}';
      final currentFile = File(currentFilePath);
      var isCurrentFileExist = await currentFile.exists();
      if (!isCurrentFileExist) {
        return snackBar('Thông báo',
            'Chưa có dữ liệu AI. Vui lòng thực hiện cập nhật dữ liệu AI',
            style: ToastSnackType.error);
      }

      final startTime = DateTime.now();
      await _evaluator.initialize();
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      isInitializedEvaluator.value = true;
      log('Model ready! Initialization took ${duration.inMilliseconds}ms');
    } catch (e) {
      isInitializedEvaluator.value = false;
      log('Initialization failed: $e');
      responseMessageAI.value = 'Khởi tạo dữ liệu AI bị lỗi ${e.toString()}';
      snackBar('Thông báo', 'Khởi tạo dữ liệu AI bị lỗi ${e.toString()}',
          style: ToastSnackType.error);
    }
  }

  onFocusOpenDialogVcpa(
      QuestionCommonModel question,
      String fieldName,
      TablePhieuTonGiaoA43 product,
      int idValue,
      int stt,
      String motaSp,
      value) async {
    tblDmMoTaSanPhamSearch.clear();
    tblDmMoTaSanPhamSearch.refresh();
    sanPhamIdSelected.value = idValue;
    moTaSpSelected.value = motaSp;
    await getLinhVucSelected(product.a4_3_2 ?? '');

    if (searchVcpaType.value == 1) {
      await onSearchVcpaCap5(motaSp);
    } else {
      startSearch.value = false;
    }
    tblDmMoTaSanPhamSearch.refresh();
    String searchTypeText = searchVcpaType.value == 2 ? 'AI' : 'Danh mục';
    Get.dialog(Dialog.fullscreen(
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
            child: Column(children: [
          Container(
              //  width: Get.width,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              // decoration: const BoxDecoration(
              //   color: Colors.white70,
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 4,
                            child: Text('Tìm nhóm sản phẩm từ $searchTypeText',
                                style: styleMedium,textAlign: TextAlign.center,)),
                        Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                onCloseSearch();
                              },
                              // styling the button
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: const EdgeInsets.all(0),
                                  // Button color
                                  backgroundColor: Colors.white,
                                  // Splash color
                                  foregroundColor: primaryColor,
                                  elevation: 1.0,
                                  side: const BorderSide(color: primaryColor)),
                              child: const Text('Đóng'),
                            ))
                      ]),
                  const SizedBox(
                    height: 18,
                  ),
                  Obx(() {
                    tblDmMoTaSanPhamSearch.refresh();
                    return Column(children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Expanded(
                                flex: 1,
                                child: Text('Lĩnh vực', style: styleMedium)),
                            Expanded(
                              flex: 4,
                              child: InputDecorator(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 0.0),
                                    enabledBorder: const OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: BorderSide(
                                          color: primaryColor, width: 1.0),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                  isEmpty: value == null || value == '',
                                  child: DropdownButtonHideUnderline(
                                      child: DropdownCategory(
                                    onLinhVucSelected: (item) =>
                                        onLinhVucSelected(item),
                                    danhSachLinhVuc: tblLinhVucSp,
                                    linhVucItemSelected: linhVucSelected.value,
                                  ))),
                            )
                          ]),
                      const SizedBox(
                        height: 18,
                      ),
                      SearchSpVcpa(
                        onChangeListViewItem: (item, product) =>
                            onChangeListViewItem(item, product),
                        value: motaSp,
                        onChangeText: (inputValue) => onChangeSearchA4_3(
                            question.bangDuLieu!,
                            question.maCauHoi!,
                            fieldName,
                            idValue,
                            inputValue),
                        onPressSearch: () => onPressSearch(),
                        filteredList: tblDmMoTaSanPhamSearch,
                        phieuMauSpItem: product,
                        searchType: searchVcpaType.value,
                        startSearch: startSearch.value,
                        onChangeSlider: (value) => onChangeSlider(value),
                        responseMessage: responseMessageAI.value,
                      )
                    ]);
                  })
                ],
              ))
        ]))));
  }

  getLinhVucSelected(String maSp) async {
    if (maSp == '') {
      linhVucSelected.value = TableDmLinhvuc.defaultLinhVuc();
      return;
    }
    var mtSp = await dmMotaSanphamProvider.getByVcpaCap5(maSp);
    if (mtSp != null) {
      var mtSpItem = TableDmMotaSanpham.fromJson(mtSp);
      if (mtSpItem != null) {
        if (mtSpItem.maLV != null && mtSpItem.maLV != '') {
          var lv = dmLinhvucSpProvider.getByMaLV(mtSpItem.maLV!);
          if (lv != null) {
            var lvItem = TableDmLinhvuc.fromJson(mtSp);
            linhVucSelected.value = lvItem;
            maLVSelected.value = lvItem.maLV!;
          }
        }
      }
    }
  }

  onChangeSlider(value) async {
    limitNumSearchAI.value = value;
  }

  onChangeListViewItem(
      TableDmMotaSanpham item, TablePhieuTonGiaoA43 phieuTonGiaoSpItem) async {
    debugPrint(
        "onChangeListViewItem linh vuc ${item?.maSanPham} - ${item?.tenSanPham}");
    log('ON onChangeListViewItem id moTaSpSelected: $sanPhamIdSelected $moTaSpSelected');
    try {
      if (sanPhamIdSelected.value == phieuTonGiaoSpItem.id) {}
      String vcpaCapx = '';
      //String donViTinh = '';
      int idVal = phieuTonGiaoSpItem.id!;
      // int stt = phieuTonGiaoSpItem.sTT!;
      vcpaCapx = item.maSanPham!;
      //  donViTinh = item.donViTinh ?? '';
      String mota = moTaSpSelected.value;
      //  var res = kiemTraMaVCPACap5(vcpaCapx);
      //  if (res) {
      await updateToDbA43(
          tablePhieuTonGiaoA43, columnPhieuTonGiaoA43A4_3_2, idVal, vcpaCapx);
      snackBar('Thông báo', 'Đã cập nhật');
      log('ON onChangeListViewItem ĐÃ cập nhật mã VCPA cấp 5 vào bảng $tablePhieuTonGiaoA43');
      // } else {
      //   log('ON onChangeListViewItem chưa cập nhật mã VCPA cấp 5 vào bảng $tablePhieuTonGiaoA43');
      // }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  void onLinhVucSelected(TableDmLinhvuc item) async {
    //Goi search lại khi
    debugPrint(
        "onLinhVucSelected linh vuc ${item?.maLV} - ${item?.tenLinhVuc}");
    log('ON onLinhVucSelected id moTaSpSelected: $sanPhamIdSelected $moTaSpSelected');
    maLVSelected.value = item.maLV!;
    String moTaSp = moTaSpSelected.value;
    await onSearchVcpaCap5(moTaSp);
  }

  void onPressSearch() async {
    debugPrint('onPressSearch ${moTaSpSelected.value}');
    await onSearchVcpaCap5(moTaSpSelected.value ?? '');
  }

  onCloseSearch() async {
    sanPhamIdSelected.value = 0;
    moTaSpSelected.value = '';
    tblDmMoTaSanPhamSearch.clear();
    tblDmMoTaSanPhamSearch.refresh();
    tblPhieuTonGiaoA43.refresh();
    log('ON onCloseSearch id moTaSpSelected: $sanPhamIdSelected $moTaSpSelected ${tblDmMoTaSanPhamSearch.value}');
    Get.back();

    // await getTablePhieuSanPham();
  }

  onChangeInputA43(
      String table, String tenCauHoi, String? fieldName, idValue, value) async {
    log('ON onChangeInputA43: $fieldName $value');
    try {
      if (table == tablePhieuTonGiaoA43) {
        await updateToDbA43(table, fieldName ?? "", idValue, value);
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  ///
  onValidateInputA43(
      String table,
      String maCauHoi,
      String? fieldName,
      idValue,
      String? inputValue,
      minLen,
      maxLen,
      minValue,
      maxValue,
      int loaiCauHoi,
      bool typing) {
    if (fieldName == columnPhieuTonGiaoA43A4_3_2) {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
      return onValidateInputVCPACap5A4_3(table, maCauHoi, fieldName, idValue,
          inputValue, minLen, maxLen, minValue, maxValue, loaiCauHoi);
    } else if (fieldName == columnPhieuTonGiaoA43A4_3_1) {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập giá trị.';
      }
    } else if (fieldName == columnPhieuTonGiaoA43A4_3_3) {
      if (validateEmptyString(inputValue.toString())) {
        return 'Vui lòng nhập giá trị.';
      }
      num intputVal = inputValue != null
          ? AppUtils.convertStringToInt(inputValue.replaceAll(' ', ''))
          : 0;
      if (intputVal < minValue) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minValue, maxValue)}';
      } else if (intputVal > maxValue) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minValue, maxValue)}';
      }
    } else if (fieldName == columnPhieuTonGiaoA43A4_3_4) {
      if (validateEmptyString(inputValue.toString())) {
        return 'Vui lòng nhập giá trị.';
      }
      num intputVal = inputValue != null
          ? AppUtils.convertStringToDouble(inputValue.replaceAll(' ', ''))
          : 0;
      if (intputVal < minValue) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minValue, maxValue)}';
      } else if (intputVal > maxValue) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minValue, maxValue)}';
      }
    } else if (fieldName == columnPhieuTonGiaoA43A4_3_5) {
      if (validateEmptyString(inputValue.toString())) {
        return 'Vui lòng nhập giá trị.';
      }
      num intputVal = inputValue != null
          ? AppUtils.convertStringToDouble(inputValue.replaceAll(' ', ''))
          : 0;
      if (intputVal < minValue) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minValue, maxValue)}';
      } else if (intputVal > maxValue) {
        return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minValue, maxValue)}';
      }
    }

    // int a2_2_01TongSoTrongDo = 0;
    // int a2_2_01Value = 0;

    // a2_2_01Value = tblPhieuTG[columnPhieuTonGiaoA2_2_01] != null
    //     ? AppUtils.convertStringToInt(
    //         tblPhieuTG[columnPhieuTonGiaoA2_2_01].toString())
    //     : 0;
  }

  onValidateInput(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String? valueInput) {
    var table = question.bangDuLieu;
    var maCauHoi = question.maCauHoi;
    var minValue = chiTieuCot!.giaTriNN;
    var maxValue = chiTieuCot.giaTriLN;
  }

  ///
  addNewRowPhieuTonGiaoA43(String table, String maCauHoi) async {
    if (table == tablePhieuTonGiaoA43) {
      await insertNewRecordPhieuTonGiaoA43();
      await getTablePhieuTonGiaoA43();
    }
  }

  ///
  updateToDbA43(String table, String fieldName, idValue, value) async {
    var res = await phieuTonGiaoA43Provider.isExistQuestion(currentIdCoSo!);
    if (res) {
      await phieuTonGiaoA43Provider.updateValueByIdCoso(
          fieldName, value, currentIdCoSo, idValue!);
    } else {
      await insertNewRecordPhieuTonGiaoA43();
    }
    await getTablePhieuTonGiaoA43();
  }

  ///
  Future<TablePhieuTonGiaoA43> createPhieuTonGiaoA43Item() async {
    var maxStt =
        await phieuTonGiaoA43Provider.getMaxSTTByIdCoso(currentIdCoSo!);
    maxStt = maxStt + 1;
    var table04C8 = TablePhieuTonGiaoA43(
        iDCoSo: currentIdCoSo, sTT: maxStt, maDTV: AppPref.uid);
    return table04C8;
  }

  ///
  Future insertNewRecordPhieuTonGiaoA43({bool? isInsert = true}) async {
    var tableA43 = await createPhieuTonGiaoA43Item();

    List<TablePhieuTonGiaoA43> tablePhieuTonGiaoA43s = [];
    tablePhieuTonGiaoA43s.add(tableA43);
    await phieuTonGiaoA43Provider.insert(
        tablePhieuTonGiaoA43s, AppPref.dateTimeSaveDB!);
  }

  Future deleteA43Item(
      String table, String maCauHoi, dynamic recordValue) async {
    Get.dialog(DialogBarrierWidget(
      onPressedNegative: () async {
        Get.back();
      },
      onPressedPositive: () async {
        await excueteDeleteA43Item(table, maCauHoi, recordValue);
        Get.back();
      },
      title: 'dialog_title_warning'.tr,
      content: 'dialog_content_warning_delete'.trParams({'param': 'sản phẩm'}),
    ));
  }

  Future excueteDeleteA43Item(
      String table, String maCauHoi, dynamic recordValue) async {
    if (table == tablePhieuTonGiaoA43) {
      TablePhieuTonGiaoA43 record = recordValue;
      if (record.id != null) {
        await phieuTonGiaoA43Provider.deleteById(record.id!);
        await getTablePhieuTonGiaoA43();
      }
    }
  }

  Future<Iterable<TableDmMotaSanpham?>> onSearchVcpaCap5(String search) async {
    debugPrint('onSearchVcpaCap5 $search');
    keywordVcpaCap5.value = search;
    startSearch.value = true;
    responseMessageAI.value = '';
    if (search.length >= 1) {
      if (searchVcpaType.value == 1) {
        List<Map> vcpaCap5s = await dmMotaSanphamProvider
            .searchVcpaCap5ByLinhVuc(search, maLVSelected.value);
        var result = vcpaCap5s.map((e) => TableDmMotaSanpham.fromJson(e));

        tblDmMoTaSanPhamSearch.value = result.toList();
        tblDmMoTaSanPhamSearch.refresh();
        log('SEARCH RESULT: ${vcpaCap5s.length}');
        startSearch.value = false;
        responseMessageAI.value = '';
        return result;
      } else if (searchVcpaType.value == 2) {
        ///Tìm kiếm offline với AI
        print('NetworkService.connectionType ${NetworkService.connectionType}');
        if (NetworkService.connectionType == Network.none) {
          debugPrint('OFFLINE onSearchVcpaCap5 $search');
          if (isInitializedEvaluator.value) {
            final predictions = await _evaluator
                .predict([search], topK: limitNumSearchAI.value);
            List<PredictionResult> _results =
                predictions.isNotEmpty ? predictions.first : [];
            List<Map> vcpaCap5s = await dmMotaSanphamProvider
                .mapResultAIToDmSanPhamOffline(_results, maLVSelected.value);
            var result = vcpaCap5s.map((e) => TableDmMotaSanpham.fromJson(e));
            tblDmMoTaSanPhamSearch.value = result.toList();
            tblDmMoTaSanPhamSearch.refresh();
            debugPrint('OFFLINE SEARCH RESULT ${result.length}');
            startSearch.value = false;
            responseMessageAI.value = '';
            return result;
          }
        } else {
          ///Tìm kiếm online với AI
          var response = await vcpaVsicAIRepository.searchVcpaVsicByAI(
              'vcpa', search,
              limitNum: limitNumSearchAI.value);
          debugPrint('searchVcpaVsicByAI ${response.statusCode}.');
          if (response.statusCode == 200) {
            if (response.body != null) {
              if (response.body!.isNotEmpty) {
                var res = response.body!;
                List<Map> vcpaCap5s = await dmMotaSanphamProvider
                    .mapResultAIToDmSanPham(res, maLVSelected.value);
                var result =
                    vcpaCap5s.map((e) => TableDmMotaSanpham.fromJson(e));
                tblDmMoTaSanPhamSearch.value = result.toList();
                tblDmMoTaSanPhamSearch.refresh();
                log('SEARCH RESULT: ${result.length}');
                startSearch.value = false;
                responseMessageAI.value = '';
                return result;
              }
            }
          } else if (response.statusCode == ApiConstants.errorDisconnect) {
            responseMessageAI.value = 'no_connect_internet'.tr;
          } else if (response.statusCode.toString() ==
              ApiConstants.requestTimeOut) {
            responseMessageAI.value = 'Request timeout.';
          } else {
            responseMessageAI.value = response.message ?? '';
          }
        }
      }
    }
    startSearch.value = false;
    return [];
  }

  // Future<Iterable<TableCTDmNhomNganhVcpa?>> onSearchVcpaCap5A4_3(
  //     String search) async {
  //   //   searchResult.value = false;
  //   //tblDmVsicIO.clear();
  //   keywordVcpaCap5.value = search;
  //   if (search.length >= 1) {
  //     // List<Map> vcpaCap5s =
  //     //     await dmNhomNganhVcpaProvider.searchVcpaCap5(search);
  //     List<Map> vcpaCap5s = await dmMotaSanphamProvider.searchVcpaCap5(search);
  //     var result = vcpaCap5s.map((e) => TableCTDmNhomNganhVcpa.fromJson(e));

  //     tblCTDmNhomNganhVcpaSearch.value = result.toList();
  //     log('SEARCH RESULT: ${vcpaCap5s.length}');

  //     var res = tblCTDmNhomNganhVcpaSearch
  //         .where((x) => x.cap5 == search || x.moTaNganhSanPham == search)
  //         .firstOrNull;
  //     if (res != null) {}
  //     return result;
  //   }
  //   return [];
  // }
  onChangeSearchA4_3(
      String table, String maCauHoi, String? fieldName, idValue, value) async {
    debugPrint('ON onChangeSearchA4_3: $fieldName $value');
    moTaSpSelected.value = value;
  }

  onChangeInputVCPACap5A4_3(
      String table, String maCauHoi, String? fieldName, idValue, value) async {
    log('ON onChangeInputVCPACap5A4_3: $fieldName $value');

    try {
      if (table == tablePhieuTonGiaoA43) {
        String vcpaCap5 = '';
        if (value is TableCTDmNhomNganhVcpa) {
          TableCTDmNhomNganhVcpa valueInput = value;
          if (valueInput != null) {
            vcpaCap5 = valueInput.cap5!;
          }
        } else if (value is String) {
          vcpaCap5 = value;
        }
        // var res = kiemTraMaVCPACap5(value);
        //  if (res) {
        await updateToDbA43(table, fieldName ?? "", idValue, vcpaCap5);
        log('ON onChangeInputVCPACap5A4_3 ĐÃ cập nhật mã VCPA cấp 5 vào bảng $tablePhieuTonGiaoA43');
        // } else {
        //  log('ON onChangeInputVCPACap5A4_3 chưa cập nhật mã VCPA cấp 5 vào bảng $tablePhieuTonGiaoA43');
        // }
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  kiemTraMaVCPACap5(valueInput) {
    if (valueInput is TableCTDmNhomNganhVcpa) {
      if (valueInput != null) {
        if (valueInput.cap5 != null && valueInput.cap5 != '') {
          var res = tblCTDmNhomNganhVcpaSearch
              .where((x) => x.cap5 == valueInput.cap5!)
              .firstOrNull;
          if (res != null) {
            return res.cap5 != '';
          }
        }
      }
    } else if (valueInput is String) {
      var res = tblCTDmNhomNganhVcpaSearch
          .where((x) => x.cap5 == valueInput!)
          .firstOrNull;
      if (res != null) {
        return res.cap5 != '';
      }
    }

    return false;
  }

  onValidateInputVCPACap5A4_3(
      String table,
      String maCauHoi,
      String? fieldName,
      idValue,
      String? inputValue,
      minLen,
      maxLen,
      minValue,
      maxValue,
      int? loaiCauHoi) {
    if (inputValue == null || inputValue == '' || inputValue == 'null') {
      return 'Vui lòng nhập giá trị.';
    }
    // var res = kiemTraMaVCPACap5(inputValue);
    // if (!res) {
    //   //  searchResult.value = true;
    //   return 'Mã sản phẩm không có trong danh mục cấp 5';
    // }
    var checkRes = isDuplicateVCPAA4_3(inputValue);
    if (checkRes) {
      return 'Mã sản phẩm này đã có. Vui lòng chọn mã sản phẩm khác.';
    }
    return null;
  }

  getVcpaCap5Value(String table, idvalue, fieldName) {
    if (table == tablePhieuTonGiaoA43) {
      var res = tblPhieuTonGiaoA43.where((x) => x.id == idvalue).firstOrNull;
      if (res != null) {
        return res.a4_3_2;
      }
    }
    return '';
  }

  ///END:: PhieuTonGiaoA43 event
/*******/
  ///BEGIN::EVEN SELECT INT
  onSelect(String table, String? maCauHoi, String? fieldName, value) {
    log('ON CHANGE C1: $fieldName $value');

    // Map<String, dynamic> map = Map<String, dynamic>.from(answers);
    try {
      // map.update(key ?? "", (_value) => value, ifAbsent: () => value);
      // answers.value = map;

      updateAnswerToDB(table, fieldName ?? "", value);
      updateAnswerTblTonGiao(fieldName, value);
      if (fieldName == columnPhieuTonGiaoA7_2) {
        if (!value.toString().contains("1")) {
          updateAnswerToDB(table, columnPhieuTonGiaoA7_2_1, null);
          updateAnswerTblTonGiao(columnPhieuTonGiaoA7_2_1, null);
        } else if (!value.toString().contains("2")) {
          updateAnswerToDB(table, columnPhieuTonGiaoA7_2_2, null);
          updateAnswerTblTonGiao(columnPhieuTonGiaoA7_2_2, null);
        }
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  onSelectDm(QuestionCommonModel question, String table, String? maCauHoi,
      String? fieldName, value, dmItem) {
    log('ON CHANGE onSelectDm: $fieldName $value $dmItem');
    try {
      updateAnswerToDB(table, fieldName ?? "", value);
      updateAnswerTblTonGiao(fieldName, value);
      if (question.bangChiTieu != null && question.bangChiTieu != '') {
        var hasGhiRo = hasDanhMucGhiRoByTenDm(question.bangChiTieu!);
        if (hasGhiRo != null && hasGhiRo == true) {
          if (value != 17 && fieldName == maCauHoi) {
            String fieldNameGhiRo = '${maCauHoi!}_GhiRo';
            updateAnswerToDB(table, fieldNameGhiRo, null);
            updateAnswerTblTonGiao(fieldNameGhiRo, null);
          }
        }
      }
      if (question.maCauHoi == columnPhieuTonGiaoA1_5_6) {
        validateA1_5_6(question, table, maCauHoi, fieldName, value, dmItem);
      }
      if (question.maCauHoi == columnPhieuTonGiaoA1_6) {
        if (a1_6BuocNhay.contains(value.toString())) {
          updateAnswerToDB(table, columnPhieuTonGiaoA1_7, null);
          updateAnswerTblTonGiao(columnPhieuTonGiaoA1_7, null);
          updateAnswerToDB(table, columnPhieuTonGiaoA1_7GhiRo, null);
          updateAnswerTblTonGiao(columnPhieuTonGiaoA1_7GhiRo, null);
        }
      }
      if (question.maCauHoi == columnPhieuTonGiaoA1_6 &&
          fieldName == columnPhieuTonGiaoA1_6GhiRo) {
        if (value == 1) {
          updateAnswerToDB(table, columnPhieuTonGiaoA1_7, null);
          updateAnswerTblTonGiao(columnPhieuTonGiaoA1_7, null);
          updateAnswerToDB(table, columnPhieuTonGiaoA1_7GhiRo, null);
          updateAnswerTblTonGiao(columnPhieuTonGiaoA1_7GhiRo, null);
        }
      }
      if (question.maCauHoi == columnPhieuTonGiaoA1_7) {
        if (value != 17) {
          String fieldNameGhiRo = '${maCauHoi!}_GhiRo';
          updateAnswerToDB(table, fieldNameGhiRo, null);
          updateAnswerTblTonGiao(fieldNameGhiRo, null);
        }
      }
      if (question.maCauHoi == columnPhieuTonGiaoA5_1) {
        if (value != 1) {
          updateAnswerToDB(table, columnPhieuTonGiaoA5_2, null);
          updateAnswerTblTonGiao(columnPhieuTonGiaoA5_2, null);
          updateAnswerToDB(table, columnPhieuTonGiaoA5_2GhiRo, null);
          updateAnswerTblTonGiao(columnPhieuTonGiaoA5_2GhiRo, null);
        }
      }
      if (question.maCauHoi == columnPhieuTonGiaoA5_2) {
        if (value != 1) {
          String fieldNameGhiRo = '${maCauHoi!}_GhiRo';
          updateAnswerToDB(table, fieldNameGhiRo, null);
          updateAnswerTblTonGiao(fieldNameGhiRo, null);
        }
      }
      if (question.maCauHoi == "A5_3") {
        for (var i = 1; i <= 4; i++) {
          String fName = "A5_3_${i}_1";
          String fName2 = "A5_3_${i}_2";
          if (fieldName == fName) {
            if (value != 1) {
              updateAnswerToDB(table, fName2, null);
              updateAnswerTblTonGiao(fName2, null);
            }
            break;
          }
        }
      }
      if (question.maCauHoi == "A6_1") {
        for (var i = 1; i <= 11; i++) {
          String fName = "A6_1_${i}_1";
          String fName2 = "A6_1_${i}_2";
          String fName3 = "A6_1_${i}_3";
          if (fieldName == fName) {
            if (value != 1) {
              updateAnswerToDB(table, fName2, null);
              updateAnswerTblTonGiao(fName2, null);
              updateAnswerToDB(table, fName3, null);
              updateAnswerTblTonGiao(fName3, null);
            }
            break;
          }
        }
      }
      if (question.maCauHoi == columnPhieuTonGiaoA7_1) {
        if (value != 1) {
          updateAnswerToDB(table, columnPhieuTonGiaoA7_2, null);
          updateAnswerTblTonGiao(columnPhieuTonGiaoA7_2, null);
          updateAnswerToDB(table, columnPhieuTonGiaoA7_2_1, null);
          updateAnswerTblTonGiao(columnPhieuTonGiaoA7_2_1, null);
          updateAnswerToDB(table, columnPhieuTonGiaoA7_2_2, null);
          updateAnswerTblTonGiao(columnPhieuTonGiaoA7_2_2, null);
          onNext();
          //onKetThucPhongVan();
        }
      }

      // if (question.maCauHoi == columnPhieuTonGiaoA6_1) {
      //   if (value != 'I') {
      //     String fieldNameGhiRo = '${maCauHoi!}_GhiRo';
      //     updateAnswerToDB(table, fieldNameGhiRo, null);
      //     updateAnswerTblTonGiao(fieldNameGhiRo, null);
      //   }
      //   if (value != "A" && value != "F" && value != "G" && value != "H") {
      //     updateAnswerToDB(table, "A6_2_1", null);
      //     updateAnswerTblTonGiao("A6_2_1", null);
      //     updateAnswerToDB(table, "A6_2_2", null);
      //     updateAnswerTblTonGiao("A6_2_2", null);
      //     updateAnswerToDB(table, "A6_2_3", null);
      //     updateAnswerTblTonGiao("A6_2_3", null);
      //     updateAnswerToDB(table, "A6_2_4", null);
      //     updateAnswerTblTonGiao("A6_2_4", null);
      //   }
      // }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  //BEGIN::4_2
  onSelectDmA4_2(QuestionCommonModel question, String table, String? maCauHoi,
      String? fieldName, value, dmItem) async {
    log('ON CHANGE onSelectDmA4_2: $fieldName $value $dmItem');
    try {
      updateAnswerToDB(table, fieldName ?? "", value);
      updateAnswerTblTonGiao(fieldName, value);
      // if (question.bangChiTieu != null && question.bangChiTieu != '') {
      //   if (value != 17) {
      //     String fieldNameGhiRo = '${maCauHoi!}_GhiRo';
      //     updateAnswerToDB(table, fieldNameGhiRo, null);
      //     updateAnswerTblTonGiao(fieldNameGhiRo, null);
      //   }
      // }
      if (value == 2) {
        var resCheck = await checkExistA4_3();
        if (resCheck) {
          Get.dialog(DialogBarrierWidget(
            onPressedNegative: () async {
              await backYesValueForYesNoQuestionA4_2(
                  table, maCauHoi, fieldName, 1, question);
            },
            onPressedPositive: () async {
              updateAnswerToDB(table, fieldName!, value);
              await executeOnChangeYesNoQuestionA4_2(value);
              Get.back();
            },
            title: 'dialog_title_warning'.tr,
            content: 'dialog_content_warning_select_no'.tr,
          ));
        }
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  checkExistA4_3() async {
    return await phieuTonGiaoA43Provider.isExistQuestion(currentIdCoSo!);
  }

  backYesValueForYesNoQuestionA4_2(
      String table, String? maCauHoi, String? fieldName, value, dmItem) async {
    await updateAnswerToDB(table, fieldName!, value);
    Get.back();
  }

  executeOnChangeYesNoQuestionA4_2(value) async {
    log('ON executeOnChangeYesNoQuestionA4_2:  $value');

    try {
      if (value != 1) {
        await phieuTonGiaoA43Provider.deleteAllByIdCoSo(currentIdCoSo!);
        await getTablePhieuTonGiaoA43();
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

//END::4_2
  onSelectDmA1_8(
      String table, String? maCauHoi, String? fieldName, value, dmItem) {
    log('ON CHANGE onSelectDmA1_8: $fieldName $value $dmItem');
    try {
      updateAnswerToDB(table, fieldName!, value);
      updateAnswerTblTonGiao(fieldName, value);
      if (value == 1) {
        updateAnswerToDB(table, 'A1_8_2', null);
        updateAnswerTblTonGiao('A1_8_2', null);
        updateAnswerToDB(table, 'A1_9', null);
        updateAnswerTblTonGiao('A1_9', null);
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  getDanhMucByTenDm(String tenDanhMuc) {
    if (tenDanhMuc == tableTGDmCapCongNhan) {
      return tblDmCapCongNhan;
    } else if (tenDanhMuc == tableTGDmLoaiCoSo) {
      return tblDmLoaiCoSo;
    } else if (tenDanhMuc == tableTGDmLoaiHinhTonGiao) {
      return tblDmLoaiHinhTonGiao;
    } else if (tenDanhMuc == tableTGDmNangLuong) {
      return tblDmNangLuong;
    } else if (tenDanhMuc == tableTGDmSudDngPhanMem) {
      return tblDmSuDungPhanMem;
    } else if (tenDanhMuc == tableTGDmTrinhDoChuyenMon) {
      return tblDmTrinhDoChuyenMon;
    } else if (tenDanhMuc == tableTGDmXepHangDiTich) {
      return tblDmXepHangDiTich;
    } else if (tenDanhMuc == tableTGDmXepHang) {
      return tblDmXepHang;
    } else if (tenDanhMuc == tableDmGioiTinh) {
      return tblDmGioiTinh;
    } else if (tenDanhMuc == tableDmCoKhong) {
      return tblDmCoKhong;
    } else if (tenDanhMuc == tableCTDmHoatDongLogistic) {
      return tblDmHoatDongLogistic;
    }
    return null;
  }

  parseDmLogisticToChiTieuModel() {
    return TableCTDmHoatDongLogistic.toListChiTieuIntModel(
        tblDmHoatDongLogistic);
  }

  hasDanhMucGhiRoByTenDm(String tenDanhMuc) {
    if (tenDanhMuc == tableTGDmCapCongNhan) {
      return false;
    } else if (tenDanhMuc == tableTGDmLoaiCoSo) {
      return true;
    } else if (tenDanhMuc == tableTGDmLoaiHinhTonGiao) {
      return false;
    } else if (tenDanhMuc == tableTGDmNangLuong) {
      return false;
    } else if (tenDanhMuc == tableTGDmSudDngPhanMem) {
      return false;
    } else if (tenDanhMuc == tableTGDmTrinhDoChuyenMon) {
      return true;
    } else if (tenDanhMuc == tableTGDmXepHangDiTich) {
      return false;
    } else if (tenDanhMuc == tableTGDmXepHang) {
      return false;
    } else if (tenDanhMuc == tableDmGioiTinh) {
      return false;
    } else if (tenDanhMuc == tableDmCoKhong) {
      return false;
    } else if (tenDanhMuc == tableTGDmNangLuong) {
      return true;
    }
    return null;
  }

  onChangeGhiRoDm(QuestionCommonModel question, String? value, dmItem) {
    log('onChangeGhiRoDm Mã câu hỏi ${question.maCauHoi} ${question.bangChiTieu}');
    String fieldName = '${question.maCauHoi}_GhiRo';

    updateAnswerToDB(question.bangDuLieu!, fieldName, value);
    updateAnswerTblTonGiao(fieldName, value);
  }

  Future<Iterable<TableDmDanToc?>> onSearchDmDanToc(String search) async {
    keywordDanToc.value = search;
    if (search.length >= 1) {
      List<Map> danTocItems = await dmDanTocProvider.searchDmDanToc(search);
      var result = danTocItems.map((e) => TableDmDanToc.fromJson(e));
      tblDmDanTocSearch.value = result.toList();
      log('SEARCH RESULT: ${danTocItems.length}');
      //  await Future.delayed(const Duration(milliseconds: 1000));
      var res = tblDmDanTocSearch
          .where((x) => (x.maDanToc == search || x.tenDanToc == search))
          .firstOrNull;
      if (res != null) {}
      return result;
    }
    return [];
  }

  onValidateInputDanToc(String table, String maCauHoi, String? fieldName,
      String? valueInput, int? loaiCauHoi) {
    if (valueInput == null || valueInput == '' || valueInput == 'null') {
      return 'Vui lòng nhập giá trị.';
    }
    return null;
  }

  onChangeInputDanToc(
      String table, String maCauHoi, String? fieldName, value) async {
    log('ON onChangeInputDanToc: $fieldName $value');
    try {
      if (table == tablePhieuTonGiao) {
        String maDanToc = '';
        String tenDanToc = '';
        if (value is TableDmDanToc) {
          TableDmDanToc valueInput = value;
          if (valueInput != null) {
            maDanToc = valueInput.maDanToc!;
            tenDanToc = valueInput.tenDanToc!;
          }
        } else if (value is String) {
          maDanToc = value;
          tenDanToc = value;
        }
        updateAnswerToDB(table, fieldName!, maDanToc);
        updateAnswerTblTonGiao(fieldName, maDanToc);
        updateAnswerTblTonGiao('${fieldName}_tendantoc', tenDanToc);
        log('ON onChangeInputDanToc ĐÃ cập nhật mã dan toc');
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  getValueDanTocByFieldName(String table, String fieldName,
      {String? valueDataType}) {
    if (fieldName == null || fieldName == '') return null;
    var maDanToc = answerTblTonGiao['${fieldName}_tendantoc'];
    //var maDanToc = answerTblTonGiao['$fieldName'];
    if (maDanToc == null || maDanToc == '') {
      return '';
    }
    return maDanToc;
    // dmDanTocProvider.selectByMaDanToc(maDanToc).then((danTocItems) {
    //  // var danTocItems = dmDanTocProvider.selectByMaDanToc(maDanToc);
    //   var result = danTocItems.map((e) => TableDmDanToc.fromJson(e));
    //   var dtM= result.toList();
    //   log('getValueDanTocByFieldName: ${danTocItems.length}');
    //   var res = dtM.firstOrNull;
    //   if (res != null) {
    //     log('Ten Dan Toc: ${res.tenDanToc!}');
    //     return res.tenDanToc!;
    //   }
    // });

    //  return '';
  }

  ///END: SELECT INT
/*******/

  ///
  onChangeYesNoQuestion(
    String table,
    String? maCauHoi,
    String? fieldName,
    value,
  ) async {
    log('ON onChangeYesNoQuestion: $fieldName $value');

    try {
      await updateAnswerToDB(table, fieldName ?? "", value);
    } catch (e) {
      printError(info: e.toString());
    }
  }

  getValueDm(QuestionCommonModel question) {
    var res = answerTblTonGiao[question.maCauHoi];

    return res;
  }

  getValueDmA1_8(String fieldName) {
    var res = answerTblTonGiao[fieldName];

    return res;
  }

/*******/
  ///BEGIN::Chi tieu dong cot
  ///
  getFieldNameByChiTieuDongCot(
      ChiTieuModel chiTieuCot, ChiTieuDongModel chiTieuDong) {
    var fieldName = '${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo}';
    if (chiTieuDong.maCauHoi == "A4_1") {
      if (fieldName.contains('.')) {
        fieldName = fieldName.replaceAll('.', '_');
      }
    }
    if (chiTieuDong.maCauHoi == "A5_3" || chiTieuDong.maCauHoi == "A6_1") {
      fieldName =
          '${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo}_${chiTieuCot.maChiTieu}';
    }
    return fieldName;
  }

  // getFieldNameByGhiRoGiaTri(String maCauHoi) {
  //   if (maCauHoi == "A4_1") {
  //     return  columnPhieuTonGiaoA4_1_00;
  //   }
  // }
  onChangeChiTieuDongGhiRo(
      QuestionCommonModel question, String? value, fieldName) {
    log('onChangeChiTienDongGhiRo Mã câu hỏi ${question.maCauHoi} ${question.bangChiTieu} fieldName=$fieldName');

    updateAnswerToDB(question.bangDuLieu!, fieldName, value);
    updateAnswerTblTonGiao(fieldName, value);
  }

  onChangeInputChiTieuDongCot(
      String table, String? maCauHoi, String? fieldName, value,
      {QuestionCommonModel? question,
      ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong}) async {
    log('ON onChangeInput: $fieldName $value');

    try {
      if (table == tablePhieuTonGiao) {
        // if (maCauHoi == "A2_2") {
        //   var fieldNameTotal = "${maCauHoi}_01";
        //   var fieldNames = ['A2_2_02', 'A2_2_03', 'A2_2_04'];
        //   await updateAnswerDongCotToDB(table, fieldName!, value,
        //       fieldNames: fieldNames,
        //       fieldNameTotal: fieldNameTotal,
        //       maCauHoi: maCauHoi);
        // } //else
        if (maCauHoi == "A4_1") {
          // var fieldNameTotal = "${maCauHoi}_01";
          // var fieldNameTotalMaSo02 = "${maCauHoi}_02";
          // var fieldNamesMaSo02 = [
          //   'A4_1_03',
          //   'A4_1_04',
          //   'A4_1_05',
          //   'A4_1_06',
          //   'A4_1_07',
          //   'A4_1_07_1'
          // ];
          // var fieldNames = [
          //   'A4_1_03',
          //   'A4_1_04',
          //   'A4_1_05',
          //   'A4_1_06',
          //   'A4_1_07',
          //   'A4_1_07_1',
          //   'A4_1_08',
          //   'A4_1_09',
          //   'A4_1_10'
          // ];
          // await updateAnswerDongCotToDBA4_1(table, fieldName!, value,
          //     fieldNames: fieldNames,
          //     fieldNameTotal: fieldNameTotal,
          //     fieldNamesMaSo02: fieldNamesMaSo02,
          //     fieldNameTotalMaSo02: fieldNameTotalMaSo02,
          //     maCauHoi: maCauHoi);
          if (fieldName != null && fieldName != '') {
            if (fieldName!.contains('.')) {
              fieldName = fieldName.replaceAll('.', '_');
            }
          }
          updateAnswerDongCotToDB(table, fieldName!, value);

          if (fieldName == columnPhieuTonGiaoA4_1_07_1) {
            if (value == null || value == '') {
              updateAnswerDongCotToDB(
                  table, columnPhieuTonGiaoA4_1_07_1GhiRo, null);
            }
          }
          if (fieldName == columnPhieuTonGiaoA4_1_10) {
            if (value == null || value == '') {
              updateAnswerDongCotToDB(
                  table, columnPhieuTonGiaoA4_1_10GhiRo, null);
            }
          }
        } else {
          List<String> fieldNames = [];
          String fieldNameTotal = "";
          await updateAnswerDongCotToDB(table, fieldName!, value,
              fieldNames: fieldNames,
              fieldNameTotal: fieldNameTotal,
              maCauHoi: maCauHoi);
        }
      }
    } catch (e) {
      printError(info: e.toString());
    }
    //  await getTablePhieu04Sanpham();
  }

  // calA4_1() {
  //   num a4_1_01 = answerTblTonGiao[columnPhieuTonGiaoA4_1_01] ?? 0;
  //   num a4_1_02 = answerTblTonGiao[columnPhieuTonGiaoA4_1_02] ?? 0;
  //   num a4_1_03 = answerTblTonGiao[columnPhieuTonGiaoA4_1_03] ?? 0;
  //   num a4_1_04 = answerTblTonGiao[columnPhieuTonGiaoA4_1_04] ?? 0;
  //   num a4_1_05 = answerTblTonGiao[columnPhieuTonGiaoA4_1_05] ?? 0;
  //   num a4_1_06 = answerTblTonGiao[columnPhieuTonGiaoA4_1_06] ?? 0;
  //   num a4_1_07 = answerTblTonGiao[columnPhieuTonGiaoA4_1_07] ?? 0;
  //   num a4_1_07_1 = answerTblTonGiao[columnPhieuTonGiaoA4_1_07_1] ?? 0;
  //   num a4_1_08 = answerTblTonGiao[columnPhieuTonGiaoA4_1_08] ?? 0;
  //   num a4_1_09 = answerTblTonGiao[columnPhieuTonGiaoA4_1_09] ?? 0;
  //   num a4_1_10 = answerTblTonGiao[columnPhieuTonGiaoA4_1_10] ?? 0;

  //   a4_1_01 = a4_1_02 + a4_1_08 + a4_1_09 + a4_1_10;
  //   a4_1_02 = a4_1_03 + a4_1_04 + a4_1_05 + a4_1_06 + a4_1_07 + a4_1_07_1;
  //   phieuTonGiaoProvider.updateValue(
  //       columnPhieuTonGiaoA4_1_01, a4_1_01, currentIdCoSo);
  //   updateAnswerTblTonGiao(columnPhieuTonGiaoA4_1_02, a4_1_02);
  // }

  updateAnswerDongCotToDB(String table, String fieldName, value,
      {List<String>? fieldNames,
      String? fieldNameTotal,
      String? maCauHoi}) async {
    if (fieldName == '') return;
    if (table == tablePhieuTonGiao) {
      await phieuTonGiaoProvider.updateValue(fieldName, value, currentIdCoSo);
      await updateAnswerTblTonGiao(fieldName, value);

      // if (maCauHoi == 'A2_2') {
      //   var total = await phieuTonGiaoProvider.totalIntByMaCauHoi(
      //       currentIdCoSo!, fieldNames!);

      //   await phieuTonGiaoProvider.updateValue(
      //       fieldNameTotal!, total, currentIdCoSo);
      //   await updateAnswerTblTonGiao(fieldNameTotal, total);
      // }
    } else {
      snackBar("dialog_title_warning".tr, "data_table_undefine".tr);
    }
  }

  updateAnswerDongCotToDBA4_1(String table, String fieldName, value,
      {List<String>? fieldNames,
      String? fieldNameTotal,
      List<String>? fieldNamesMaSo02,
      String? fieldNameTotalMaSo02,
      String? maCauHoi}) async {
    if (fieldName == '') return;
    if (table == tablePhieuTonGiao) {
      await phieuTonGiaoProvider.updateValue(fieldName, value, currentIdCoSo);
      await updateAnswerTblTonGiao(fieldName, value);
      if (maCauHoi == "A4_1") {
        var total = await phieuTonGiaoProvider.totalDoubleByMaCauHoi(
            currentIdCoSo!, fieldNames!);
        var totalMaSo02 = await phieuTonGiaoProvider.totalDoubleByMaCauHoi(
            currentIdCoSo!, fieldNamesMaSo02!);
        await phieuTonGiaoProvider.updateValue(
            fieldNameTotal!, total, currentIdCoSo);
        await phieuTonGiaoProvider.updateValue(
            fieldNameTotalMaSo02!, totalMaSo02, currentIdCoSo);
        await updateAnswerTblTonGiao(fieldNameTotal, total);
        await updateAnswerTblTonGiao(fieldNameTotalMaSo02, totalMaSo02);
      }
    } else {
      snackBar("dialog_title_warning".tr, "data_table_undefine".tr);
    }
  }

  onValidateInputChiTieuDongCot(
      QuestionCommonModel question,
      ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong,
      String fieldName,
      String? valueInput,
      bool typing) {
    var table = question.bangDuLieu;
    var maCauHoi = question.maCauHoi;
    var minValue = chiTieuCot!.giaTriNN;
    var maxValue = chiTieuCot.giaTriLN;

    if (maCauHoi == "A2_2") {
      var validRes = onValidateA2_2(
          question, chiTieuCot, chiTieuDong, fieldName, valueInput, typing);
      if (validRes != null && validRes != '') {
        return validRes;
      }
      return null;
    }
    if (question.maCauHoi == "A4_1") {
      var res = onValidateA4_1(
          question, chiTieuCot, chiTieuDong!, fieldName, valueInput, typing);
      if (res != null && res != '') {
        return res;
      }
      return null;
    }
    if (maCauHoi == "A5_3") {
      var validRes = onValidateA5_3(
          question, chiTieuCot, chiTieuDong, fieldName, valueInput);
      if (validRes != null && validRes != '') {
        return validRes;
      }
      return null;
    }
    if (maCauHoi == "A6_1") {
      var validRes = onValidateA6_1(
          question, chiTieuCot, chiTieuDong, fieldName, valueInput);
      if (validRes != null && validRes != '') {
        return validRes;
      }
      return null;
    }
    if (valueInput == null || valueInput == "null" || valueInput == "") {
      return 'Vui lòng nhập giá trị.';
    }
    //var fieldName = getFieldNameByChiTieuDongCot(chiTieuCot, chiTieuDong!);

    if (fieldName == '') {
      return null;
    }
  }

  onValidateA2_2(
      QuestionCommonModel question,
      ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong,
      String fieldName,
      String? inputValue,
      typing) {
    int currentYear = 2025;
    num minVal = 0;
    num maxVal = 99999;
    if (chiTieuCot!.maChiTieu == '1') {
      minVal = chiTieuCot!.giaTriNN ?? 0;
      maxVal = chiTieuCot!.giaTriLN ?? 99999;
    }
    if (validateEmptyString(inputValue)) {
      return 'Vui lòng nhập giá trị.';
    }

    num intputVal = inputValue != null
        ? AppUtils.convertStringToInt(inputValue.replaceAll(' ', ''))
        : 0;
    if (intputVal < minVal) {
      return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
    } else if (intputVal > maxVal) {
      return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
    }
    //if (typing == false) {
    var tblPhieuTG;
    // tblPhieuTonGiao.value.toJson();
    if (typing == false) {
      tblPhieuTG = tblPhieuTonGiao.value.toJson();
    } else {
      tblPhieuTG = answerTblTonGiao;
    }
    var a1_5_4NamSinh = tblPhieuTG[columnPhieuTonGiaoA1_5_4] != null
        ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA1_5_4])
        : 0;
    int soTuoi = currentYear - a1_5_4NamSinh;

    int a2_2_01TongSoTrongDo = 0;
    int a2_2_01Value = 0;
    a2_2_01Value = tblPhieuTG[columnPhieuTonGiaoA2_2_01] != null
        ? AppUtils.convertStringToInt(
            tblPhieuTG[columnPhieuTonGiaoA2_2_01].toString())
        : 0;
    if (chiTieuDong!.maSo == '01' ||
        chiTieuDong!.maSo == '02' ||
        chiTieuDong!.maSo == '03' ||
        chiTieuDong!.maSo == '04') {
      int a2_2_02Value = tblPhieuTG[columnPhieuTonGiaoA2_2_02] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_02])
          : 0;
      int a2_2_03Value = tblPhieuTG[columnPhieuTonGiaoA2_2_03] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_03])
          : 0;
      int a2_2_04Value = tblPhieuTG[columnPhieuTonGiaoA2_2_04] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_04])
          : 0;
      a2_2_01TongSoTrongDo = a2_2_02Value + a2_2_03Value + a2_2_04Value;
    }

    int a2_2_01TongSoTDCM = 0;
    // int a2_2_01TongSoNhomTuoi = 0;
    List<String> maSoTDCM = [];
    List<String> maSoNTuoi = [];
    for (var i = 5; i <= 15; i++) {
      String ms = '0$i';
      if (i > 9) {
        ms = '$i';
      }
      maSoTDCM.add(ms);
      String fNameTs = 'A2_2_$ms';

      int a2_2_xValue = tblPhieuTG[fNameTs] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[fNameTs])
          : 0;

      a2_2_01TongSoTDCM += a2_2_xValue;
    }
    // for (var i = 16; i <= 20; i++) {
    //   maSoNTuoi.add('$i');
    //   String fNameTs = 'A2_2_$i';
    //   int a2_2_xValue = tblPhieuTG[fNameTs] != null
    //       ? AppUtils.convertStringToInt(tblPhieuTG[fNameTs])
    //       : 0;

    //   a2_2_01TongSoNhomTuoi += a2_2_xValue;
    // }

    if (chiTieuDong!.maSo == '01') {
      // if (a2_2_01Value < a2_2_01TongSoTrongDo) {
      //   return 'Mã số 01 Tổng số ($a2_2_01Value) phải lớn hơn Trong đó (02 + 03 + 04 = $a2_2_01TongSoTrongDo )';
      // }
      if (a2_2_01Value != a2_2_01TongSoTDCM) {
        return 'Mã số 01 Tổng số ($a2_2_01Value) khác chi tiết 1. Lao động chia theo trình độ CMKT (${maSoTDCM.join(' + ')} = $a2_2_01TongSoTDCM )';
      }
      // if (a2_2_01Value != a2_2_01TongSoNhomTuoi) {
      //   return 'Mã số 01 Tổng số ($a2_2_01Value) khác chi tiết 2. Lao động chia theo nhóm tuổi (${maSoNTuoi.join(' + ')} = $a2_2_01TongSoNhomTuoi)';
      // }
    } else if (chiTieuDong!.maSo == '02') {
      int a2_2_02Value = tblPhieuTG[columnPhieuTonGiaoA2_2_02] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_02])
          : 0;

      var a1_5_2Phamsac = tblPhieuTG[columnPhieuTonGiaoA1_5_2] != null
          ? tblPhieuTG[columnPhieuTonGiaoA1_5_2].toString()
          : '';

      if (validateNotEmptyString(a1_5_2Phamsac)) {
        if (validate0InputValue(a2_2_02Value)) {
          return 'Cơ sở có người có chức sắc tôn giáo tại A1.5 nhưng Lao động là người có chức sắc tôn giáo tại A2.2 Mã số 02 - Chức sắc tôn giáo = 0';
        }
      }
      if (a2_2_01Value < a2_2_02Value) {
        return 'Mã số 02 - Chức sắc tôn giáo ($a2_2_02Value) phải nhỏ hơn Mã số 01 Tổng số ($a2_2_01Value).';
      }
    } else if (chiTieuDong!.maSo == '03') {
      int a2_2_03Value = tblPhieuTG[columnPhieuTonGiaoA2_2_03] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_03])
          : 0;

      var a1_5_5DanToc = tblPhieuTG[columnPhieuTonGiaoA1_5_5] != null
          ? tblPhieuTG[columnPhieuTonGiaoA1_5_5].toString()
          : '';

      if (validateNotEmptyString(a1_5_5DanToc) && a1_5_5DanToc == '55') {
        if (validate0InputValue(a2_2_03Value)) {
          return 'Cơ sở có người nước ngoài tại A1.5 nhưng Lao động là người nước ngoài tại A2.2 Mã số 03 - Người nước ngoài = 0';
        }
      }
      if (a2_2_01Value < a2_2_03Value) {
        return 'Mã số 03 - Người nước ngoài ($a2_2_03Value) phải nhỏ hơn Mã số 01 Tổng số ($a2_2_01Value).';
      }
    } else if (chiTieuDong!.maSo == '04') {
      int a2_2_04Value = tblPhieuTG[columnPhieuTonGiaoA2_2_04] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_04])
          : 0;

      var a1_5_3GioiTinh = tblPhieuTG[columnPhieuTonGiaoA1_5_3] != null
          ? tblPhieuTG[columnPhieuTonGiaoA1_5_3].toString()
          : '';

      ///A.2.2=1 và A1.5 giới tính người đứng đầu=1 (nam) và câu A2.2_Nữ >0
      if (validateNotEmptyString(a1_5_3GioiTinh) && a1_5_3GioiTinh == '1') {
        if (a2_2_04Value > 0 && a2_2_01Value == 1) {
          return 'Cơ sở có 1 lao động là nam (là người đứng đầu cơ sở) mà A2.2 Mã số 04 - Nữ > 0';
        }
        if (a2_2_04Value >= a2_2_01Value) {
          return 'Cơ sở có 1 lao động là nam (là người đứng đầu cơ sở) mà A2.2 Mã số 04 - Nữ > 0';
        }
      }

      ///Nếu Câu A1.5 giới tính người đứng đầu=2 (nữ) và A2.2_Nữ =0;
      if (validateNotEmptyString(a1_5_3GioiTinh) && a1_5_3GioiTinh == '2') {
        if (validate0InputValue(a2_2_04Value) && a2_2_01Value > 0) {
          return 'Cơ sở có 1 lao động là nữ (là người đứng đầu cơ sở) mà A2.2 Mã số 04 - Nữ = 0';
        }
      }
      if (a2_2_01Value < a2_2_04Value) {
        return 'Mã số 04 - Nữ ($a2_2_04Value) phải nhỏ hơn Mã số 01 Tổng số ($a2_2_01Value).';
      }
    } else if (chiTieuDong!.maSo == '05') {
      int a2_2_05Value = tblPhieuTG[columnPhieuTonGiaoA2_2_05] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_05])
          : 0;

      var a1_5_6TDCM = tblPhieuTG[columnPhieuTonGiaoA1_5_6] != null
          ? tblPhieuTG[columnPhieuTonGiaoA1_5_6].toString()
          : '';
      if (validateNotEmptyString(a1_5_6TDCM) && a1_5_6TDCM == '1') {
        if (validate0InputValue(a2_2_05Value)) {
          return 'Chủ cơ sở có Trình độ chuyên môn chưa qua đào tạo tại A1.5 nhưng không có lao động nào chưa qua đào tạo (A2.2 Mã số 05 - Chưa qua đào tạo = 0)';
        }
      }
    } else if (chiTieuDong!.maSo == '06') {
      int a2_2_06Value = tblPhieuTG[columnPhieuTonGiaoA2_2_06] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_06])
          : 0;

      var a1_5_6TDCM = tblPhieuTG[columnPhieuTonGiaoA1_5_6] != null
          ? tblPhieuTG[columnPhieuTonGiaoA1_5_6].toString()
          : '';
      if (validateNotEmptyString(a1_5_6TDCM) && a1_5_6TDCM == '2') {
        if (validate0InputValue(a2_2_06Value)) {
          return 'Chủ cơ sở có Trình độ chuyên môn đã qua đào tạo nhưng không có chứng chỉ tại A1.5 mà không có lao động đã qua đào tạo nhưng không có chứng chỉ (A2.2 Mã số 06 - Đã qua đào tạo nhưng không có chứng chỉ = 0)';
        }
      }
    } else if (chiTieuDong!.maSo == '07') {
      int a2_2_07Value = tblPhieuTG[columnPhieuTonGiaoA2_2_07] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_07])
          : 0;

      var a1_5_6TDCM = tblPhieuTG[columnPhieuTonGiaoA1_5_6] != null
          ? tblPhieuTG[columnPhieuTonGiaoA1_5_6].toString()
          : '';
      if (validateNotEmptyString(a1_5_6TDCM) && a1_5_6TDCM == '3') {
        if (validate0InputValue(a2_2_07Value)) {
          return 'Chủ cơ sở có Trình độ chuyên môn Có chứng chỉ đào tạo tại A1.5 mà không có lao động nào Có chứng chỉ đào tạo (A2.2 Mã số 07 - Có chứng chỉ đào tạo = 0)';
        }
      }
    } else if (chiTieuDong!.maSo == '08') {
      int a2_2_08Value = tblPhieuTG[columnPhieuTonGiaoA2_2_08] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_08])
          : 0;

      var a1_5_6TDCM = tblPhieuTG[columnPhieuTonGiaoA1_5_6] != null
          ? tblPhieuTG[columnPhieuTonGiaoA1_5_6].toString()
          : '';
      if (validateNotEmptyString(a1_5_6TDCM) && a1_5_6TDCM == '4') {
        if (validate0InputValue(a2_2_08Value)) {
          return 'Chủ cơ sở có Trình độ chuyên môn Sơ cấp tại A1.5 mà không có lao động nào Sơ cấp (A2.2 Mã số 08 - Sơ cấp = 0)';
        }
      }
    } else if (chiTieuDong!.maSo == '09') {
      int a2_2_09Value = tblPhieuTG[columnPhieuTonGiaoA2_2_09] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_09])
          : 0;

      var a1_5_6TDCM = tblPhieuTG[columnPhieuTonGiaoA1_5_6] != null
          ? tblPhieuTG[columnPhieuTonGiaoA1_5_6].toString()
          : '';
      if (validateNotEmptyString(a1_5_6TDCM) && a1_5_6TDCM == '5') {
        if (validate0InputValue(a2_2_09Value)) {
          return 'Chủ cơ sở có Trình độ chuyên môn Trung cấp tại A1.5 mà không có lao động nào Trung cấp (A2.2 Mã số 09 -  Trung cấp = 0)';
        }
      }
    } else if (chiTieuDong!.maSo == '10') {
      int a2_2_10Value = tblPhieuTG[columnPhieuTonGiaoA2_2_10] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_10])
          : 0;

      var a1_5_6TDCM = tblPhieuTG[columnPhieuTonGiaoA1_5_6] != null
          ? tblPhieuTG[columnPhieuTonGiaoA1_5_6].toString()
          : '';
      if (validateNotEmptyString(a1_5_6TDCM) && a1_5_6TDCM == '6') {
        if (validate0InputValue(a2_2_10Value)) {
          return 'Chủ cơ sở có Trình độ chuyên môn chưa qua đào tạo tại A1.5 mà không có lao động nào chưa qua đào tạo (A2.2 Mã số 10 - Cao đẳng = 0)';
        }
      }
    } else if (chiTieuDong!.maSo == '11') {
      int a2_2_11Value = tblPhieuTG[columnPhieuTonGiaoA2_2_11] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_11])
          : 0;

      var a1_5_6TDCM = tblPhieuTG[columnPhieuTonGiaoA1_5_6] != null
          ? tblPhieuTG[columnPhieuTonGiaoA1_5_6].toString()
          : '';
      if (validateNotEmptyString(a1_5_6TDCM) && a1_5_6TDCM == '7') {
        if (validate0InputValue(a2_2_11Value)) {
          return 'Chủ cơ sở có Trình độ chuyên môn Đại học tạo tại A1.5 mà không có lao động nào Đại học (A2.2 Mã số 11 - Đại học = 0)';
        }
      }
    } else if (chiTieuDong!.maSo == '12') {
      int a2_2_12Value = tblPhieuTG[columnPhieuTonGiaoA2_2_12] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_12])
          : 0;

      var a1_5_6TDCM = tblPhieuTG[columnPhieuTonGiaoA1_5_6] != null
          ? tblPhieuTG[columnPhieuTonGiaoA1_5_6].toString()
          : '';
      if (validateNotEmptyString(a1_5_6TDCM) && a1_5_6TDCM == '8') {
        if (validate0InputValue(a2_2_12Value)) {
          return 'Chủ cơ sở có Trình độ chuyên môn Thạc sỹ tại A1.5 mà không có lao động nào Thạc sỹ (A2.2 Mã số 12 - Thạc sỹ = 0)';
        }
      }
    } else if (chiTieuDong!.maSo == '13') {
      int a2_2_13Value = tblPhieuTG[columnPhieuTonGiaoA2_2_13] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_13])
          : 0;

      var a1_5_6TDCM = tblPhieuTG[columnPhieuTonGiaoA1_5_6] != null
          ? tblPhieuTG[columnPhieuTonGiaoA1_5_6].toString()
          : '';
      if (validateNotEmptyString(a1_5_6TDCM) && a1_5_6TDCM == '9') {
        if (validate0InputValue(a2_2_13Value)) {
          return 'Chủ cơ sở có Trình độ chuyên môn Tiến sỹ tại A1.5 mà không có lao động nào Tiến sỹ (A2.2 Mã số 13 - Tiến sỹ = 0)';
        }
      }
    } else if (chiTieuDong!.maSo == '14') {
      int a2_2_14Value = tblPhieuTG[columnPhieuTonGiaoA2_2_14] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_14])
          : 0;

      var a1_5_6TDCM = tblPhieuTG[columnPhieuTonGiaoA1_5_6] != null
          ? tblPhieuTG[columnPhieuTonGiaoA1_5_6].toString()
          : '';
      if (validateNotEmptyString(a1_5_6TDCM) && a1_5_6TDCM == '10') {
        if (validate0InputValue(a2_2_14Value)) {
          return 'Chủ cơ sở có Trình độ chuyên môn Hoàn thành sau tiến sĩ tại A1.5 mà không có lao động nào Hoàn thành sau tiến sĩ (A2.2 Mã số 14 - Hoàn thành sau tiến sĩ = 0)';
        }
      }
    } else if (chiTieuDong!.maSo == '15') {
      int a2_2_15Value = tblPhieuTG[columnPhieuTonGiaoA2_2_15] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_15])
          : 0;

      var a1_5_6TDCM = tblPhieuTG[columnPhieuTonGiaoA1_5_6] != null
          ? tblPhieuTG[columnPhieuTonGiaoA1_5_6].toString()
          : '';
      if (validateNotEmptyString(a1_5_6TDCM) && a1_5_6TDCM == '11') {
        if (validate0InputValue(a2_2_15Value)) {
          return 'Chủ cơ sở có Trình độ chuyên môn Trình độ khác tại A1.5 mà không có lao động nào Trình độ khác (A2.2 Mã số 15 - Trình độ khác = 0)';
        }
      }
    } else if (chiTieuDong!.maSo == '16') {
      int a2_2_16Value = tblPhieuTG[columnPhieuTonGiaoA2_2_16] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_16])
          : 0;

      // var a1_5_4NamSinh = tblPhieuTG[columnPhieuTonGiaoA1_5_4] != null
      //     ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA1_5_4])
      //     : 0;
      if (soTuoi >= 15 && soTuoi <= 24) {
        if (validate0InputValue(a2_2_16Value)) {
          return 'Chủ cơ sở $soTuoi tuổi trong độ tuổi 15-24 mà lao động nhóm tuổi 15 đến 24=0 (Mã số 16)';
        }
      }
      if (a2_2_16Value > a2_2_01Value) {
        return 'Mã số 16 nhóm tuổi 15 đến 24 = $a2_2_16Value đang lớn hơn Mã số 01 Tổng số ($a2_2_01Value) ';
      }
    } else if (chiTieuDong!.maSo == '17') {
      int a2_2_17Value = tblPhieuTG[columnPhieuTonGiaoA2_2_17] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_17])
          : 0;

      if (soTuoi >= 25 && soTuoi <= 34) {
        if (validate0InputValue(a2_2_17Value)) {
          return 'Chủ cơ sở $soTuoi tuổi trong độ tuổi 25-34 mà lao động nhóm tuổi 25 đến 34=0 (Mã số 17)';
        }
      }
      if (a2_2_17Value > a2_2_01Value) {
        return 'Mã số 17 nhóm tuổi 25 đến 34 = $a2_2_17Value đang lớn hơn Mã số 01 Tổng số ($a2_2_01Value) ';
      }
    } else if (chiTieuDong!.maSo == '18') {
      int a2_2_18Value = tblPhieuTG[columnPhieuTonGiaoA2_2_18] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_18])
          : 0;

      if (soTuoi >= 35 && soTuoi <= 44) {
        if (validate0InputValue(a2_2_18Value)) {
          return 'Chủ cơ sở $soTuoi tuổi trong độ tuổi 35-44 mà lao động nhóm tuổi 35 đến 44=0 (Mã số 18)';
        }
      }
      if (a2_2_18Value > a2_2_01Value) {
        return 'Mã số 18 nhóm tuổi 35 đến 44 = $a2_2_18Value đang lớn hơn Mã số 01 Tổng số ($a2_2_01Value) ';
      }
    } else if (chiTieuDong!.maSo == '19') {
      int a2_2_19Value = tblPhieuTG[columnPhieuTonGiaoA2_2_19] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_19])
          : 0;

      if (soTuoi >= 45 && soTuoi <= 54) {
        if (validate0InputValue(a2_2_19Value)) {
          return 'Chủ cơ sở $soTuoi tuổi trong độ tuổi 45-54 mà lao động nhóm tuổi 45 đến 54=0 (Mã số 19)';
        }
      }
      if (a2_2_19Value > a2_2_01Value) {
        return 'Mã số 19 nhóm tuổi 45 đến 54 = $a2_2_19Value đang lớn hơn Mã số 01 Tổng số ($a2_2_01Value) ';
      }
    } else if (chiTieuDong!.maSo == '20') {
      int a2_2_20Value = tblPhieuTG[columnPhieuTonGiaoA2_2_20] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_20])
          : 0;

      if (soTuoi >= 55 && soTuoi <= 59) {
        if (validate0InputValue(a2_2_20Value)) {
          return 'Chủ cơ sở $soTuoi tuổi trong độ tuổi 55-59 mà lao động nhóm tuổi 55 đến 59=0 (Mã số 20)';
        }
      }
      if (a2_2_20Value > a2_2_01Value) {
        return 'Mã số 20 nhóm tuổi 55 đến 59 = $a2_2_20Value đang lớn hơn Mã số 01 Tổng số ($a2_2_01Value) ';
      }
    } else if (chiTieuDong!.maSo == '21') {
      int a2_2_21Value = tblPhieuTG[columnPhieuTonGiaoA2_2_21] != null
          ? AppUtils.convertStringToInt(tblPhieuTG[columnPhieuTonGiaoA2_2_21])
          : 0;

      if (soTuoi >= 60) {
        if (validate0InputValue(a2_2_21Value)) {
          return 'Chủ cơ sở $soTuoi tuổi trong độ tuổi từ 60 trở lên mà lao động nhóm tuổi từ 60 trở lên =0 (Mã số 21)';
        }
      }
      if (a2_2_21Value > a2_2_01Value) {
        return 'Mã số 21 nhóm tuổi 60 trở lên = $a2_2_21Value đang lớn hơn Mã số 01 Tổng số ($a2_2_01Value) ';
      }
    }
    // } else {}

    return null;
  }

  onValidateA6_1(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String fieldName, String? valueInput,
      {bool? typing = false}) {
    var table = question.bangDuLieu;
    var maCauHoi = question.maCauHoi;
    var minValue = chiTieuCot!.giaTriNN;
    var maxValue = chiTieuCot.giaTriLN;
    for (var i = 1; i <= 11; i++) {
      var fName = 'A6_1_${i.toString()}_1';
      if (fieldName == fName) {
        if (valueInput == null || valueInput == "null" || valueInput == "") {
          return 'Vui lòng nhập giá trị.';
        }
      }
    }
    if (typing == false) {
      var tblPhieuTG = tblPhieuTonGiao.value.toJson();
      for (var i = 1; i <= 11; i++) {
        var fName1 = 'A6_1_${i.toString()}_1';
        var fName2 = 'A6_1_${i.toString()}_2';
        var fName3 = 'A6_1_${i.toString()}_3';
        var a6_1_x_1Value = tblPhieuTG[fName1];
        var a6_1_x_2Value = tblPhieuTG[fName2];
        var a6_1_x_3Value = tblPhieuTG[fName3];
        if (fieldName == fName2 || fieldName == fName3) {
          if (a6_1_x_1Value.toString() == '1') {
            if (valueInput == null ||
                valueInput == "null" ||
                valueInput == "") {
              return 'Vui lòng nhập giá trị.';
            }
          }
        }
      }

      return null;
    }
  }

  onValidateA5_3(QuestionCommonModel question, ChiTieuModel? chiTieuCot,
      ChiTieuDongModel? chiTieuDong, String fieldName, String? valueInput,
      {bool? typing = false}) {
    var table = question.bangDuLieu;
    var maCauHoi = question.maCauHoi;
    var minValue = chiTieuCot!.giaTriNN;
    var maxValue = chiTieuCot.giaTriLN;
    if (fieldName == columnPhieuTonGiaoA5_3_1_1 ||
        fieldName == columnPhieuTonGiaoA5_3_2_1 ||
        fieldName == columnPhieuTonGiaoA5_3_3_1 ||
        fieldName == columnPhieuTonGiaoA5_3_4_1) {
      if (valueInput == null || valueInput == "null" || valueInput == "") {
        return 'Vui lòng nhập giá trị.';
      }
    }
    if (typing == false) {
      var tblPhieuTG = tblPhieuTonGiao.value.toJson();
      var a5_3_1_1Value = tblPhieuTG[columnPhieuTonGiaoA5_3_1_1];
      var a5_3_1_2Value = tblPhieuTG[columnPhieuTonGiaoA5_3_1_2];
      var a5_3_2_1Value = tblPhieuTG[columnPhieuTonGiaoA5_3_2_1];
      var a5_3_2_2Value = tblPhieuTG[columnPhieuTonGiaoA5_3_2_2];
      var a5_3_3_1Value = tblPhieuTG[columnPhieuTonGiaoA5_3_3_1];
      var a5_3_3_2Value = tblPhieuTG[columnPhieuTonGiaoA5_3_3_2];
      var a5_3_4_1Value = tblPhieuTG[columnPhieuTonGiaoA5_3_4_1];
      var a5_3_4_2Value = tblPhieuTG[columnPhieuTonGiaoA5_3_4_2];
      if (fieldName == columnPhieuTonGiaoA5_3_1_2) {
        if (a5_3_1_1Value.toString() == '1') {
          if (valueInput == null || valueInput == "null" || valueInput == "") {
            return 'Vui lòng nhập giá trị.';
          }
        }
      }
      if (fieldName == columnPhieuTonGiaoA5_3_2_2) {
        if (a5_3_2_1Value.toString() == '1') {
          if (valueInput == null || valueInput == "null" || valueInput == "") {
            return 'Vui lòng nhập giá trị.';
          }
        }
      }
      if (fieldName == columnPhieuTonGiaoA5_3_3_2) {
        if (a5_3_3_1Value.toString() == '1') {
          if (valueInput == null || valueInput == "null" || valueInput == "") {
            return 'Vui lòng nhập giá trị.';
          }
        }
      }
      if (fieldName == columnPhieuTonGiaoA5_3_4_2) {
        if (a5_3_4_1Value.toString() == '1') {
          if (valueInput == null || valueInput == "null" || valueInput == "") {
            return 'Vui lòng nhập giá trị.';
          }
        }
      }
      return null;
    }
  }

  onValidateA4_1(
      QuestionCommonModel question,
      ChiTieuModel chiTieuCot,
      ChiTieuDongModel chiTieuDong,
      String fieldName,
      String? inputValue,
      bool typing) {
    // var fieldName = getFieldNameByChiTieuDongCot(chiTieuCot, chiTieuDong);
    num minVal = 0;
    num maxVal = 999999;
    if (chiTieuDong!.maSo == '01') {
      minVal = chiTieuDong!.giaTriNN ?? 1;
      maxVal = chiTieuCot!.giaTriLN ?? 999999;
    }
    if (chiTieuDong!.maSo == '02' ||
        chiTieuDong!.maSo == '03' ||
        chiTieuDong!.maSo == '04' ||
        chiTieuDong!.maSo == '05' ||
        chiTieuDong!.maSo == '06' ||
        chiTieuDong!.maSo == '07') {
      minVal = chiTieuDong!.giaTriNN ?? 0;
      maxVal = chiTieuCot!.giaTriLN ?? 999999;
    }
    if (chiTieuDong!.maSo == '08' ||
        chiTieuDong!.maSo == '08.1' ||
        chiTieuDong!.maSo == '09' ||
        chiTieuDong!.maSo == '10') {
      minVal = chiTieuDong!.giaTriNN ?? 0;
      maxVal = chiTieuCot!.giaTriLN ?? 999999999;
    }
    //if (typing == false) {
    var tblPhieuTG;
    // tblPhieuTonGiao.value.toJson();
    if (typing == false) {
      tblPhieuTG = tblPhieuTonGiao.value.toJson();
    } else {
      tblPhieuTG = answerTblTonGiao;
    }

    if (fieldName == columnPhieuTonGiaoA4_1_07_1GhiRo) {
      num a4_1_07 = tblPhieuTG[columnPhieuTonGiaoA4_1_07_1] ?? 0;
      var a4_1_07GhiRoValue = tblPhieuTG[columnPhieuTonGiaoA4_1_07_1GhiRo];
      if (a4_1_07 > 0) {
        if (validateEmptyString(a4_1_07GhiRoValue.toString())) {
          return 'Vui lòng nhập giá trị Ghi Rõ';
        }
      }
      return null;
    }
    if (fieldName == columnPhieuTonGiaoA4_1_10GhiRo) {
      num a4_1_10 = tblPhieuTG[columnPhieuTonGiaoA4_1_10] ?? 0;
      var a4_1_10GhiRo = tblPhieuTG[columnPhieuTonGiaoA4_1_10GhiRo];
      if (a4_1_10 > 0) {
        if (validateEmptyString(a4_1_10GhiRo.toString())) {
          return 'Vui lòng nhập giá trị Ghi Rõ';
        }
      }
      return null;
    }
    if (validateEmptyString(inputValue)) {
      return 'Vui lòng nhập giá trị.';
    }
    inputValue = inputValue!.replaceAll(' ', '');
    num intputVal =
        inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
    if (intputVal < minVal) {
      return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
    } else if (intputVal > maxVal) {
      return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
    }

    num a4_1_01 = tblPhieuTG[columnPhieuTonGiaoA4_1_01] ?? 0;
    num a4_1_02 = tblPhieuTG[columnPhieuTonGiaoA4_1_02] ?? 0;
    num a4_1_03 = tblPhieuTG[columnPhieuTonGiaoA4_1_03] ?? 0;
    num a4_1_04 = tblPhieuTG[columnPhieuTonGiaoA4_1_04] ?? 0;
    num a4_1_05 = tblPhieuTG[columnPhieuTonGiaoA4_1_05] ?? 0;
    num a4_1_06 = tblPhieuTG[columnPhieuTonGiaoA4_1_06] ?? 0;
    num a4_1_07 = tblPhieuTG[columnPhieuTonGiaoA4_1_07] ?? 0;
    num a4_1_07_1 = tblPhieuTG[columnPhieuTonGiaoA4_1_07_1] ?? 0;
    num a4_1_08 = tblPhieuTG[columnPhieuTonGiaoA4_1_08] ?? 0;
    num a4_1_08_1 = tblPhieuTG[columnPhieuTonGiaoA4_1_08_1] ?? 0;
    num a4_1_09 = tblPhieuTG[columnPhieuTonGiaoA4_1_09] ?? 0;
    num a4_1_10 = tblPhieuTG[columnPhieuTonGiaoA4_1_10] ?? 0;

    if (fieldName == columnPhieuTonGiaoA4_1_01) {
      num a4_1_01Tmp = a4_1_02 + a4_1_08 + a4_1_09 + a4_1_10;
      num a4_1_01Tmp2 = AppUtils.convertStringAndFixedToDouble(a4_1_01Tmp);
      if (a4_1_01Tmp2 != intputVal) {
        return 'Giá trị mã số 01 ($intputVal) phải bằng 02 ($a4_1_02) + 08 ($a4_1_08)+ 09 ($a4_1_09) + 10 ($a4_1_10) = $a4_1_01Tmp2';
      }
    } else if (fieldName == columnPhieuTonGiaoA4_1_02) {
      num a4_1_02Tmp =
          a4_1_03 + a4_1_04 + a4_1_05 + a4_1_06 + a4_1_07 + a4_1_07_1;
      num a4_1_02Tmp2 = AppUtils.convertStringAndFixedToDouble(a4_1_02Tmp);
      if (a4_1_02Tmp2 != intputVal) {
        return 'Giá trị mã số 02 ($intputVal) phải bằng03 ($a4_1_03) + 04 ($a4_1_04) + 05 ($a4_1_05) + 06 ($a4_1_06) + 07 ($a4_1_07) + 07.1 ($a4_1_07_1) = $a4_1_02Tmp2';
      }
    } else if (fieldName == columnPhieuTonGiaoA4_1_03) {
      if (intputVal > a4_1_02) {
        return 'Mã số 03 - Khoản chi phí điện nước chất đốt ($intputVal) > Mã số 02 - Chi hoạt động quản lý, vận hành ($a4_1_02)';
      }
    } else if (fieldName == columnPhieuTonGiaoA4_1_04) {
      if (intputVal > a4_1_02) {
        return 'Mã số 04 - Khoản Chi mua đồ lễ, tổ chức hành lễ (nến, hương, hoa…) ($intputVal) > Mã số 02 - Chi hoạt động quản lý, vận hành ($a4_1_02)';
      }
    } else if (fieldName == columnPhieuTonGiaoA4_1_05) {
      if (intputVal > a4_1_02) {
        return 'Mã số 05 - Khoản Chi Các khoản thù lao và các khoản có tính chất như lương ($intputVal) > Mã số 02 - Chi hoạt động quản lý, vận hành ($a4_1_02)';
      }
    } else if (fieldName == columnPhieuTonGiaoA4_1_06) {
      if (intputVal > a4_1_02) {
        return 'Mã số 06 - Khoản Chi phí khác cho sinh hoạt hàng ngày ($intputVal) > Mã số 02 - Chi hoạt động quản lý, vận hành ($a4_1_02)';
      }
    } else if (fieldName == columnPhieuTonGiaoA4_1_07) {
      if (intputVal > a4_1_02) {
        return 'Mã số 07 - Khoản Chi sửa chữa nhỏ, duy tu bảo dưỡng ($intputVal) > Mã số 02 - Chi hoạt động quản lý, vận hành ($a4_1_02)';
      }
    } else if (fieldName == columnPhieuTonGiaoA4_1_07_1) {
      if (intputVal > a4_1_02) {
        return 'Mã số 07.1 Khoản Chi khác ($intputVal) > Mã số 02 - Chi hoạt động quản lý, vận hành ($a4_1_02)';
      }
    } else if (fieldName == columnPhieuTonGiaoA4_1_08) {
      if (intputVal > a4_1_01) {
        return 'Mã số 08 ($intputVal) > Mã số 01 - Tổng chi ($a4_1_01)';
      }
      if (a4_1_08_1 > intputVal) {
        return 'Mã số 08 ($intputVal) phải lớn hơn Mã số 08.1 ($a4_1_08_1)';
      }
    } else if (fieldName == columnPhieuTonGiaoA4_1_08_1) {
      if (intputVal > a4_1_08) {
        return 'Mã số 08.1 ($intputVal) phải nhỏ hơn Mã số 08 ($a4_1_08)';
      }
    } else if (fieldName == columnPhieuTonGiaoA4_1_09) {
      if (intputVal > a4_1_01) {
        return 'Mã số 09 ($intputVal) > Mã số 01 - Tổng chi ($a4_1_01)';
      }
    } else if (fieldName == columnPhieuTonGiaoA4_1_10) {
      if (intputVal > a4_1_01) {
        return 'Mã số 10 ($intputVal) > Mã số 01 - Tổng chi ($a4_1_01)';
      }
    } else if (fieldName == columnPhieuTonGiaoA4_1_07_1GhiRo) {
      if (a4_1_07_1 > 0) {
        if (validateEmptyString(inputValue)) {
          return 'Vui lòng nhập giá trị ghi rõ của mã số 07.1.';
        }
      }
    } else if (fieldName == columnPhieuTonGiaoA4_1_10GhiRo) {
      if (a4_1_10 > 0) {
        if (validateEmptyString(inputValue)) {
          return 'Vui lòng nhập giá trị ghi rõ của mã số 10.';
        }
      }
    }

    num a4_1_02Tmp =
        a4_1_03 + a4_1_04 + a4_1_05 + a4_1_06 + a4_1_07 + a4_1_07_1;
    num a4_1_02Tmp2 = AppUtils.convertStringAndFixedToDouble(a4_1_02Tmp);
    num a4_1_01Tmp = a4_1_02 + a4_1_08 + a4_1_09 + a4_1_10;
    num a4_1_01Tmp2 = AppUtils.convertStringAndFixedToDouble(a4_1_01Tmp);
    if (a4_1_02Tmp2 == a4_1_02 && a4_1_01Tmp2 == a4_1_01) {
      return null;
    }
  }

  ///END::::Chi tieu dong cot
  /*********/
  ///
  ///BEGIN::::Get value by field name
  // getValueByFieldName(String table, String fieldName, {String? valueDataType}) {
  //   if (fieldName == null || fieldName == '') return null;
  //   if (table == tablePhieuTonGiao) {
  //     var tbl = tblPhieuTonGiao.value.toJson();
  //     var res = tbl[fieldName];
  //     if (valueDataType == "double") {
  //       AppUtils.convertStringToDouble(res.toString());
  //     }
  //     return res;
  //   } else {
  //     return null;
  //   }
  // }

  getValueByFieldName(String table, String fieldName, {String? valueDataType}) {
    if (fieldName == null || fieldName == '') return null;
    if (table == tablePhieuTonGiao) {
      var res = answerTblTonGiao[fieldName];
      if (valueDataType == "double") {
        AppUtils.convertStringToDouble(res.toString());
      }
      return res;
    } else {
      return null;
    }
  }

  // getValueByFieldNameStt(String table, String fieldName, int stt) {
  //   if (table == tablePhieuTonGiaoA43) {
  //     for (var item in tblPhieuTonGiaoA43) {
  //       var tbl = item.toJson();
  //       return tbl[fieldName];
  //     }
  //   } else {
  //     return '';
  //   }
  // }

  getValueByFieldNameId(String table, String fieldName, int idValue) {
    if (table == tablePhieuTonGiaoA43) {
      for (var item in tblPhieuTonGiaoA43) {
        if (item.id == idValue) {
          var tbl = item.toJson();
          return tbl[fieldName];
        }
      }
    } else {
      return '';
    }
  }

  isDuplicateVCPAA4_3(String value) {
    List<String> res = [];
    for (var item in tblPhieuTonGiaoA43) {
      if (item.a4_3_2 == value) {
        res.add(value);
      }
    }
    if (res.isNotEmpty && res.length >= 2) {
      return true;
    }
    return false;
  }

  getDoubleValue(val, String? valDataType) {
    if (valDataType == "double") {
      if (val == null || val == "") {
        return val;
      }
      return double.parse(val.toString().replaceAll(",", "."));
    }
    return val;
  }

  ///END::Get value by field name
  /*****/
  /*****/

  ///END::Logic
  /********/
  ///BEGIN::Validation
  String? onValidate(String table, String maCauHoi, String? fieldName,
      String? inputValue, minValue, maxValue, int loaiCauHoi, bool typing) {
    if (maCauHoi == "A1_1") {
      if (validateEmptyString(inputValue)) {
        return null;
      }
      if (inputValue!.length < 3) {
        return 'Tên cơ sở quá ngắn';
      }
    } else if (maCauHoi == "A1_2") {
      if (validateEmptyString(inputValue)) {
        return null;
      }
      if (inputValue!.length < 3) {
        return 'Địa chỉ cơ sở quá ngắn.';
      }
    }
    if (maCauHoi == "A1_3") {
      if (validateEmptyString(inputValue)) {
        return null;
      }
      var validRes = Valid.validateMobile(inputValue);
      if (validRes != null && validRes != '') {
        return validRes;
      }
    } else if (maCauHoi == "A1_4") {
      if (validateEmptyString(inputValue)) {
        return null;
      }
      //email
      var emailValidate = Valid.validateEmail(inputValue);
      if (emailValidate != null && emailValidate != '') {
        return emailValidate;
      }
    }
    if (maCauHoi == "A1_5_1") {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập Họ tên người đứng đầu cơ sở.';
      }
      if (inputValue!.length < 3) {
        return 'Họ và tên chủ cơ sở quá ngắn';
      }
    }
    if (maCauHoi == "A1_5_2") {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập Phẩm sắc tôn giáo.';
      }
      if (inputValue!.length < 3) {
        return 'Phẩm sắc tôn giáo người đứng đầu cơ sở mô tả quá ngắn.';
      }
    }
    if (maCauHoi == "A1_5_3") {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng chọn Giới tính.';
      }
    }
    if (maCauHoi == "A1_5_4") {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập Năm sinh.';
      }
      var nSinh = inputValue!.replaceAll(' ', '');
      //nam sinh
      if (nSinh.length != 4) {
        return 'Vui lòng nhập năm sinh 4 chũ số';
      }
      int namSinh = AppUtils.convertStringToInt(nSinh);
      int currY = DateTime.now().year;
      if (namSinh < 1905 || namSinh > currY) {
        return "Năm sinh phải >= 1905 và <= $currY";
      }
    }
    if (maCauHoi == "A1_5_5") {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng nhập Dân tộc.';
      }
    }
    if (maCauHoi == "A1_5_6" && fieldName == "A1_5_6") {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng chọn Trình độ chuyên môn.';
      }
    }
    if (maCauHoi == "A1_5_6" && fieldName == "A1_5_6_GhiRo") {
      if (typing == false) {
        var tblPhieuTG = tblPhieuTonGiao.value.toJson();
        var a1_5_6Value = tblPhieuTG[columnPhieuTonGiaoA1_5_6];

        if (a1_5_6Value != null) {
          var a1_5_6Val = AppUtils.convertStringToInt(a1_5_6Value);
          if (a1_5_6Val == 11) {
            if (validateEmptyString(inputValue)) {
              return 'Vui lòng nhập giá trị Ghi Rõ';
            }
          }
          return null;
        }
      }
    }

    if (maCauHoi == "A1_6" && fieldName == "A1_6_GhiRo") {
      if (typing == false) {
        var tblPhieuTG = tblPhieuTonGiao.value.toJson();
        var a1_6_6Value = tblPhieuTG[columnPhieuTonGiaoA1_6];

        if (a1_6_6Value != null) {
          var a1_6Val = AppUtils.convertStringToInt(a1_6_6Value);
          if (a1_6Val == 17) {
            if (validateEmptyString(inputValue)) {
              return 'Vui lòng nhập giá trị Ghi Rõ';
            }
          }
          return null;
        }
      }
    }
    if (maCauHoi == "A1_7") {
      if (typing == false) {
        var tblPhieuTG = tblPhieuTonGiao.value.toJson();
        var a1_6Value = tblPhieuTG[columnPhieuTonGiaoA1_6];
        if (a1_6Value.toString() == "12" ||
            a1_6Value.toString() == "13" ||
            a1_6Value.toString() == "14" ||
            a1_6Value.toString() == "15" ||
            a1_6Value.toString() == "16") {
          return null;
        }
        if (a1_6Value.toString() == "17") {
          var a1_6GhiRoValue = tblPhieuTG[columnPhieuTonGiaoA1_6GhiRo];
          if (a1_6GhiRoValue == 1) {
            return null;
          }
        }
      }

      if (fieldName == "A1_7_GhiRo") {
        if (typing == false) {
          var tblPhieuTG = tblPhieuTonGiao.value.toJson();
          var a1_7Value = tblPhieuTG[columnPhieuTonGiaoA1_7];

          if (a1_7Value != null) {
            var a1_7Val = AppUtils.convertStringToInt(a1_7Value);
            if (a1_7Val == 17) {
              if (validateEmptyString(inputValue)) {
                return 'Vui lòng nhập giá trị Ghi Rõ';
              }
            }
            return null;
          }
        }
      } else {
        if (validateEmptyString(inputValue)) {
          // return 'Vui lòng chọn Trình độ chuyên môn.';
        }
      }
    }
    if (maCauHoi == "A1_8") {
      if (fieldName == "A1_8_2") {
        if (typing == false) {
          var tblPhieuTG = tblPhieuTonGiao.value.toJson();
          var a1_8_1Value = tblPhieuTG[columnPhieuTonGiaoA1_8_1];

          if (a1_8_1Value != null) {
            var a1_8_1Val = AppUtils.convertStringToInt(a1_8_1Value);
            if (a1_8_1Val == 2) {
              if (validateEmptyString(inputValue)) {
                return 'Vui lòng chọn Xếp hạng di tích';
              }
            }
            return null;
          }
        }
      }
    }
    if (maCauHoi == "A1_9") {
      if (typing == false) {
        var tblPhieuTG = tblPhieuTonGiao.value.toJson();
        var a1_8_1Value = tblPhieuTG[columnPhieuTonGiaoA1_8_1];

        if (a1_8_1Value != null) {
          var a1_8_1Val = AppUtils.convertStringToInt(a1_8_1Value);
          if (a1_8_1Val == 2) {
            if (validateEmptyString(inputValue)) {
              return 'Vui lòng chọn giá trị';
            }
          }
          return null;
        }
      }
    }
    if (maCauHoi == columnPhieuTonGiaoA2_1 ||
        maCauHoi == columnPhieuTonGiaoA2_1_1) {
      String? validResA2_1 = validateA2_1(table, maCauHoi, fieldName,
          inputValue, minValue, maxValue, loaiCauHoi, typing);
      if (validResA2_1 != null && validResA2_1 != '') {
        return validResA2_1;
      }
    }
    if (maCauHoi == columnPhieuTonGiaoA3_1 ||
        maCauHoi == columnPhieuTonGiaoA3_2 ||
        maCauHoi == columnPhieuTonGiaoA3_2_1) {
      String? validRes = validateA3(table, maCauHoi, fieldName, inputValue,
          minValue, maxValue, loaiCauHoi, typing);
      if (validRes != null && validRes != '') {
        return validRes;
      }
    }
    if (maCauHoi == "A4_1" && fieldName == "A4_1_07_1_GhiRo") {
      if (typing == false) {
        var tblPhieuTG = tblPhieuTonGiao.value.toJson();
        num a4_1_07 = tblPhieuTG[columnPhieuTonGiaoA4_1_07] != null
            ? AppUtils.convertStringToDouble(
                tblPhieuTG[columnPhieuTonGiaoA4_1_07])
            : 0;
        var a4_1_07GhiRoValue = tblPhieuTG[columnPhieuTonGiaoA4_1_07_1GhiRo];
        if (a4_1_07 > 0) {
          if (validateEmptyString(a4_1_07GhiRoValue.toString())) {
            return 'Vui lòng nhập giá trị Ghi Rõ';
          }
        }
        return null;
      }
    }
    if (fieldName == columnPhieuTonGiaoA5_2) {
      if (typing) {
        // var a5_1Value = answerTblTonGiao[columnPhieuTonGiaoA5_1];
        //  if (a5_1Value != 1) {
        //   return null;
        // }
      } else {
        var tblPhieuTG = tblPhieuTonGiao.value.toJson();
        var a5_1Value = tblPhieuTG[columnPhieuTonGiaoA5_1];
        if (a5_1Value != 1) {
          return null;
        } else {}
      }
    } else if (fieldName == columnPhieuTonGiaoA5_2GhiRo) {
      if (typing) {
        if (validateEmptyString(inputValue)) {
          return 'Vui lòng nhập địa chỉ truy cập. Ví dụ: hoptac.vn,...';
        }
        // var validRes = Valid.hasValidUrl(valueInput);
        // if (validRes != null) {
        //   return validRes;
        // }
      } else {
        var tblPhieuTG = tblPhieuTonGiao.value.toJson();
        var a5_2Value = tblPhieuTG[columnPhieuTonGiaoA5_2];
        if (a5_2Value.toString() == '1') {
          if (validateEmptyString(inputValue)) {
            return 'Vui lòng nhập địa chỉ truy cập.';
          }
          // var validRes = Valid.hasValidUrl(valueInput);
          // if (validRes != null) {
          //   return validRes;
          // }
          var tblPhieuTG = tblPhieuTonGiao.value.toJson();
          var a5_2_GhiRoValue = tblPhieuTG[columnPhieuTonGiaoA5_2GhiRo];
          if (a5_2_GhiRoValue == null ||
              a5_2_GhiRoValue == "" ||
              a5_2_GhiRoValue == "null") {
            return 'Vui lòng nhập địa chỉ truy cập.';
          }
        }
      }

      return null;
    } else if (fieldName == columnPhieuTonGiaoA7_2 ||
        fieldName == columnPhieuTonGiaoA7_2_1 ||
        fieldName == columnPhieuTonGiaoA7_2_2) {
      if (typing) {
      } else {
        var tblPhieuTG = tblPhieuTonGiao.value.toJson();
        var a7_1Value = tblPhieuTG[columnPhieuTonGiaoA7_1];
        var a7_2Value = tblPhieuTG[columnPhieuTonGiaoA7_2];
        if (a7_1Value == 2) {
          return null;
        } else {
          if (fieldName == columnPhieuTonGiaoA7_2) {
            if (validateEmptyString(inputValue)) {
              return 'Vui lòng chọn giá trị.';
            }
          } else if (fieldName == columnPhieuTonGiaoA7_2_1) {
            if (a7_2Value != null &&
                a7_2Value != '' &&
                a7_2Value.toString().contains('1')) {
              if (validateEmptyString(inputValue)) {
                return 'Vui lòng nhập giá trị.';
              }
            }
          } else if (fieldName == columnPhieuTonGiaoA7_2_2) {
            if (a7_2Value != null &&
                a7_2Value != '' &&
                a7_2Value.toString().contains('2')) {
              if (validateEmptyString(inputValue)) {
                return 'Vui lòng nhập giá trị.';
              }
            }
          }
        }
      }
      return null;
    }
    if (validateEmptyString(inputValue)) {
      if (loaiCauHoi == AppDefine.loaiCauHoi_1 ||
          loaiCauHoi == AppDefine.loaiCauHoi_5) {
        return 'Vui lòng chọn giá trị.';
      }
      return 'Vui lòng nhập giá trị.';
    }
    return ValidateQuestionNo08.onValidate(
        table, maCauHoi, fieldName, inputValue, minValue, maxValue, loaiCauHoi);
  }

//!Chú ý trong đó Nữ phải 0-maxVal chứ không phải từ 1
  validateA2_1(String table, String maCauHoi, String? fieldName,
      String? inputValue, minValue, maxValue, int loaiCauHoi, bool typing) {
    num minVal = minValue ?? 1;
    num maxVal = maxValue ?? 99999;
    if (validateEmptyString(inputValue)) {
      return 'Vui lòng nhập giá trị.';
    }
    inputValue = inputValue!.replaceAll(' ', '');
    num intputVal =
        inputValue != null ? AppUtils.convertStringToInt(inputValue) : 0;
    if (intputVal < minVal) {
      return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
    } else if (intputVal > maxVal) {
      return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
    }
    //Kiểm tra câu A2.1 và A2.1.1
    if (maCauHoi == columnPhieuTonGiaoA2_1) {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng chọn giá trị.';
      }
      var a2_1Value = AppUtils.convertStringToInt(inputValue);
      if (typing) {
        var a2_1_1Value = answerTblTonGiao[columnPhieuTonGiaoA2_1_1];

        if (a2_1_1Value != null) {
          if (a2_1_1Value > a2_1Value) {
            return 'A2.1 phải lớn hơn Trong đó: Nữ';
          }
        }
      } else {
        var tblPhieuTG = tblPhieuTonGiao.value.toJson();
        var a2_1_1Value = tblPhieuTG[columnPhieuTonGiaoA2_1_1];
        if (a2_1_1Value != null) {
          var a2_1_1Val = AppUtils.convertStringToInt(a2_1_1Value);
          if (a2_1_1Val > a2_1Value) {
            return 'A2.1 phải lớn hơn Trong đó: Nữ';
          }
        }
      }
    } else if (maCauHoi == columnPhieuTonGiaoA2_1_1) {
      if (validateEmptyString(inputValue)) {
        return 'Vui lòng chọn giá trị.';
      }
      if (typing) {
        var a2_1Value = answerTblTonGiao[columnPhieuTonGiaoA2_1];
        var a2_1_1Value = AppUtils.convertStringToInt(inputValue);
        var aGioiTinhValue = answerTblTonGiao[columnPhieuTonGiaoA1_5_3];

        if (a2_1Value != null) {
          var a2_1Val = AppUtils.convertStringToInt(a2_1Value);
          if (a2_1Val < a2_1_1Value) {
            return 'Trong đó: Nữ phải nhỏ hơn A2.1';
          }
        }
        if (aGioiTinhValue == 1 && a2_1Value == 1 && a2_1_1Value > 0) {
          return 'Cơ sở có lao động là nam (là người đứng đầu cơ sở) nhưng A2.1 Nữ >0';
        }
        if (aGioiTinhValue == 1 && a2_1Value > 1 && a2_1_1Value >= a2_1Value) {
          return 'Cơ sở có lao động là nam (là người đứng đầu cơ sở) nhưng A2.1 Nữ > Tổng số ($a2_1Value)';
        }
        if (aGioiTinhValue == 2 && a2_1Value == 1 && a2_1_1Value == 0) {
          return 'Cơ sở có 1 lao động là nữ (là người đứng đầu cơ sở) nhưng A2.1 Nữ =0';
        }

        if (aGioiTinhValue == 2 && a2_1Value > 1 && a2_1_1Value == 0) {
          return 'Cơ sở có 1 lao động là nữ (là người đứng đầu cơ sở) nhưng A2.1 Nữ =0';
        }
      } else {
        var tblPhieuTG = tblPhieuTonGiao.value.toJson();
        var a2_1Value = tblPhieuTG[columnPhieuTonGiaoA2_1];
        if (a2_1Value != null) {
          var a2_1Val = AppUtils.convertStringToInt(a2_1Value);
          var a2_1_1Value = AppUtils.convertStringToInt(inputValue);
          if (a2_1Val < a2_1_1Value) {
            return 'Trong đó: Nữ phải nhỏ hơn A2.1';
          }
        }
      }

      return null;
    }
    return null;
  }

  String? validateA3(String table, String maCauHoi, String? fieldName,
      String? inputValue, minValue, maxValue, int loaiCauHoi, bool typing) {
    num minVal = 1;
    num maxVal = 999999999;
    minVal = minValue ?? 1;
    maxVal = maxValue ?? 999999999;
    if (validateEmptyString(inputValue)) {
      return 'Vui lòng nhập giá trị.';
    }
    inputValue = inputValue!.replaceAll(' ', '');
    num intputVal =
        inputValue != null ? AppUtils.convertStringToDouble(inputValue) : 0;
    if (intputVal < minVal) {
      return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
    } else if (intputVal > maxVal) {
      return 'Giá trị phải nằm trong khoảng ${AppUtils.getTextKhoangGiaTri(minVal, maxVal)}';
    }
    //if (typing == false) {
    var tblPhieuTG;
    // tblPhieuTonGiao.value.toJson();
    if (typing == false) {
      tblPhieuTG = tblPhieuTonGiao.value.toJson();
    } else {
      tblPhieuTG = answerTblTonGiao;
    }
    int a2_2_01TongSoTrongDo = 0;
    int a2_2_01Value = 0;
    double a3_2Value = tblPhieuTG[columnPhieuTonGiaoA3_2] != null
        ? AppUtils.convertStringToDouble(
            tblPhieuTG[columnPhieuTonGiaoA3_2].toString())
        : 0;
    double a3_2_1Value = tblPhieuTG[columnPhieuTonGiaoA3_2_1] != null
        ? AppUtils.convertStringToDouble(
            tblPhieuTG[columnPhieuTonGiaoA3_2_1].toString())
        : 0;
    if (maCauHoi == columnPhieuTonGiaoA3_2) {
      if (a3_2Value < a3_2_1Value) {
        return 'Diện tích xây dựng của cơ sở < Diện tích đất khu nhà chính.';
      }
    } else if (maCauHoi == columnPhieuTonGiaoA3_2_1) {
      if (a3_2_1Value > a3_2Value) {
        return 'Diện tích đất khu nhà chính > diện tích đất xây dựng cơ sở (chi tiết >tổng số).';
      }
    }
    return '';
  }

  validateA4_3(
      String table,
      String maCauHoi,
      String? fieldName,
      String? valueInput,
      minValue,
      maxValue,
      int loaiCauHoi,
      bool typing) async {
    if (typing == false) {
      var tblPhieuTG = tblPhieuTonGiao.value.toJson();
      var a4_2Value = tblPhieuTG[columnPhieuTonGiaoA4_2];
      if (a4_2Value.toString() == '1') {
        var map = await phieuTonGiaoA43Provider.selectByIdCoso(currentIdCoSo!);
        if (map.isEmpty) {
          return 'Vui lòng chọn giá trị.';
        }
      }
    }
    return null;
  }

  validateA1_5_6(QuestionCommonModel question, String table, String? maCauHoi,
      String? fieldName, value, dmItem) {
    if (maCauHoi == columnPhieuTonGiaoA1_5_6) {
      if (a1_5_6MaTDCM.contains(value)) {
        //Ho ten nguoi dung dau
        var a1_5_1Value = answerTblTonGiao[columnPhieuTonGiaoA1_5_1];
        //Nam sinh
        var a1_5_4Value = answerTblTonGiao[columnPhieuTonGiaoA1_5_4];
        if (a1_5_4Value != null) {
          if (value == 6) {
            if (a1_5_4Value == 2007) {
              updateAnswerToDB(table, columnPhieuTonGiaoA1_5_6, null);
              updateAnswerTblTonGiao(columnPhieuTonGiaoA1_5_6, null);
              return showError(
                  '$a1_5_1Value Dưới 18 tuổi mà đã tốt nghiệp cao đẳng');
            }
          }
          if (value == 7) {
            if (a1_5_4Value == 2005) {
              updateAnswerToDB(table, columnPhieuTonGiaoA1_5_6, null);
              updateAnswerTblTonGiao(columnPhieuTonGiaoA1_5_6, null);
              return showError(
                  '$a1_5_1Value Dưới 20 tuổi mà đã tốt nghiệp đại học');
            }
          }
          if (value == 8) {
            if (a1_5_4Value == 2004) {
              updateAnswerToDB(table, columnPhieuTonGiaoA1_5_6, null);
              updateAnswerTblTonGiao(columnPhieuTonGiaoA1_5_6, null);
              return showError(
                  '$a1_5_1Value Dưới 21 tuổi mà đã tốt nghiệp thạc sỹ');
            }
          }
          if (value == 9 || value == 10) {
            if (a1_5_4Value == 2003) {
              updateAnswerToDB(table, columnPhieuTonGiaoA1_5_6, null);
              updateAnswerTblTonGiao(columnPhieuTonGiaoA1_5_6, null);
              return showError(
                  '$a1_5_1Value Dưới 22 tuổi mà đã tốt nghiệp tiến sỹ');
            }
          }
        }
      }
    }
  }

  ///VALIDATE KHI NHẤN NÚT Tiếp tục V2
  Future<String> validateAllFormV2() async {
    String result = '';
// ? Tỷ lệ gia công Câu 11 thêm giá trị lớn nhất nhỏ nhất vì nó tính %
    var fieldNames = await getListFieldToValidate();
    var tblP08 = tblPhieuTonGiao.value.toJson();

    for (var item in fieldNames) {
      if (currentScreenNo.value == item.manHinh) {
        if (item.tenTruong != null && item.tenTruong != '') {
          if (item.bangDuLieu == tablePhieuTonGiao) {
            if (tblP08.isNotEmpty) {
              if (tblP08.containsKey(item.tenTruong)) {
                var val = tblP08[item.tenTruong];
                if (item.maCauHoi == "A2_2" ||
                    item.maCauHoi == "A4_1" ||
                    item.maCauHoi == "A5_3" ||
                    item.maCauHoi == "A6_2" ||
                    item.maCauHoi == "A6_1") {
                  var validRes = onValidateInputChiTieuDongCot(
                      item.question!,
                      item.chiTieuCot,
                      item.chiTieuDong,
                      item.tenTruong!,
                      val.toString(),
                      false);
                  if (validRes != null && validRes != '') {
                    result = await generateMessageV2(item.mucCauHoi, validRes);
                    break;
                  }
                } else if (item.tenTruong == columnPhieuTonGiaoA1_5_5) {
                  var validRes = onValidateInputDanToc(
                      item.bangDuLieu!,
                      item.maCauHoi!,
                      item.maCauHoi,
                      val.toString(),
                      item.loaiCauHoi!);
                  if (validRes != null && validRes != '') {
                    result = await generateMessageV2(item.mucCauHoi, validRes);
                    break;
                  }
                } else {
                  var validRes = onValidate(
                      item.bangDuLieu!,
                      item.maCauHoi!,
                      item.tenTruong,
                      val.toString(),
                      item.giaTriNN,
                      item.giaTriLN,
                      item.loaiCauHoi!,
                      false);
                  if (validRes != null && validRes != '') {
                    result = await generateMessageV2(item.mucCauHoi, validRes);
                    break;
                  }
                }
              }
            } else {
              /// todo thì làm chi đây  ???
              /// Không có trường hợp này: Vì đã insert 1 record trước khi vào bảng hỏi
            }
          }
        }
      }
    }

    var fieldNamesTableA43 =
        fieldNames.where((c) => c.bangDuLieu == tablePhieuTonGiaoA43).toList();
    if (fieldNamesTableA43.isNotEmpty) {
      if (tblPhieuTonGiaoA43.isNotEmpty) {
        var isReturn = false;
        for (var itemC8 in tblPhieuTonGiaoA43.value) {
          var tblC8 = itemC8.toJson();
          for (var fieldC8 in fieldNamesTableA43) {
            if (tblC8.containsKey(fieldC8.tenTruong)) {
              var val = tblC8[fieldC8.tenTruong];
              var validRes = onValidateInputA43(
                  fieldC8.bangDuLieu!,
                  fieldC8.maCauHoi!,
                  fieldC8.tenTruong,
                  tblC8[columnId],
                  val.toString(),
                  0,
                  0,
                  fieldC8.giaTriNN,
                  fieldC8.giaTriLN,
                  fieldC8.loaiCauHoi!,
                  false);
              if (validRes != null && validRes != '') {
                result = await generateMessageV2(
                    '${fieldC8.mucCauHoi}: STT=${tblC8[columnSTT]}', validRes);
                isReturn = true;
                break;
              }
            }
            if (isReturn) return result;
          }
        }
        //Kiểm tra thêm mã ngành
        for (var itemC8 in tblPhieuTonGiaoA43.value) {
          var tblC8 = itemC8.toJson();
          for (var fieldC8 in fieldNamesTableA43) {
            if (tblC8.containsKey(fieldC8.tenTruong)) {
              if (fieldC8.tenTruong == columnPhieuTonGiaoA43A4_3_2) {
                var val = tblC8[fieldC8.tenTruong];
                // var hasVcpa = await dmNhomNganhVcpaProvider.hasMaVcpa(val);
                var hasVcpa = await dmMotaSanphamProvider.hasMaVcpa(val);
                if (hasVcpa == false) {
                  result = await generateMessageV2(
                      '${fieldC8.mucCauHoi}: STT=${tblC8[columnSTT]}',
                      'Mã VCPA $val không có trong danh mục.');
                  isReturn = true;
                  break;
                }
              }
            }
            if (isReturn) return result;
          }
        }
      } else {
        var a4_2 = answerTblTonGiao[columnPhieuTonGiaoA4_2];
        if (a4_2.toString() == '1') {
          result = await generateMessageV2('A4_3', 'Vui lòng nhập giá trị.');
          return result;
        }
      }
    }

    ///A5_3
    //   var fieldNamesTableA53 = fieldNames
    //       .where((c) => c.maCauHoi == "A5_3" && c.tenTruong != 'A5_3')
    //       .toList();
    //   if (fieldNamesTableA53.isNotEmpty) {
    //     if (tblP08.isNotEmpty) {
    //       for (var item in fieldNamesTableA53) {
    //         if (tblP08.containsKey(item.tenTruong)) {
    //           var val = tblP08[item.tenTruong];
    //           if (item.maCauHoi == "A5_3") {
    //             var validRes = onValidateInputChiTieuDongCot(
    //                 item.question!,
    //                 item.chiTieuCot,
    //                 item.chiTieuDong,
    //                 item.tenTruong!,
    //                 val.toString());
    //             if (validRes != null && validRes != '') {
    //               result = await generateMessageV2(item.mucCauHoi, validRes);
    //               break;
    //             }
    //           }
    //         }
    //       }
    //     }
    //   }
    return result;
  }

  Future<String> generateMessageV2(
      String? mucCauHoi, String? validResultMessage,
      {int? loaiCauHoi, String? maCauHoi}) async {
    String result = '';
    if (maCauHoi == 'E') {
      return 'Vui lòng kiểm tra lại phần E:\r\n${validResultMessage!}';
    }
    result = '$mucCauHoi: Vui lòng nhập giá trị.';
    if (loaiCauHoi == AppDefine.loaiCauHoi_1) {
      result = '$mucCauHoi: Vui lòng chọn giá trị.';
    }
    if (validResultMessage != null && validResultMessage != '') {
      result = '$mucCauHoi: \r\n$validResultMessage';
    }
    return result;
  }

  /// ? loaiSoSanh='empty': Empty; ==: So sánh bằng: ==; So sánh lớn hơn: >,....
  ///  minValue; maxValue
  ///
  Future<String> generateMessage(
      int loaiCauHoi, String tenNganCauHoi, String? mucCauHoi,
      {String? loaiSoSanh, minValue, maxValue, giaTriSoSanh}) async {
    String result = '';

    if (loaiSoSanh == "empty") {
      result = '$mucCauHoi: Vui lòng nhập giá trị.';
    }
    if (loaiSoSanh == "yesno") {
      result = '$mucCauHoi: Vui lòng chọn giá trị.';
    } else if (loaiSoSanh == "==") {
      result = '$mucCauHoi: Vui lòng kiểm tra lại giá trị.';
    } else if (loaiSoSanh == ">") {
      result = '$mucCauHoi: Vui lòng kiểm tra lại giá trị.';
    } else if (loaiSoSanh == "<") {
      result = '$mucCauHoi: Vui lòng kiểm tra lại giá trị.';
    }
    if (loaiCauHoi == AppDefine.loaiCauHoi_1) {
    } else if (loaiCauHoi == AppDefine.loaiCauHoi_2) {
    } else if (loaiCauHoi == AppDefine.loaiCauHoi_3) {
    } else if (loaiCauHoi == AppDefine.loaiCauHoi_4) {}
    return result;
  }

  ///

  ///END::Validation
  ///
  ///BEGIN::Tạo danh sách gồm các trường: ManHinh,MaCauHoi,TenTruong,...
  ///Mục đích: Dùng để lấy trường cho việc validate ở mỗi màn hình khi nhấn nút tiếp tục
  ///Danh sách trường này có thể chuyển qua lấy ở server ở chức năng lấy dữ liệu phỏng vấn.
  Future<List<QuestionFieldModel>> getListFieldToValidate() async {
    List<QuestionFieldModel> result = [];
    if (questions.isNotEmpty) {
      for (var item in questions) {
        QuestionFieldModel questionField = QuestionFieldModel(
            manHinh: item.manHinh,
            maCauHoi: item.maCauHoi,
            tenNganCauHoi: 'Câu ${item.maSo}',
            tenTruong: item.maCauHoi,
            loaiCauHoi: item.loaiCauHoi,
            giaTriLN: item.giaTriLN,
            giaTriNN: item.giaTriNN,
            bangChiTieu: item.bangChiTieu,
            bangDuLieu: item.bangDuLieu,
            question: item);
        result.add(questionField);
        //Trinh do chuyen mon
        if (item.maCauHoi == columnPhieuTonGiaoA5_2 ||
            item.maCauHoi == columnPhieuTonGiaoA1_5_6 ||
            item.maCauHoi == columnPhieuTonGiaoA1_6 ||
            item.maCauHoi == columnPhieuTonGiaoA1_7) {
          QuestionFieldModel qField = QuestionFieldModel(
              manHinh: item.manHinh,
              maCauHoi: item.maCauHoi,
              tenNganCauHoi: 'Câu ${item.maSo}',
              mucCauHoi: 'Câu ${item.maSo}',
              tenTruong: '${item.maCauHoi}_GhiRo',
              loaiCauHoi: item.loaiCauHoi,
              giaTriLN: item.giaTriLN,
              giaTriNN: item.giaTriNN,
              bangChiTieu: item.bangChiTieu,
              bangDuLieu: item.bangDuLieu,
              question: item);
          result.add(qField);
        }

        if (item.bangChiTieu == '1') {
          if (item.danhSachChiTieu!.isNotEmpty) {
            var resCtCots = await getListFieldChiTieuCot(
                item.danhSachChiTieu!, questionField);
            if (resCtCots.isNotEmpty) {
              result.addAll(resCtCots);
            }
          }
        }
        if (item.bangChiTieu == '2') {
          var resCtDongIOs = await getListFieldChiTieuDong(
              item.danhSachChiTieu!, item.danhSachChiTieuIO!, questionField);
          if (resCtDongIOs.isNotEmpty) {
            result.addAll(resCtDongIOs);
          }
        }
        if (item.bangChiTieu != '1' &&
            item.bangChiTieu != '2' &&
            item.bangChiTieu != '') {
          if (item.maCauHoi == "A1_8") {
            QuestionFieldModel qField = QuestionFieldModel(
                manHinh: item.manHinh,
                maCauHoi: item.maCauHoi,
                tenNganCauHoi: 'Câu ${item.maSo}',
                mucCauHoi: 'Câu ${item.maSo}',
                tenTruong: '${item.maCauHoi}_2',
                loaiCauHoi: item.loaiCauHoi,
                giaTriLN: item.giaTriLN,
                giaTriNN: item.giaTriNN,
                bangChiTieu: item.bangChiTieu,
                bangDuLieu: item.bangDuLieu,
                question: item);
            result.add(qField);
          }
        }
        if (item.danhSachCauHoiCon!.isNotEmpty) {
          var res =
              await getListFieldToValidateCauHoiCon(item.danhSachCauHoiCon!);
          if (res.isNotEmpty) {
            result.addAll(res);
          }
        }
      }
    }
    return result;
  }

  Future<List<QuestionFieldModel>> getListFieldToValidateCauHoiCon(
      List<QuestionCommonModel> questionsCon) async {
    List<QuestionFieldModel> result = [];
    if (questionsCon.isNotEmpty) {
      for (var item in questionsCon) {
        QuestionFieldModel questionField = QuestionFieldModel(
            manHinh: item.manHinh,
            maCauHoi: item.maCauHoi,
            tenNganCauHoi: 'Câu ${item.maSo}',
            mucCauHoi: 'Câu ${item.maSo}',
            tenTruong: item.maCauHoi,
            loaiCauHoi: item.loaiCauHoi,
            giaTriLN: item.giaTriLN,
            giaTriNN: item.giaTriNN,
            bangChiTieu: item.bangChiTieu,
            bangDuLieu: item.bangDuLieu,
            tenTruongKhoa: '',
            question: item);
        result.add(questionField);

        ///Trinh do chuyen mon
        if (item.maCauHoi == columnPhieuTonGiaoA5_2 ||
            item.maCauHoi == columnPhieuTonGiaoA1_5_6 ||
            item.maCauHoi == columnPhieuTonGiaoA1_6 ||
            item.maCauHoi == columnPhieuTonGiaoA1_7) {
          QuestionFieldModel qField = QuestionFieldModel(
              manHinh: item.manHinh,
              maCauHoi: item.maCauHoi,
              tenNganCauHoi: 'Câu ${item.maSo}',
              mucCauHoi: 'Câu ${item.maSo}',
              tenTruong: '${item.maCauHoi}_GhiRo',
              loaiCauHoi: item.loaiCauHoi,
              giaTriLN: item.giaTriLN,
              giaTriNN: item.giaTriNN,
              bangChiTieu: item.bangChiTieu,
              bangDuLieu: item.bangDuLieu,
              question: item);
          result.add(qField);
        }
        if (item.bangChiTieu == '1') {
          if (item.danhSachChiTieu!.isNotEmpty) {
            var resCtCots = await getListFieldChiTieuCot(
                item.danhSachChiTieu!, questionField);
            if (resCtCots.isNotEmpty) {
              result.addAll(resCtCots);
            }
          }
        }
        if (item.bangChiTieu == '2') {
          var resCtDongIOs = await getListFieldChiTieuDong(
              item.danhSachChiTieu!, item.danhSachChiTieuIO!, questionField);
          if (resCtDongIOs.isNotEmpty) {
            result.addAll(resCtDongIOs);
          }
        }
        if (item.bangChiTieu != '1' &&
            item.bangChiTieu != '2' &&
            item.bangChiTieu != '') {
          if (item.maCauHoi == "A1_8") {
            QuestionFieldModel qField = QuestionFieldModel(
                manHinh: item.manHinh,
                maCauHoi: item.maCauHoi,
                tenNganCauHoi: 'Câu ${item.maSo}',
                mucCauHoi: 'Câu ${item.maSo}',
                tenTruong: '${item.maCauHoi}_2',
                loaiCauHoi: item.loaiCauHoi,
                giaTriLN: item.giaTriLN,
                giaTriNN: item.giaTriNN,
                bangChiTieu: item.bangChiTieu,
                bangDuLieu: item.bangDuLieu,
                question: item);
            result.add(qField);
          }
        }
        if (item.danhSachCauHoiCon!.isNotEmpty) {
          var res =
              await getListFieldToValidateCauHoiCon(item.danhSachCauHoiCon!);
          result.addAll(res);
        }
      }
    }
    return result;
  }

  Future<List<QuestionFieldModel>> getListFieldChiTieuCot(
      List<ChiTieuModel> danhSachChiTieuCot,
      QuestionFieldModel questionModel) async {
    List<QuestionFieldModel> result = [];
    if (danhSachChiTieuCot.isNotEmpty) {
      for (var ctItem in danhSachChiTieuCot) {
        if (ctItem.loaiChiTieu.toString() == AppDefine.loaiChiTieu_1) {
          QuestionFieldModel qCtField = QuestionFieldModel(
              manHinh: questionModel.manHinh,
              maCauHoi: ctItem.maCauHoi,
              tenNganCauHoi: 'Câu ${questionModel.tenNganCauHoi}',
              mucCauHoi:
                  '${questionModel.tenNganCauHoi}: Chỉ tiêu ${ctItem.tenChiTieu?.replaceAll('[sản phẩm]', '')}',
              tenTruong: '${ctItem.maCauHoi}_${ctItem.maChiTieu}',
              loaiCauHoi: ctItem.loaiCauHoi,
              giaTriLN: ctItem.giaTriLN,
              giaTriNN: ctItem.giaTriNN,
              bangChiTieu: questionModel.bangChiTieu,
              bangDuLieu: questionModel.bangDuLieu,
              tenTruongKhoa: '',
              question: questionModel.question,
              chiTieuCot: ctItem);
          result.add(qCtField);
        }
      }
    }
    return result;
  }

  Future<List<QuestionFieldModel>> getListFieldChiTieuDong(
      List<ChiTieuModel> danhSachChiTieuCot,
      List<ChiTieuDongModel> danhSachChiTieuDong,
      QuestionFieldModel questionModel) async {
    List<QuestionFieldModel> result = [];
    if (danhSachChiTieuDong.isNotEmpty) {
      for (var ctDong in danhSachChiTieuDong) {
        if (ctDong.loaiCauHoi != AppDefine.loaiCauHoi_10 &&
            ctDong.maSo != AppDefine.maso_00 &&
            ctDong.maSo != AppDefine.maso_00) {}
        if (ctDong.loaiCauHoi != AppDefine.loaiCauHoi_10) {
          var ctCots = danhSachChiTieuCot
              .where((x) =>
                  x.maPhieu == ctDong.maPhieu &&
                  x.maCauHoi == ctDong.maCauHoi &&
                  (x.loaiChiTieu.toString() == AppDefine.loaiChiTieu_1))
              .toList();

          if (ctCots.isNotEmpty) {
            for (var ctCot in ctCots) {
              String fName = '${ctDong.maCauHoi}_${ctDong.maSo}';
              if (ctCot.maCauHoi == "A5_3" || ctCot.maCauHoi == "A6_1") {
                fName = getFieldNameByChiTieuDongCot(ctCot, ctDong);
              }
              QuestionFieldModel qCtField = QuestionFieldModel(
                  manHinh: questionModel.manHinh,
                  maCauHoi: ctDong.maCauHoi,
                  tenNganCauHoi: 'Câu ${questionModel.tenNganCauHoi}',
                  mucCauHoi:
                      '${questionModel.tenNganCauHoi} Mã số ${ctDong.maSo}',
                  tenTruong: fName,
                  loaiCauHoi: ctCot.loaiCauHoi,
                  giaTriLN: ctCot.giaTriLN,
                  giaTriNN: ctCot.giaTriNN,
                  bangChiTieu: questionModel.bangChiTieu,
                  bangDuLieu: questionModel.bangDuLieu,
                  tenTruongKhoa: '',
                  question: questionModel.question,
                  chiTieuCot: ctCot,
                  chiTieuDong: ctDong);
              if (qCtField.tenTruong != null &&
                  qCtField.tenTruong != '' &&
                  qCtField.tenTruong!.contains('.')) {
                qCtField.tenTruong = qCtField.tenTruong!.replaceAll('.', '_');
              }
              result.add(qCtField);
              if (ctDong.maSo == '07.1' || ctDong.maSo == '10') {
                QuestionFieldModel qCtField = QuestionFieldModel(
                    manHinh: questionModel.manHinh,
                    maCauHoi: ctDong.maCauHoi,
                    tenNganCauHoi: 'Câu ${questionModel.tenNganCauHoi}',
                    mucCauHoi:
                        '${questionModel.tenNganCauHoi} Mã số ${ctDong.maSo} Ghi rõ',
                    tenTruong: '${ctDong.maCauHoi}_${ctDong.maSo}_GhiRo',
                    loaiCauHoi: ctCot.loaiCauHoi,
                    giaTriLN: ctCot.giaTriLN,
                    giaTriNN: ctCot.giaTriNN,
                    bangChiTieu: questionModel.bangChiTieu,
                    bangDuLieu: questionModel.bangDuLieu,
                    tenTruongKhoa: '',
                    question: questionModel.question,
                    chiTieuCot: ctCot,
                    chiTieuDong: ctDong);
                if (qCtField.tenTruong != null &&
                    qCtField.tenTruong != '' &&
                    qCtField.tenTruong!.contains('.')) {
                  qCtField.tenTruong = qCtField.tenTruong!.replaceAll('.', '_');
                }
                result.add(qCtField);
              }
            }
          }
        }
      }
    }
    return result;
  }

  void onKetThucPhongVan() async {
    handleCompletedQuestion(
        tableThongTinNPV: completeInfo,
        onChangeName: (value) {
          onChangeCompleted(nguoiTraLoiBase, value);
        },
        onChangePhone: (value) {
          onChangeCompleted(soDienThoaiBase, value);
        },
        onChangeNameDTV: (value) {
          onChangeCompleted(hoTenDTVBase, value);
        },
        onChangePhoneDTV: (value) {
          onChangeCompleted(soDienThoaiDTVBase, value);
        },
        onUpdate: (Map updateValues) async {
          setLoading(true);
          await Future.wait(completeInfo.keys
              .map((e) => updateAnswerCompletedToDb(e, completeInfo[e])));
          await Future.wait(updateValues.keys
              .map((e) => updateAnswerCompletedToDb(e, updateValues[e])));

          if (glat == null && glng == null) {
            setLoading(false);
            var res = handleNoneLocation();
            return;
          }

          ///BEGIN::added by tuannb 06/082024: Cập nhật lại thời gian bắt đầu và kết thúc phỏng vấn phiếu
          if (generalInformationController.tblBkTonGiao.value.maTrangThaiDT !=
              9) {
            await onChangeCompleted(ThoiGianBD, startTime.toIso8601String());
            await onChangeCompleted(
                ThoiGianKT, DateTime.now().toIso8601String());
          }
          bkCoSoTonGiaoProvider.updateTrangThai(currentIdCoSo!);
          AppPref.setQuestionNoStartTime = '';
          final sTimeLog = AppPref.getQuestionNoStartTime;
          log('AppPref.getQuestionNoStartTime $sTimeLog');

          ///END:: added
          ///
          setLoading(false);
          Get.offAllNamed(AppRoutes.mainMenu);
          //  onBackInterviewListDetail();
        });
  }

/***********/
  ///
  // getManHinhByMaCauHoi(L  String maCauHoi) async {
  //    dynamic map = await dataProvider.selectTop1();
  //     TableData tableData = TableData.fromJson(map);
  //     dynamic question08 = tableData.toCauHoiPhieu08();

  //     List<QuestionCommonModel> questionsTemp =
  //         QuestionCommonModel.listFromJson(jsonDecode(question08));
  //   var mh = questions.where((x) => x.maCauHoi == maCauHoi).firstOrNull;
  //   if (mh != null) {
  //     return mh.manHinh;
  //   }
  // }

  ///BEGIN::WARNING

  ///END::WARNING
/***********/
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
    log('onPaused currentScreenNo: ${currentScreenNo.value}');
    fetchData();
    var validateResult = validateAllFormV2();

    validateResult.then((value) {
      if (value != '') {
        insertUpdateXacNhanLogicWithoutEnable(
            currentScreenNo.value,
            currentIdCoSo!,
            int.parse(currentMaDoiTuongDT!),
            0,
            value,
            int.parse(currentMaTinhTrangDT!));
        //   return showError(value);
      }
    });
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }

  ///END::CÂU 32
  ///
}
