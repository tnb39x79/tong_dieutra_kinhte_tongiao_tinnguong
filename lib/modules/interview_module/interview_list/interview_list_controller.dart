import 'package:get/get.dart';
import 'package:gov_tongdtkt_tongiao/config/config.dart';
import 'package:gov_tongdtkt_tongiao/modules/modules.dart';
import 'package:gov_tongdtkt_tongiao/resource/resource.dart';
import 'package:gov_tongdtkt_tongiao/routes/routes.dart';

///Danh sách phỏng vấn:
///Gồm:
/// 1. currentMaDoiTuongDT=1, 2
/// - Cơ sở chưa phỏng vấn
/// - Cơ sở đã phỏng vấn
/// hoặc
/// 2. currentMaDoiTuongDT=53
/// - Xã chưa phỏng vấn
/// - Xã đã phỏng vấn
class InterviewListController extends BaseController {
  final HomeController homeController = Get.find();

  static const maDoiTuongDTKey = 'maDoiTuongDT';
  static const maDiaBanKey = 'maDiaBan';
  static const maDiaBanTGKey = 'maDiaBanTG';
  static const maXaKey = 'maXa';
  static const tenDoiTuongDTKey = "tenDoiTuongDT";

 
  BKCoSoTonGiaoProvider bkCoSoTonGiaoProvider = BKCoSoTonGiaoProvider();

  final countOfUnInterviewed = 0.obs;
  final countOfInterviewed = 0.obs;

  String currentMaDoiTuongDT = Get.parameters[maDoiTuongDTKey]!;
  String currentTenDoiTuongDT = 'Phiếu 9/TG';
  String? currentMaDiaBan = Get.parameters[maDiaBanKey];
  String? currentMaDiaBanTG = Get.parameters[maDiaBanTGKey];
  String? currentMaXa = Get.parameters[maXaKey];

  @override
  void onInit() async {
    setLoading(true);
    await selectCountByType();
    setLoading(false);
    super.onInit();
  }

  getSubTitle() {
    String subTitle = currentTenDoiTuongDT; 
    return subTitle;
  }

  void backInterviewObjectList() {
    Get.toNamed(AppRoutes.interviewLocationList, parameters: {
        InterviewLocationListController.maDoiTuongDTKey: currentMaDoiTuongDT,
        InterviewLocationListController.tenDoiTuongDTKey: currentTenDoiTuongDT,
      });
  }

  void toInterViewListDetail(int maTinhTrangDT) async {
      Get.toNamed(AppRoutes.interviewListDetail, parameters: {
        InterviewListDetailController.maDoiTuongDTKey: currentMaDoiTuongDT,
        InterviewListDetailController.tenDoiTuongDTKey: currentTenDoiTuongDT,
        InterviewListDetailController.maTinhTrangDTKey: '$maTinhTrangDT',
        InterviewListDetailController.maDiaBanTGKey: currentMaDiaBanTG ?? '',
        InterviewListDetailController.maXaKey: currentMaXa ?? '',
      });
      selectCountByType();
  }

  Future selectCountByType() async {
     countOfUnInterviewed.value =
          await bkCoSoTonGiaoProvider.countOfUnInterviewedAll() ?? 0;
      countOfInterviewed.value =
          await bkCoSoTonGiaoProvider.countOfInterviewedAll() ?? 0;
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
