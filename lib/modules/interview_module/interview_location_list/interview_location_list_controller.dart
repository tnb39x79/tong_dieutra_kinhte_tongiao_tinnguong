import 'package:get/get.dart';
import 'package:gov_tongdtkt_tongiao/config/config.dart';
import 'package:gov_tongdtkt_tongiao/modules/modules.dart'; 
import 'package:gov_tongdtkt_tongiao/resource/resource.dart';
import 'package:gov_tongdtkt_tongiao/routes/routes.dart';

///Danh sách địa bàn hộ
class InterviewLocationListController extends BaseController {
  HomeController homeController = Get.find();

  static const maDoiTuongDTKey = 'maDoiTuongDT';
  static const tenDoiTuongDTKey = "tenDoiTuongDT";
  
  String currentMaDoiTuongDT = Get.parameters[maDoiTuongDTKey]!;
  String currentTenDoiTuongDT = Get.parameters[tenDoiTuongDTKey]!;
  // db provider
//  final diaBanCoSoSXKDProvider = DiaBanCoSoSXKDProvider();

  //RX
  //final diaBanCoSoSXKDs = <TableDmDiaBanCosoSxkd>[].obs;

  dynamic data;

  @override
  void onInit() async {
    setLoading(true);
    await getCoSoSXKD();
    setLoading(false);

    super.onInit();
  }

  void onBackInterviewObjectList() {
    Get.toNamed(AppRoutes.interviewObjectList);
  }

  void onPressItem(int index) {
    // Get.toNamed(AppRoutes.interviewList, parameters: {
    //   InterviewListController.maDoiTuongDTKey: currentMaDoiTuongDT,
    //   InterviewListController.tenDoiTuongDTKey: currentTenDoiTuongDT,
    //   InterviewListController.maDiaBanKey: diaBanCoSoSXKDs[index].maDiaBan!,
    //   InterviewListController.maXaKey: diaBanCoSoSXKDs[index].maXa!,
    // });
  }

  Future getCoSoSXKD() async {
    // List<Map> map = await diaBanCoSoSXKDProvider.selectByMaPhieu(int.parse(currentMaDoiTuongDT!));
    // diaBanCoSoSXKDs.clear();
    // for (var element in map) {
    //   diaBanCoSoSXKDs.add(TableDmDiaBanCosoSxkd.fromJson(element));
    // }
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
