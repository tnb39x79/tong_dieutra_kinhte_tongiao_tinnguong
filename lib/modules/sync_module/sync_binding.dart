import 'package:get/get.dart';
import 'package:gov_tongdtkt_tongiao/modules/sync_module/sync_controller.dart';

class SyncBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SyncController(
        syncRepository: Get.find(), sendErrorRepository: Get.find()));
  }
}
