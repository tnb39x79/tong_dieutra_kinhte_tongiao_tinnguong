import 'package:flutter/material.dart';
import 'package:gov_tongdtkt_tongiao/common/common.dart';
import 'package:gov_tongdtkt_tongiao/common/widgets/question/input_string.dart';
import 'package:gov_tongdtkt_tongiao/config/constants/app_colors.dart';
import 'package:gov_tongdtkt_tongiao/config/constants/app_styles.dart';
import 'package:gov_tongdtkt_tongiao/modules/question_module/question_no08/widget/checkbox_circle_dm.dart';
import 'package:gov_tongdtkt_tongiao/modules/question_module/question_no08/widget/input_string_dm.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm08.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm_gioitinh.dart';
import 'package:gov_tongdtkt_tongiao/resource/resource.dart';

class SelectStringDm extends StatefulWidget {
  final QuestionCommonModel question;
  final Function(String, dynamic) onChangeSelectStringDm;
  final List<dynamic> listValue;
  final String? tenDanhMuc;
  final Function()? onFinish;
  final String? value;
  final ProductModel? product;
  final String? titleGhiRoText;
  final bool? hienThiTenCauHoi;
  final Function(String?, dynamic)? onChangeSelectStringDmGhiRo;
  const SelectStringDm(
      {super.key,
      required this.question,
      required this.onChangeSelectStringDm,
      required this.listValue,
      required this.tenDanhMuc,
      this.value,
      this.onFinish,
      this.product,
      this.titleGhiRoText,
      this.onChangeSelectStringDmGhiRo,
      this.hienThiTenCauHoi});

  @override
  SelectStringDmState createState() => SelectStringDmState();
}

class SelectStringDmState extends State<SelectStringDm> {
  String _value = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildTenCauHoi(),
        _buildValues(),
      ],
    );
  }

  Widget buildTenCauHoi() {
    if (widget.hienThiTenCauHoi != null && widget.hienThiTenCauHoi == false) {
      if (widget.titleGhiRoText != null && widget.titleGhiRoText != '') {
        return RichTextQuestion(
          widget.titleGhiRoText!,
          product: widget.product,
          level: 3,
        );
      }
      return const SizedBox();
    }

    return RichTextQuestion(
      widget.question.tenCauHoi ?? '',
      product: widget.product,
    );
  }

  Widget _buildValues() {
    return Container(
        margin: const EdgeInsets.all(0.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            border: Border.all(color: greyDarkBorder, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            color: Colors.white),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.listValue.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              String maVal = '';
              String tenVal = '';
              dynamic itemDyn;
              int ghiRo = 0;

              if (widget.tenDanhMuc == tableTGDmNangLuong) {
                TableTGDmNangLuong item = widget.listValue[index];
                itemDyn = item;
                maVal = item.ma!;
                tenVal = item.ten!;
              }
              return Column(
                children: [
                  CheckBoxCircleDm(
                    text: tenVal,
                    index: index,
                    currentIndex: -1,
                    showIndex: false,
                    styles: styleMedium.copyWith(height: 1.0),
                    isSelected: _value == maVal || widget.value == maVal,
                    onPressed: (value) {
                      String val = maVal ?? '';
                      widget.onChangeSelectStringDm(val, itemDyn);
                      setState(() {
                        _value = val;
                      });
                    },
                  ),
                ],
              );
            }));
  }

  Widget buildGhiRo(int ghiRo, dmItem) {
    if (ghiRo != 0) {
      return InputStringDm(
          question: widget.question,
          titleText: widget.titleGhiRoText,
          onChange: (String? value) =>
              widget.onChangeSelectStringDmGhiRo ??
              widget.onChangeSelectStringDmGhiRo!(
                  value != '' ? value : null, dmItem));
    }
    return const SizedBox();
  }
}
