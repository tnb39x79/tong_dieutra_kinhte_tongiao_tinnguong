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

class SelectIntDm extends StatefulWidget {
  final QuestionCommonModel question;
  final Function(int, dynamic) onChange;
  final List<dynamic> listValue;
  final String? tenDanhMuc;
  final Function()? onFinish;
  final int? value;
  final ProductModel? product;
  final String? titleGhiRoText;
  final bool? hienThiTenCauHoi;
  final Function(String?, dynamic)? onChangeGhiRo;
  final bool? isbg;
  const SelectIntDm(
      {super.key,
      required this.question,
      required this.onChange,
      required this.listValue,
      required this.tenDanhMuc,
      this.value,
      this.onFinish,
      this.product,
      this.titleGhiRoText,
      this.onChangeGhiRo,
      this.hienThiTenCauHoi,
      this.isbg});

  @override
  _SelectIntDmState createState() => _SelectIntDmState();
}

class _SelectIntDmState extends State<SelectIntDm> {
  int _value = -1;

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
    if (widget.isbg != null && widget.isbg == true) {
      return Container(
          margin: const EdgeInsets.all(0.0),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              border: Border.all(color: greyDarkBorder, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              color: Colors.white),
          child: wList());
    }
    return wList();
  }

  Widget wList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.listValue.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          int maVal = 0;
          String tenVal = '';
          dynamic itemDyn;
          int ghiRo = 0;
          // if (widget.listValue is TableTGDmCapCongNhan ||
          //     widget.listValue is TableTGDmSudDngPhanMem ||
          //     widget.listValue is TableTGDmXepHang ||
          //     widget.listValue is TableTGDmXepHangDiTich) {
          if (widget.tenDanhMuc == tableTGDmCapCongNhan) {
            TableTGDmCapCongNhan item = widget.listValue[index];
            itemDyn = item;
            maVal = item.ma!;
            tenVal = item.ten!;
          } else if (widget.tenDanhMuc == tableTGDmSudDngPhanMem) {
            TableTGDmSudDngPhanMem item = widget.listValue[index];
            itemDyn = item;
            maVal = item.ma!;
            tenVal = item.ten!;
          } else if (widget.tenDanhMuc == tableTGDmXepHang) {
            TableTGDmXepHang item = widget.listValue[index];
            itemDyn = item;
            maVal = item.ma!;
            tenVal = item.ten!;
          } else if (widget.tenDanhMuc == tableTGDmXepHangDiTich) {
            TableTGDmXepHangDiTich item = widget.listValue[index];
            itemDyn = item;
            maVal = item.ma!;
            tenVal = item.ten!;
          } else if (widget.tenDanhMuc == tableTGDmLoaiCoSo) {
            TableTGDmLoaiCoSo item = widget.listValue[index];
            itemDyn = item;
            maVal = item.ma!;
            tenVal = item.ten!;
            ghiRo = item.ghiRo ?? 0;
          } else if (widget.tenDanhMuc == tableTGDmLoaiHinhTonGiao) {
            TableTGDmLoaiHinhTonGiao item = widget.listValue[index];
            itemDyn = item;
            maVal = item.ma!;
            tenVal = item.ten!;
          } else if (widget.tenDanhMuc == tableTGDmTrinhDoChuyenMon) {
            TableTGDmTrinhDoChuyenMon item = widget.listValue[index];
            itemDyn = item;
            maVal = item.ma!;
            tenVal = item.ten!;
          } else if (widget.tenDanhMuc == tableDmGioiTinh) {
            TableDmGioiTinh item = widget.listValue[index];
            itemDyn = item;
            maVal = item.ma!;
            tenVal = item.ten!;
          } else if (widget.tenDanhMuc == tableDmLoaiTonGiao) {
            TableDmLoaiTonGiao item = widget.listValue[index];
            itemDyn = item;
            maVal = item.ma!;
            tenVal = item.ten!;
          } else if (widget.tenDanhMuc == tableDmCoKhong) {
            TableDmCoKhong item = widget.listValue[index];
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
                  int val = maVal ?? 0;
                  widget.onChange(val, itemDyn);
                  setState(() {
                    _value = val;
                  });
                },
              ),
              //   buildGhiRo(ghiRo, itemDyn)
            ],
          );

          // TableDmDiaDiem item = widget.listValue[index];
          // var name = widget.listValue[index].tenDiaDiem!.split('>>');

          // return CheckBoxCircle(
          //   text: name[0],
          //   index: index,
          //   currentIndex: -1,
          //   showIndex: false,
          //   styles: styleMedium.copyWith(height: 1.0),
          //   isSelected:
          //       _value == item.maDiaDiem || widget.value == item.maDiaDiem,
          //   onPressed: (value) {
          //     int val = item.maDiaDiem ?? 0;
          //     widget.onChange(val);
          //     setState(() {
          //       _value = val;
          //     });
          //   },
          // );
        });
  }

  Widget buildGhiRo(int ghiRo, dmItem) {
    if (ghiRo != 0) {
      return InputStringDm(
          question: widget.question,
          titleText: widget.titleGhiRoText,
          onChange: (String? value) =>
              widget.onChangeGhiRo ??
              widget.onChangeGhiRo!(value != '' ? value : null, dmItem));
    }
    return const SizedBox();
  }
}
