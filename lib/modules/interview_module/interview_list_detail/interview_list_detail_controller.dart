import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_tongdtkt_tongiao/config/constants/app_define.dart';
import 'package:gov_tongdtkt_tongiao/modules/modules.dart'; 
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm_bkcoso_tongiao.dart'; 
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm_dia_ban_coso_tongiao.dart';
import 'package:gov_tongdtkt_tongiao/routes/routes.dart';
import 'package:rxdart/subjects.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/provider/provider.dart';

class InterviewListDetailController extends BaseController {
  // maTinhTrangDT = 1 => chua pv
  // maTinhTrangDT = 9 => da pv
  static const maDoiTuongDTKey = 'maDoiTuongDT';
  static const tenDoiTuongDTKey = 'tenDoiTuongDT';
  static const maTinhTrangDTKey = 'maTinhTrangDT';
  static const maDiaBanKey = 'maDiaBan';
  static const maDiaBanTGKey = 'maDiaBanTG';
  static const maXaKey = 'maXa';
  static const routeKey = 'routeKey';
  // controller
  final searchController = TextEditingController();
  final sliverController = ScrollController();

  // params
  String currentMaDoiTuongDT = Get.parameters[maDoiTuongDTKey]!;
  String currentTenDoiTuongDT = Get.parameters[tenDoiTuongDTKey]!;
  String currentMaTinhTrangDT = Get.parameters[maTinhTrangDTKey]!;
  String? currentMaDiaBan = Get.parameters[maDiaBanKey];
  String? currentMaDiaBanTG = Get.parameters[maDiaBanTGKey];
  String? currentMaXa = Get.parameters[maXaKey];

  //static final interviewListDetailStream = PublishSubject();

  // params send to questions
  String? currentIdCoSoTG;
  String? currentIdCoSo;

  //RX
  final danhSachDiabanHo = <TableDmDiaBanTonGiao>[].obs; 
  final danhSachBKTonGiao = <TableBkTonGiao>[].obs;
  //final danhSachBKCoSoSXXKD = <TableBkCoSoSXKD>[].obs;
  

  // provider 
  final bkCoSoTonGiaoProvider = BKCoSoTonGiaoProvider(); 
  final diaBanCoSoTonGiaoProvider = DiaBanCoSoTonGiaoProvider();
  final doiTuongDieuTraProvider = DmDoiTuongDieuTraProvider();
   
  @override
  void onInit() async {
    log('current maxa $currentMaXa currentMaDiaBanTG $currentMaDiaBanTG' );
    setLoading(true);
    await getSubjects();
    setLoading(false);

    // interviewListDetailStream.stream.listen((value) {
    //   if (value) {
    //     getSubjects();
    //   }
    // });
    super.onInit();
  }
 
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void backInterviewList() {
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      Get.toNamed(AppRoutes.interviewList, parameters: {
        InterviewListController.maDoiTuongDTKey: currentMaDoiTuongDT,
        InterviewListController.tenDoiTuongDTKey: currentTenDoiTuongDT,
      });
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      Get.toNamed(AppRoutes.interviewList, parameters: {
        InterviewListController.maDoiTuongDTKey: currentMaDoiTuongDT,
        InterviewListController.tenDoiTuongDTKey: currentTenDoiTuongDT,
      });
    } else if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_08.toString()) {
      Get.toNamed(AppRoutes.interviewLocationList, parameters: {
        InterviewLocationListController.maDoiTuongDTKey: currentMaDoiTuongDT,
        InterviewLocationListController.tenDoiTuongDTKey: currentTenDoiTuongDT,
      });
    }
  }

  startInterView(int index) async {
   
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_08.toString()) {
      currentIdCoSoTG = danhSachBKTonGiao[index].iDCoSo;
      //currentMaDiaban= danhSachBKTonGiao[index].maDiaBan;
      await Get.toNamed(AppRoutes.activeStatus);
      await getSubjects();
    } else {}
  }

  Future getSubjects() async {
    
     if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_08.toString()) {
      // => dieu tra theo xa (cơ sở tôn giáo, tín ngưỡng)
      if (currentMaTinhTrangDT == AppDefine.chuaPhongVan.toString()) {
        await getListBkTonGiaoUnInterviewed();
      } else {
        await getListBkCoSoTonGiaoInterviewed();
      }
    }
  }

  onSearch(String search) async {
    
    if (currentMaDoiTuongDT == AppDefine.maDoiTuongDT_08.toString()) {
      // => dieu tra theo dia ban(ho)
      if (currentMaTinhTrangDT == AppDefine.chuaPhongVan.toString()) {
        await getListBkTonGiaoUnInterviewed(search: search);
      } else {
        await getListBkCoSoTonGiaoInterviewed(search: search);
      }
    }
  }

  // danh sach BK cơ sở tôn giáo chua phong van
  Future getListBkTonGiaoUnInterviewed({String? search}) async {
    if (search != null) {
      List<Map> maps =
          await bkCoSoTonGiaoProvider.searchListUnInterviewed(search);
      danhSachBKTonGiao.clear();
      danhSachBKTonGiao.value = TableBkTonGiao.listFromJson(maps);
    } else {
      List<Map> maps =
          await bkCoSoTonGiaoProvider.selectListUnInterviewed();
      danhSachBKTonGiao.clear();
      danhSachBKTonGiao.value = TableBkTonGiao.listFromJson(maps);
    }
  }

  // danh sach BK  cơ sở tôn giáo phong van
  Future getListBkCoSoTonGiaoInterviewed({String? search}) async {
    if (search != null) {
      List<Map> maps =
          await bkCoSoTonGiaoProvider.searchListInterviewed(search);
      danhSachBKTonGiao.clear();
      danhSachBKTonGiao.value = TableBkTonGiao.listFromJson(maps);
    } else {
      List<Map> maps =
          await bkCoSoTonGiaoProvider.selectAllListInterviewed();
      danhSachBKTonGiao.clear();
      danhSachBKTonGiao.value = TableBkTonGiao.listFromJson(maps);
    }
  }
 

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
}
