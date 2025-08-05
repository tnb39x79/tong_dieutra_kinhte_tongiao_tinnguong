import 'package:get/get.dart';
import 'package:gov_tongdtkt_tongiao/resource/services/api/search_sp/vcpa_vsic_ai_search_provider.dart';
import 'package:gov_tongdtkt_tongiao/resource/services/api/search_sp/vcpa_vsic_ai_search_repository.dart';

import 'question_no07_controller.dart';

class QuestionNo07Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(QuestionNo07Controller(vcpaVsicAIRepository: Get.find())); 
  }
}
