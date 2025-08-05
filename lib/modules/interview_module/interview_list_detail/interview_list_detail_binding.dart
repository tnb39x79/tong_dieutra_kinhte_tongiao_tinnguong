import 'package:get/get.dart';
import 'package:gov_tongdtkt_tongiao/modules/modules.dart'; 
 
class InterviewListDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InterviewListDetailController());
  }
}
