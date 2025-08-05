import 'package:gov_tongdtkt_tongiao/common/utils/app_utils.dart';
import 'package:gov_tongdtkt_tongiao/common/valid/valid.dart';
import 'package:gov_tongdtkt_tongiao/config/constants/app_define.dart';

class ValidateQuestionNo08 {
  static onValidateInputA43(
      String table,
      String maCauHoi,
      String? fieldName,
      idValue,
      String? valueInput,
      minLen,
      maxLen,
      minValue,
      maxValue,
      int loaiCauHoi) {
    if (valueInput == null || valueInput == '' || valueInput == 'null') {
      return 'Vui lòng nhập giá trị.';
    }
  }

  static String? onValidate(String table, String maCauHoi, String? fieldName,
      String? valueInput, minValue, maxValue, int loaiCauHoi) {
    if (valueInput == null || valueInput == "" || valueInput == "null") {
      if ((loaiCauHoi == AppDefine.loaiCauHoi_1 ||
              loaiCauHoi == AppDefine.loaiCauHoi_5) &&
          !fieldName!.contains('_GhiRo')) {
        return 'Vui lòng chọn giá trị.';
      }
      return 'Vui lòng nhập giá trị.';
    }
    
  }
}
