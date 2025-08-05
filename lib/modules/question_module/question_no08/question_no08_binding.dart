import 'package:get/get.dart';
 
import 'question_no08_controller.dart';

class QuestionNo08Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(QuestionNo08Controller(vcpaVsicAIRepository: Get.find()));
  }
}
