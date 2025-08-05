import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:gov_tongdtkt_tongiao/common/utils/utils.dart';
import 'package:gov_tongdtkt_tongiao/common/widgets/input/search_dantoc.dart';
import 'package:gov_tongdtkt_tongiao/common/widgets/input/search_vcpa_cap5.dart';
import 'package:gov_tongdtkt_tongiao/common/widgets/question/input_int%20view.dart';

import 'package:gov_tongdtkt_tongiao/common/widgets/question/input_string.dart';
import 'package:gov_tongdtkt_tongiao/common/widgets/question/select_int.dart';

import 'package:gov_tongdtkt_tongiao/common/widgets/sidebar/sidebar.dart';
import 'package:gov_tongdtkt_tongiao/common/widgets/widgets.dart';
import 'package:gov_tongdtkt_tongiao/config/config.dart';
import 'package:gov_tongdtkt_tongiao/modules/question_module/question_no07/widget/input_string_chitieu_ct.dart';
import 'package:gov_tongdtkt_tongiao/modules/question_module/question_no07/widget/input_string_ct_dm.dart';
import 'package:gov_tongdtkt_tongiao/modules/question_module/question_no07/widget/input_string_vcpa.dart';
import 'package:gov_tongdtkt_tongiao/modules/question_module/question_no07/widget/new_yes_no_question.dart';
import 'package:gov_tongdtkt_tongiao/modules/question_module/question_no07/widget/select_int_ct_dm.dart';
import 'package:gov_tongdtkt_tongiao/modules/question_module/question_no07/widget/select_mutil_int_dm.dart';
import 'package:gov_tongdtkt_tongiao/modules/question_module/question_no07/widget/select_string_ct_dm.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/filed_common.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_ct_dm_diadiem_sxkd.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm.dart';
import 'package:gov_tongdtkt_tongiao/resource/model/model.dart';
import 'package:gov_tongdtkt_tongiao/resource/model/question/danh_dau_sanpham_model.dart';

import '../../../resource/database/table/table_p07mau.dart';
import 'question_no07_controller.dart';

class QuestionNo07Screen extends GetView<QuestionNo07Controller> {
  const QuestionNo07Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingFullScreen(
      loading: controller.loadingSubject,
      child: GestureDetector(
        onTap: () => controller.unFocus(context),
        child: Scaffold(
          key: controller.scaffoldKey,
          endDrawerEnableOpenDragGesture: false,
          appBar: AppBarHeader(
            title: '${controller.currentTenDoiTuongDT}',
            questionCode: 4,
            onPressedLeading: () => {},
            subTitle: controller.subTitleBar,
            iconLeading: IconButton(
                onPressed: () => {},
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            actions: IconButton(
                onPressed: controller.onOpenDrawerQuestionGroup,
                icon: const Icon(Icons.menu_rounded)),
            backAction: controller.onBackStart,
          ),
          body: _buildBody(),
          drawer: SideBar(
              controller.questionGroupList,
              drawerTitle: controller.subTitleBar,
              controller.onMenuPress,
              hasPhanVI: ((controller.isCap1HPhanVI.value &&
                      controller.isCap5DichVuHangHoaPhanVI.value) ||
                  (controller.isCap1HPhanVI.value &&
                      controller.isCap5VanTaiHanhKhachPhanVI.value)),
              hasPhanVII: controller.isCap2_55PhanVII.value),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          controller: controller.scrollController,
          padding: const EdgeInsets.fromLTRB(
              AppValues.padding, 0, AppValues.padding, AppValues.padding),
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight - kToolbarHeight,
              ),
              child: Obx(() {
                if (controller.questions.isEmpty) return const SizedBox();
                return Column(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichTextQuestion(
                            controller.questions[controller.questionIndex.value]
                                    .tenCauHoi ??
                                '',
                            level: controller
                                .questions[controller.questionIndex.value].cap!,
                            notes: controller
                                    .questions[controller.questionIndex.value]
                                    .giaiThich ??
                                ''),
                        // const SizedBox(height: 50),
                        if (controller.questions[controller.questionIndex.value]
                                .maCauHoi ==
                            "A5")
                          buildPhanV(controller
                              .questions[controller.questionIndex.value])
                        else
                          _buildQuestion(controller
                              .questions[controller.questionIndex.value]),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            child: WidgetButtonPrevious(
                                onPressed: controller.onBack)),
                        const SizedBox(width: 16),
                        Expanded(
                            child:
                                WidgetButtonNext(onPressed: controller.onNext)),
                      ],
                    )
                  ],
                );
              })),
        );
      },
    );
  }

  _buildQuestion(QuestionCommonModel mainQuestion) {
    if (mainQuestion.loaiCauHoi == 0 && mainQuestion.bangChiTieu == '2') {
      List<QuestionCommonModel> questionsCon = mainQuestion.danhSachCauHoiCon!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildQuestionChiTieuDongCot(mainQuestion),
          ListView.builder(
              itemCount: questionsCon.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, index) {
                QuestionCommonModel question = questionsCon[index];
                return _questionItem(question, parentQuestion: mainQuestion);
              })
        ],
      );
    } else if (mainQuestion.danhSachCauHoiCon!.isNotEmpty) {
      List<QuestionCommonModel> questionsCon = mainQuestion.danhSachCauHoiCon!;

      return ListView.builder(
          itemCount: questionsCon.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            QuestionCommonModel question = questionsCon[index];
            return _questionItem(question, parentQuestion: mainQuestion);
          });
    } else {
      if (mainQuestion.loaiCauHoi == 0 && mainQuestion.bangChiTieu == '2') {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [buildQuestionChiTieuDongCot(mainQuestion)],
        );
      }
    }
    return const SizedBox();
  }

  _buildQuestion2(QuestionCommonModel question,
      {ProductModel? product, QuestionCommonModel? parentQuestion}) {
    if (question.danhSachCauHoiCon!.isNotEmpty) {
      List<QuestionCommonModel> questions = question.danhSachCauHoiCon!;

      return ListView.builder(
          itemCount: questions.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            QuestionCommonModel question = questions[index];

            switch (question.loaiCauHoi) {
              case 0:
                if (question.bangChiTieu == '1' && question.loaiCauHoi == 0) {
                  return Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichTextQuestion(
                            question.tenCauHoi ?? '',
                            level: question.cap!,
                          ),
                          buildOnlyQuestionChiTieuCot(question,
                              parentQuestion: parentQuestion),
                        ],
                      ));
                }
              case 2:
                return _renderQuestionType2(question, product: product);
              case 3:
                return _renderQuestionType3(question, product: product);
              case 4:
                return _renderQuestionType4(question);
              case 5:
                if (question.bangChiTieu == tableDmDanToc) {
                  return buildDmDanToc(question);
                } else {
                  return _renderQuestionType5Dm(question);
                }

              // case 7:
              //   return _renderQuestionType7(question);

              default:
                return Container();
            }
          });
    }
    return const SizedBox();
  }

  _buildQuestion3(QuestionCommonModel question) {
    if (question.danhSachCauHoiCon!.isNotEmpty) {
      List<QuestionCommonModel> questions = question.danhSachCauHoiCon!;

      return ListView.builder(
          itemCount: questions.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            QuestionCommonModel question = questions[index];

            switch (question.loaiCauHoi) {
              case 2:
                return _renderQuestionType2(question);
              case 3:
                return _renderQuestionType3(question);

              default:
                return Container();
            }
          });
    }
    return const SizedBox();
  }

  _questionItem(QuestionCommonModel question,
      {QuestionCommonModel? parentQuestion}) {
    switch (question.loaiCauHoi) {
      case 0:
        // if (question.bangChiTieu == '1') {
        //   return Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       RichTextQuestion(
        //         question.tenCauHoi ?? '',
        //         level: question.cap!,
        //       ),
        //       buildOnlyQuestionChiTieuCot(question,
        //           parentQuestion: parentQuestion)
        //     ],
        //   );
        // }
        // return RichTextQuestion(question.tenCauHoi ?? '', level: question.cap!);
        if (question.bangChiTieu == "2") {
          return buildQuestionChiTieuDongCot(question);
        } else {
          //Bỏ không kiểm tra B, C, E
          // if (controller.isNhomNganhCap1BCE == '0' &&
          //     question.maCauHoi == 'A3_1') {
          //   return Container();
          // }
          return _renderQuestionType0(question);
        }
      case 1:
        if (question.bangChiTieu == '2') {
          // return _renderChiTieuDongCotType1(question);
        } else {
          return _renderQuestionType1(question);
        }

      case 2:
        return _renderQuestionType2WithSub(question);
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _renderQuestionType3(question),
            if (question.danhSachCauHoiCon!.isNotEmpty)
              Container(
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: greyDarkBorder, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: _buildQuestion3(question))
          ],
        );
      case 4:
        return _renderQuestionType4(question);
      case 5:
        return _renderQuestionType5Dm(question);
      case 7:
        return renderQuestionType7(question);
      default:
        if (question.bangChiTieu == '2') {
          // if (question.maCauHoi == "A6_2") {
          //   return buildQuestionChiTieuDongCotA6_2(question);
          // }
          return buildQuestionChiTieuDongCot(question);
        }
        return Container();
    }
  }

  _renderQuestionType0(QuestionCommonModel question,
      {ProductModel? product, QuestionCommonModel? parentQuestion}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichTextQuestion(
          question.tenCauHoi ?? '',
          level: question.cap ?? 2,
        ),
        _buildQuestion2(question,
            product: product, parentQuestion: parentQuestion)
      ],
    );
  }

  _renderQuestionType1(QuestionCommonModel question,
      {ProductModel? product, QuestionCommonModel? parentQuestion}) {
    return YesNoQuestion(
      onChange: (value) => controller.onChangeYesNoQuestion(
          question.bangDuLieu!, question.maCauHoi, question.maCauHoi, value),
      question: question,
      key: ValueKey<QuestionCommonModel>(question),
      //   key: ValueKey('${question.maCauHoi}${question.cauHoiUUID}'),
      value: controller.getValueByFieldName(
          question.bangDuLieu!, question.maCauHoi!),
      child: Column(
        children: question.danhSachCauHoiCon!.map<Widget>((question) {
          switch (question.loaiCauHoi) {
            case 0:
              return _renderQuestionType0(question, product: product);

            case 2:
              return Column(
                children: [
                  _renderQuestionType2(question, product: product),
                  if (question.danhSachCauHoiCon!.isNotEmpty)
                    _buildQuestion2(question)
                ],
              );

            case 3:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _renderQuestionType3(question, product: product),
                  if (question.danhSachCauHoiCon!.isNotEmpty)
                    Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: greyDarkBorder, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: _buildQuestion3(question))
                ],
              );
            case 4:
              return _renderQuestionType4(question);
            default:
              return Container();
          }
        }).toList(),
      ),
    );
  }

  _renderQuestionType2(QuestionCommonModel question,
      {String? subName,
      ProductModel? product,
      QuestionCommonModel? parentQuestion}) {
    bool enable = question.maCauHoi != 'xxx' && question.maCauHoi != 'xxx';
    //  return Obx(() {
    var val = controller.getValueByFieldName(
        question.bangDuLieu!, question.maCauHoi!);
    var wFilterInput = RegExp('[0-9]');
    if (!enable) {
      return ViewInput(
        question: question,
        value: val,
      );
    }
    if (question.maCauHoi == "A6_6" || question.maCauHoi == "A7_8_1") {
      return Obx(() {
        var valA6_6_6_7 = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);
        return InputInt(
          key: ValueKey(
              '${question.maCauHoi}${question.cauHoiUUID}_$valA6_6_6_7'),
          question: question,
          onChange: (value) => (),
          enable: false,
          subName: subName,
          value: valA6_6_6_7,
          txtStyle: styleMediumBold.copyWith(color: primaryColor),
        );
      });
    } else if (question.maCauHoi == "A6_4") {
      controller.warningA6_4SoKhachBQ();
      return Obx(() {
        return InputInt(
          key: ValueKey('${question.maCauHoi}${question.cauHoiUUID}'),
          question: question,
          onChange: (value) => controller.onChangeInput(question.bangDuLieu!,
              question.maCauHoi, question.maCauHoi, value),
          enable: enable,
          subName: subName,
          value: val,
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          warningText: (controller.warningA6_4.value != '')
              ? controller.warningA6_4.value
              : '',
        );
      });
    }
    return Obx(() {
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, question.maCauHoi!);
      return InputInt(
        key: ValueKey('${question.maCauHoi}${question.cauHoiUUID}'),
        question: question,
        onChange: (value) => controller.onChangeInput(
            question.bangDuLieu!, question.maCauHoi, question.maCauHoi, value),
        enable: enable,
        subName: subName,
        value: val,
        validator: (String? value) => controller.onValidate(
            question.bangDuLieu!,
            question.maCauHoi!,
            question.maCauHoi,
            value,
            question.giaTriNN,
            question.giaTriLN,
            question.loaiCauHoi!,
            true),
        flteringTextInputFormatterRegExp: wFilterInput,
      );
    });
    // return InputInt(
    //   key: ValueKey('${question.maCauHoi}${question.cauHoiUUID}'),
    //   question: question,
    //   onChange: (value) => controller.onChangeInput(
    //       question.bangDuLieu!, question.maCauHoi, question.maCauHoi, value),
    //   enable: enable,
    //   subName: subName,
    //   value: val,
    //   validator: (String? value) => controller.onValidate(
    //       question.bangDuLieu!,
    //       question.maCauHoi!,
    //       question.maCauHoi,
    //       value,
    //       question.giaTriNN,
    //       question.giaTriLN,
    //       question.loaiCauHoi!,
    //       true),
    //   flteringTextInputFormatterRegExp: wFilterInput,
    // );
    //  });
  }

  _renderQuestionType2WithSub(QuestionCommonModel question,
      {String? subName,
      ProductModel? product,
      QuestionCommonModel? parentQuestion}) {
    var val = controller.getValueByFieldName(
        question.bangDuLieu!, question.maCauHoi!);
    var wFilterInput = RegExp('[0-9]');
    if (question.maCauHoi == "A7_8") {
      return Obx(() {
        var valA7_8 = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputInt(
              key: ValueKey(
                  '${question.maCauHoi}${question.cauHoiUUID}_$valA7_8'),
              question: question,
              onChange: (value) => (),
              enable: false,
              subName: subName,
              value: valA7_8,
            ),
            if (question.danhSachCauHoiCon!.isNotEmpty)
              Container(
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: greyDarkBorder, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: _buildQuestion3(question))
          ],
        );
      });
    }
    return Obx(() {
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, question.maCauHoi!);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputInt(
            key: ValueKey('${question.maCauHoi}${question.cauHoiUUID}'),
            question: question,
            onChange: (value) => controller.onChangeInput(question.bangDuLieu!,
                question.maCauHoi, question.maCauHoi, value),
            enable: true,
            subName: subName,
            value: val,
            validator: (String? value) => controller.onValidate(
                question.bangDuLieu!,
                question.maCauHoi!,
                question.maCauHoi,
                value,
                question.giaTriNN,
                question.giaTriLN,
                question.loaiCauHoi!,
                true),
            flteringTextInputFormatterRegExp: wFilterInput,
          ),
          if (question.danhSachCauHoiCon!.isNotEmpty)
            Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: greyDarkBorder, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                child: _buildQuestion3(question))
        ],
      );
    });
    //  });
  }

  // _questionSubType2(QuestionCommonModel question,
  //     {QuestionCommonModel? parentQuestion}) {
  //   switch (question.loaiCauHoi) {
  //     case 1:
  //       if (question.bangChiTieu == '2') {
  //         // return _renderChiTieuDongCotType1(question);
  //       } else {
  //         return _renderQuestionType1(question);
  //       }

  //     case 2:
  //       return _renderQuestionType2(question);
  //     case 3:
  //       return _renderQuestionType3(question);
  //     case 4:
  //       return _renderQuestionType4(question);
  //     case 5:
  //       if (question.bangChiTieu == tableDmDanToc) {
  //         return buildDmDanToc(question);
  //       } else {
  //         return _renderQuestionType5Dm(question);
  //       }
  //     default:
  //       return Container();
  //   }
  // }

  _renderQuestionType3(
    QuestionCommonModel question, {
    String? subName,
    ProductModel? product,
  }) {
    if (question.maCauHoi == columnPhieuMauA3_2_0 ||
        question.maCauHoi == columnPhieuMauA3_0 ||
        question.maCauHoi == columnPhieuMauA4_0) {
      return Obx(() {
        var valA32 = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);

        return InputIntView(
          key: ValueKey('${question.cauHoiUUID}_$valA32'),
          question: question,
          onChange: (value) => {},
          value: valA32,
          enable: false,
          type: "double",
          txtStyle: styleMediumBold.copyWith(color: primaryColor),
          decimalDigits: 2,
        );
      });
    }
    var val = controller.getValueByFieldName(
        question.bangDuLieu!, question.maCauHoi!);
    var wFilterInput = RegExp('[0-9]');
    int decimalDigits = 0;
    if (question.maCauHoi == "A6_5" ||
        question.maCauHoi == "A6_11" ||
        question.maCauHoi == "A6_12" ||
        question.maCauHoi == "A7_9" ||
        question.maCauHoi == "A9_5" ||
        question.maCauHoi == "A9_6" ||
        question.maCauHoi == "A9_8") {
      wFilterInput = RegExp(r'(^\d*\.?\d{0,2})');
      decimalDigits = 2;
    }
    if (question.maCauHoi == columnPhieuMauA3_3_1) {
      decimalDigits = 2;
      return Obx(() {
        var a3_3Value = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuMauA3_3);
        return InputInt(
          key: ValueKey('${question.cauHoiUUID}'),
          question: question,
          onChange: (value) => controller.onChangeInput(question.bangDuLieu!,
              question.maCauHoi, question.maCauHoi, value),
          subName: subName,
          value: val,
          type: 'double',
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
        );
      });
    } else if (question.maCauHoi == columnPhieuMauA4_2) {
      controller.warningA4_2DoanhThu();
      decimalDigits = 2;
      return Obx(() {
        var a4_2Value = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuMauA4_2);
        return InputInt(
          key: ValueKey('${question.cauHoiUUID}'),
          question: question,
          onChange: (value) => controller.onChangeInput(question.bangDuLieu!,
              question.maCauHoi, question.maCauHoi, value),
          subName: subName,
          value: a4_2Value,
          type: 'double',
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
          warningText: (controller.warningA4_2.value != '')
              ? controller.warningA4_2.value
              : '',
        );
      });
    } else if (question.maCauHoi == columnPhieuMauA4_6) {
      decimalDigits = 2;
      controller.warningA4_6TienThueDiaDiem();
      return Obx(() {
        var a4_6Value = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuMauA4_6);
        return InputInt(
          key: ValueKey('${question.cauHoiUUID}'),
          question: question,
          onChange: (value) => controller.onChangeInput(question.bangDuLieu!,
              question.maCauHoi, question.maCauHoi, value),
          subName: subName,
          value: a4_6Value,
          type: 'double',
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
          warningText: (controller.warningA4_6.value != '')
              ? controller.warningA4_6.value
              : '',
        );
      });
    }

    if (question.maCauHoi == columnPhieuMauA6_7 ||
        question.maCauHoi == columnPhieuMauA7_11 ||
        question.maCauHoi == columnPhieuMauA7_13 ||
        question.maCauHoi == columnPhieuMauA6_13 ||
        question.maCauHoi == columnPhieuMauA6_14 ||
        question.maCauHoi == columnPhieuMauA7_10) {
      return Obx(() {
        var valA = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);
        return InputInt(
          key: ValueKey('${question.maCauHoi}${question.cauHoiUUID}_$valA'),
          question: question,
          onChange: (value) => (),
          enable: false,
          subName: subName,
          value: valA,
          type: "double",
          txtStyle: styleMediumBold.copyWith(color: primaryColor),
          decimalDigits: 2,
        );
      });
    }
    // if (question.maCauHoi == columnPhieuMauA7_11 ||
    //     question.maCauHoi == columnPhieuMauA7_13) {
    //   return Obx(() {
    //     var valA = controller.getValueByFieldName(
    //         question.bangDuLieu!, question.maCauHoi!);
    //     return InputString(
    //       key: ValueKey('${question.maCauHoi}${question.cauHoiUUID}_$valA'),
    //       question: question,
    //       onChange: (value) => (),
    //       enable: false,
    //       subName: subName,
    //       value: valA,

    //     );
    //   });
    // }
    if (question.maCauHoi == columnPhieuMauA9_5) {
      return Obx(() {
        var a9_4_1Value = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuMauA9_4_1);
        var val9_5 = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);
        // var a9_8Value = controller.getValueByFieldName(
        //     question.bangDuLieu!, columnPhieuMauA9_8);
        if (a9_4_1Value != 1) {
          return const SizedBox();
        }
        return InputInt(
          key: ValueKey(
              '${question.cauHoiUUID}_${question.cauHoiUUID}$a9_4_1Value'),
          question: question,
          onChange: (value) => controller.onChangeInput(question.bangDuLieu!,
              question.maCauHoi, question.maCauHoi, value),
          subName: subName,
          value: val9_5,
          type: 'double',
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
        );
      });
    }
    if (question.maCauHoi == columnPhieuMauA9_7_1) {
      decimalDigits = 2;
      return Obx(() {
        var a9_7Value = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuMauA9_7);
        // var a9_8Value = controller.getValueByFieldName(
        //     question.bangDuLieu!, columnPhieuMauA9_8);
        if (a9_7Value != 1) {
          return const SizedBox();
        }
        return InputInt(
          key: ValueKey('${question.cauHoiUUID}_$a9_7Value'),
          question: question,
          onChange: (value) => controller.onChangeInput(question.bangDuLieu!,
              question.maCauHoi, question.maCauHoi, value),
          subName: subName,
          value: val,
          type: 'double',
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
        );
      });
    }
    if (question.maCauHoi == columnPhieuMauA9_8) {
      return Obx(() {
        var a9_4_2Value = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuMauA9_4_2);
        var a9_7Value = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuMauA9_7);
        var a9_8Value = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuMauA9_8);
        if (a9_4_2Value != 1 ) {
          return const SizedBox();
        }
        return InputInt(
          key: ValueKey('${question.cauHoiUUID}_$a9_4_2Value'),
          question: question,
          onChange: (value) => controller.onChangeInput(question.bangDuLieu!,
              question.maCauHoi, question.maCauHoi, value),
          subName: subName,
          value: a9_8Value,
          type: 'double',
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
        );
      });
    }
    if (question.maCauHoi == columnPhieuMauA9_10) {
      decimalDigits = 2;
      return Obx(() {
        var a9_9Value = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuMauA9_9);
        // var a9_8Value = controller.getValueByFieldName(
        //     question.bangDuLieu!, columnPhieuMauA9_8);
        if (a9_9Value != 1) {
          return const SizedBox();
        }
        return InputInt(
          key: ValueKey('${question.cauHoiUUID}_$a9_9Value'),
          question: question,
          onChange: (value) => controller.onChangeInput(question.bangDuLieu!,
              question.maCauHoi, question.maCauHoi, value),
          subName: subName,
          value: val,
          type: 'double',
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
        );
      });
    }
    if (question.maCauHoi == columnPhieuMauA6_5) {
      controller.warningA6_5SoKmBQ();
      return Obx(() {
        var a6_5Value = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuMauA6_5);
        return InputInt(
          key: ValueKey(
              '${question.maPhieu}-${question.maCauHoi}-${question.sTT}'),
          question: question,
          onChange: (value) => controller.onChangeInput(question.bangDuLieu!,
              question.maCauHoi, question.maCauHoi, value),
          subName: subName,
          value: a6_5Value,
          type: 'double',
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
          warningText: (controller.warningA6_5.value != '')
              ? controller.warningA6_5.value
              : '',
        );
      });
    }
    if (question.maCauHoi == columnPhieuMauA6_11) {
      controller.warningA6_11KhoiLuongHHBQ();
      return Obx(() {
        var a6_11Value = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuMauA6_11);
        return InputInt(
          key: ValueKey(
              '${question.maPhieu}-${question.maCauHoi}-${question.sTT}'),
          question: question,
          onChange: (value) => controller.onChangeInput(question.bangDuLieu!,
              question.maCauHoi, question.maCauHoi, value),
          subName: subName,
          value: a6_11Value,
          type: 'double',
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
          warningText: (controller.warningA6_11.value != '')
              ? controller.warningA6_11.value
              : '',
        );
      });
    }
    if (question.maCauHoi == columnPhieuMauA6_12) {
      controller.warningA6_12SoKmBQ();
      return Obx(() {
        var a6_12Value = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuMauA6_12);
        return InputInt(
          key: ValueKey(
              '${question.maPhieu}-${question.maCauHoi}-${question.sTT}'),
          question: question,
          onChange: (value) => controller.onChangeInput(question.bangDuLieu!,
              question.maCauHoi, question.maCauHoi, value),
          subName: subName,
          value: a6_12Value,
          type: 'double',
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
          warningText: (controller.warningA6_12.value != '')
              ? controller.warningA6_12.value
              : '',
        );
      });
    }
    decimalDigits = 2;
    return InputInt(
      key: ValueKey('${question.maPhieu}-${question.maCauHoi}-${question.sTT}'),
      question: question,
      onChange: (value) => controller.onChangeInput(
          question.bangDuLieu!, question.maCauHoi, question.maCauHoi, value),
      subName: subName,
      value: val,
      type: 'double',
      validator: (String? value) => controller.onValidate(
          question.bangDuLieu!,
          question.maCauHoi!,
          question.maCauHoi,
          value,
          question.giaTriNN,
          question.giaTriLN,
          question.loaiCauHoi!,
          true),
      flteringTextInputFormatterRegExp: wFilterInput,
      decimalDigits: decimalDigits,
    );
    // }
  }

  _renderQuestionType4(QuestionCommonModel question, {String? subName}) {
    if (question.maCauHoi == columnPhieuMauA1_1) {
      return Obx(() {
        var a1_1val = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);

        return InputString(
          key: ValueKey(question.maCauHoi),
          onChange: (value) => controller.onChangeInput(question.bangDuLieu!,
              question.maCauHoi, question.maCauHoi, value),
          question: question,
          subName: subName,
          value: a1_1val,
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true),
          warningText: (controller.warningA1_1.value != '')
              ? controller.warningA1_1.value
              : '',
        );
      });
    }
    var resVal = controller.getValueByFieldName(
        question.bangDuLieu!, question.maCauHoi!);

    return InputString(
      key: ValueKey(question.maCauHoi),
      onChange: (value) => controller.onChangeInput(
          question.bangDuLieu!, question.maCauHoi, question.maCauHoi, value),
      question: question,
      subName: subName,
      value: resVal,
      validator: (String? value) => controller.onValidate(
          question.bangDuLieu!,
          question.maCauHoi!,
          question.maCauHoi,
          value,
          question.giaTriNN,
          question.giaTriLN,
          question.loaiCauHoi!,
          true),
    );
  }

  // renderThongTinNguoiDungDau(QuestionCommonModel question, {String? subName}) {
  //   if (question.danhSachCauHoiCon != null) {
  //     List<QuestionCommonModel> questionsCon = question.danhSachCauHoiCon!;
  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         RichTextQuestion(question.tenCauHoi ?? '', level: question.cap!),
  //         Container(
  //             margin: const EdgeInsets.fromLTRB(
  //                 0.0, 0.0, 0.0, AppValues.marginBottomBox),
  //             padding: const EdgeInsets.all(AppValues.paddingBox),
  //             decoration: BoxDecoration(
  //                 border: Border.all(color: greyDarkBorder, width: 1),
  //                 borderRadius: const BorderRadius.all(Radius.circular(5.0)),
  //                 color: Colors.white),
  //             child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   ListView.builder(
  //                       itemCount: questionsCon.length,
  //                       physics: const NeverScrollableScrollPhysics(),
  //                       shrinkWrap: true,
  //                       itemBuilder: (_, index) {
  //                         QuestionCommonModel questionItem =
  //                             questionsCon[index];
  //                         return _questionItemNguoiDungDau(questionItem,
  //                             parentQuestion: question);
  //                       })
  //                 ]))
  //       ],
  //     );
  //   }
  //   return RichTextQuestion(
  //       controller.questions[controller.questionIndex.value].tenCauHoi ?? '',
  //       level: controller.questions[controller.questionIndex.value].cap!,
  //       notes: controller.questions[controller.questionIndex.value].giaiThich ??
  //           '');
  // }

  // _questionItemNguoiDungDau(QuestionCommonModel question,
  //     {QuestionCommonModel? parentQuestion}) {
  //   switch (question.loaiCauHoi) {
  //     case 1:
  //       if (question.bangChiTieu == '2') {
  //         // return _renderChiTieuDongCotType1(question);
  //       } else {
  //         return _renderQuestionType1(question);
  //       }

  //     case 2:
  //       return _renderQuestionType2(question);
  //     case 3:
  //       return _renderQuestionType3(question);
  //     case 4:
  //       return _renderQuestionType4(question);
  //     case 5:
  //       if (question.bangChiTieu == tableDmDanToc) {
  //         return buildDmDanToc(question);
  //       } else {
  //         return _renderQuestionType5Dm(question);
  //       }
  //     default:
  //       return Container();
  //   }
  // }

  buildDmDanToc(QuestionCommonModel question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextQuestion(
          question.tenCauHoi ?? '',
          level: 3,
        ),
        Obx(() {
          var val = controller.getValueDanTocByFieldName(
              question.bangDuLieu!, question.maCauHoi!);

          return SearchDanToc(
            key: ValueKey('${question.maCauHoi}${question.cauHoiUUID}'),
            // listValue: controller.tblDmVsicIO,
            onSearch: (pattern) => controller.onSearchDmDanToc(pattern),
            value: val,

            onChange: (inputValue) => controller.onChangeInputDanToc(
                question.bangDuLieu!,
                question.maCauHoi!,
                question.maCauHoi!,
                inputValue),
            isError: controller.searchResult.value,
            validator: (String? inputValue) => controller.onValidateInputDanToc(
                question.bangDuLieu!,
                question.maCauHoi!,
                question.maCauHoi,
                inputValue,
                question.loaiCauHoi!),
          );
        }),
        const SizedBox(height: 12),
      ],
    );
  }

  _renderQuestionType5Dm(QuestionCommonModel question, {String? subName}) {
    if (question.maCauHoi == "A1_4") {
      return Obx(() {
        var a1_4Val = controller.getValueDmByFieldName(question.maCauHoi!);
        var a1_3val = controller.getValueDmByFieldName("A1_3");
        var dmChiTieu =
            controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];

        return Column(
          children: [
            SelectIntCTDm(
              key: ValueKey(
                  '${question.cauHoiUUID}${question.maCauHoi}$a1_4Val'),
              question: question,
              listValue: dmChiTieu,
              tenDanhMuc: question.bangChiTieu,
              onChange: (value, dmItem) => controller.onSelectDm(
                  question,
                  question.bangDuLieu!,
                  question.maCauHoi,
                  question.maCauHoi,
                  value,
                  dmItem),
              value: a1_4Val,
            ),
            buildWarningText(question, a1_4Val)
          ],
        );
      });
    } else if (question.maCauHoi == columnPhieuMauA1_5_6) {
      return Obx(() {
        var a1_5_6Val = controller.getValueDmByFieldName(question.maCauHoi!);
        //  var a1_5_3val = controller.getValueDmByFieldName("A1_5_3");
        var dmChiTieu =
            controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];

        return Column(
          children: [
            SelectIntCTDm(
              key: ValueKey(
                  '${question.cauHoiUUID}${question.maCauHoi}$a1_5_6Val'),
              question: question,
              listValue: dmChiTieu,
              tenDanhMuc: question.bangChiTieu,
              onChange: (value, dmItem) => controller.onSelectDm(
                  question,
                  question.bangDuLieu!,
                  question.maCauHoi,
                  question.maCauHoi,
                  value,
                  dmItem),
              value: a1_5_6Val,
            ),
            buildWarningText(question, a1_5_6Val)
          ],
        );
      });
    }
    if (question.maCauHoi == "A9_1") {
      return Obx(() {
        var val = controller.getValueDm(question);
        var a9_1val = controller.getValueDmByFieldName("A9_1");
        var dmChiTieu =
            controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];

        return Column(
          children: [
            SelectIntCTDm(
              key: ValueKey('${question.cauHoiUUID}${question.maCauHoi}$val'),
              question: question,
              listValue: dmChiTieu,
              tenDanhMuc: question.bangChiTieu,
              onChange: (value, dmItem) => controller.onSelectDm(
                  question,
                  question.bangDuLieu!,
                  question.maCauHoi,
                  question.maCauHoi,
                  value,
                  dmItem),
              value: val,
            ),
            buildWarningText(question, val),
          ],
        );
      });
    }
    if (question.maCauHoi == "A9_2") {
      return Obx(() {
        var val = controller.getValueDm(question);
        var a9_1val = controller.getValueDmByFieldName("A9_1");
        var dmChiTieu =
            controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];
        if (a9_1val != 1) {
          return const SizedBox();
        }
        return Column(
          children: [
            SelectIntCTDm(
              key: ValueKey('${question.cauHoiUUID}${question.maCauHoi}$val'),
              question: question,
              listValue: dmChiTieu,
              tenDanhMuc: question.bangChiTieu,
              onChange: (value, dmItem) => controller.onSelectDm(
                  question,
                  question.bangDuLieu!,
                  question.maCauHoi,
                  question.maCauHoi,
                  value,
                  dmItem),
              value: val,
              titleGhiRoText: 'Ghi rõ',
              onChangeGhiRo: (value, dmItem) =>
                  controller.onChangeGhiRoDm(question, value, dmItem),
            ),
            buildGhiRo(question, val),
          ],
        );
      });
    }

    return Obx(() {
      var val = controller.getValueDm(question);
      var dmChiTieu =
          controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];
      return Column(
        children: [
          SelectIntCTDm(
            key: ValueKey('${question.cauHoiUUID}${question.maCauHoi}$val'),
            question: question,
            listValue: dmChiTieu,
            tenDanhMuc: question.bangChiTieu,
            onChange: (value, dmItem) => controller.onSelectDm(
                question,
                question.bangDuLieu!,
                question.maCauHoi,
                question.maCauHoi,
                value,
                dmItem),
            value: val,
            titleGhiRoText: 'Ghi rõ',
            onChangeGhiRo: (value, dmItem) =>
                controller.onChangeGhiRoDm(question, value, dmItem),
          ),
          buildGhiRo(question, val),
          if (question.danhSachCauHoiCon != null &&
              question.danhSachCauHoiCon!.isNotEmpty)
            _buildQuestion3(question)
        ],
      );
    });
  }

  buildQuestionA6_1(QuestionCommonModel question, {String? subName}) {
    return Obx(() {
      var val = controller.getValueDm(question);
      var dmChiTieu =
          controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];
      return Column(
        children: [
          SelectStringCTDm(
            key: ValueKey('${question.cauHoiUUID}${question.maCauHoi}$val'),
            question: question,
            listValue: dmChiTieu,
            tenDanhMuc: question.bangChiTieu,
            onChangeSelectStringDm: (value, dmItem) => controller.onSelectDm(
                question,
                question.bangDuLieu!,
                question.maCauHoi,
                question.maCauHoi,
                value,
                dmItem),
            value: val,
            titleGhiRoText: 'Ghi rõ',
            onChangeSelectStringDmGhiRo: (value, dmItem) =>
                controller.onChangeGhiRoDm(question, value, dmItem),
          ),
          buildGhiRo(question, val),
        ],
      );
    });
  }

  buildGhiRo(QuestionCommonModel question, selectedValue) {
    if ((selectedValue == 5 && question.bangChiTieu == tableCTDmDiaDiemSXKD)) {
      var ghiRoValue = controller.getValueByFieldName(
          question.bangDuLieu!, '${question.maCauHoi}_GhiRo');
      var fieldNameGhiRo = '${question.maCauHoi}_GhiRo';
      return InputStringCTDm(
        key: ValueKey('${question.cauHoiUUID}${question.maCauHoi}'),
        question: question,
        onChange: (value) => controller.onChangeGhiRoDm(question, value, null),
        titleText: 'Ghi rõ',
        level: 3,
        value: ghiRoValue,
        validator: (inputValue) => controller.onValidate(question.bangDuLieu!,
            question.maCauHoi!, fieldNameGhiRo, inputValue, 5, 250, 4, true),
      );
    } else if ((selectedValue == 1 &&
        question.bangChiTieu == tableDmCoKhong &&
        question.maCauHoi == "A1_7")) {
      var ghiRoValue = controller.getValueByFieldName(
          question.bangDuLieu!, '${question.maCauHoi}_1');
      var fieldNameGhiRo = '${question.maCauHoi}_1';
      return InputStringCTDm(
        key: ValueKey('${question.cauHoiUUID}${question.maCauHoi}'),
        question: question,
        onChange: (value) => controller.onChangeGhiRoDm(question, value, null,
            fieldNameGhiRo: fieldNameGhiRo),
        titleText: 'Mã số thuế',
        level: 3,
        value: ghiRoValue,
        validator: (inputValue) => controller.onValidate(question.bangDuLieu!,
            question.maCauHoi!, fieldNameGhiRo, inputValue, 5, 250, 4, true),
      );
    }
    return const SizedBox();
  }

  ///BEGIN::  Build cho A43; Dành cho các câu chỉ có chi tiêu cột, thêm mới dòng bằng nút Thêm mới
  buildOnlyQuestionChiTieuCot(QuestionCommonModel mainQuestion,
      {ProductModel? product, QuestionCommonModel? parentQuestion}) {
    var chiTieus = mainQuestion.danhSachChiTieu ?? [];

    dynamic recordList = [];
    if (mainQuestion.maCauHoi == 'A6_1') {
      recordList = controller.tblPhieuMauA61;
    } else if (mainQuestion.maCauHoi == 'A6_8') {
      recordList = controller.tblPhieuMauA68;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (recordList.isNotEmpty)
          ListView.builder(
              itemCount: recordList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, indexsp) {
                var recordListItem = recordList[indexsp];
                return buildOnlyChiTieuCotItem(
                    mainQuestion, chiTieus, recordListItem);
              })
        else
          const Text('Chưa có loại phương tiện.',
              style: TextStyle(color: errorColor)),
        //    buildOnlyChiTieuCotItem(
        //       mainQuestion, chiTieus, null),
        const SizedBox(
          height: 1.0,
        ),

        ///if (recordList.isNotEmpty)
        Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add_outlined),
              label: const Text("Thêm loại phương tiện"),
              onPressed: () => controller.addNewRowPhieuMauAA6_1(
                  mainQuestion.bangDuLieu!, mainQuestion.maCauHoi!),
              style: ElevatedButton.styleFrom(
                  side: const BorderSide(width: 1.0, color: primaryLightColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppValues.borderLv5),
                  ),
                  foregroundColor: primaryColor),
            )),
        const SizedBox(
          height: 10.0,
        ),
        _buildQuestion2(mainQuestion)
      ],
    );
  }

  buildOnlyChiTieuCotItem(QuestionCommonModel mainQuestion,
      List<ChiTieuModel> chiTieus, dynamic recordValue) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: <Widget>[
            Container(
                margin:
                    const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, AppValues.padding),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: greyDarkBorder, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Column(
                  children: [
                    ListView.builder(
                        itemCount: chiTieus.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          ChiTieuModel chitieu = chiTieus[index];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              renderOnlyChiTieuCotQuestionByType(
                                  mainQuestion, chitieu,
                                  recordValue: recordValue)
                            ],
                          );
                        }),
                  ],
                )),
            if (recordValue != null)
              Positioned(
                top: 10.0,
                right: 15.0,
                child: ElevatedButton(
                    onPressed: () {
                      controller.deleteA61Item(mainQuestion.bangDuLieu!,
                          mainQuestion.maCauHoi!, recordValue);
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red,
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppValues.borderLv5)),
                        elevation: 1.0,
                        side: const BorderSide(color: Colors.red)),
                    child: const Text('Xoá')),
              ),
          ])
        ]);
  }

  renderOnlyChiTieuCotQuestionByType(
      QuestionCommonModel mainQuestion, ChiTieuModel chiTieuCot,
      {String? subName, dynamic recordValue}) {
    var val = null;
    var idValue = null;
    var fieldName = '';
    int maxLen = 0;
    int minLen = 0;
    var maxValue;
    var minValue;
    int? stt;

    if (recordValue is TablePhieuMauA61) {
      TablePhieuMauA61 tablePhieuA61 = recordValue;
      fieldName = '${chiTieuCot.maCauHoi}_${chiTieuCot.maChiTieu}';
      //if(fieldName)
      idValue = tablePhieuA61.id;

      if (fieldName == columnSTT) {
        val.value = tablePhieuA61.sTT;
        maxLen = chiTieuCot.giaTriLN != null
            ? chiTieuCot.giaTriLN!.toInt().toString().length
            : 3;
        minLen = chiTieuCot.giaTriNN != null
            ? chiTieuCot.giaTriNN!.toInt().toString().length
            : 1;
        maxValue =
            chiTieuCot.giaTriLN != null ? chiTieuCot.giaTriLN!.toInt() : 100;
        minValue =
            chiTieuCot.giaTriNN != null ? chiTieuCot.giaTriNN!.toInt() : 1;
      } else if (fieldName == columnPhieuMauA61A6_1_0) {
        val = tablePhieuA61.a_6_1_0;
        maxLen = chiTieuCot.giaTriLN != null
            ? chiTieuCot.giaTriLN!.toInt().toString().length
            : 255;
        minLen = chiTieuCot.giaTriNN != null
            ? chiTieuCot.giaTriNN!.toInt().toString().length
            : 1;
      } else if (fieldName == columnPhieuMauA61A6_1_1) {
        val = tablePhieuA61.a_6_1_1;

        maxValue =
            chiTieuCot.giaTriLN != null ? chiTieuCot.giaTriLN! : 99999999;
        minValue = chiTieuCot.giaTriNN != null ? chiTieuCot.giaTriNN! : 0;
      } else if (fieldName == columnPhieuMauA61A6_1_2) {
        val = tablePhieuA61.a_6_1_2;
        maxValue =
            chiTieuCot.giaTriLN != null ? chiTieuCot.giaTriLN! : 99999999;
        minValue = chiTieuCot.giaTriNN != null ? chiTieuCot.giaTriNN! : 0;
      } else if (fieldName == columnPhieuMauA61A6_1_3) {
        val = tablePhieuA61.a_6_1_3;
      }
    } else if (recordValue is TablePhieuMauA68) {
      TablePhieuMauA68 tablePhieuA68 = recordValue;
      fieldName = '${chiTieuCot.maCauHoi}_${chiTieuCot.maChiTieu}';
      //if(fieldName)
      idValue = tablePhieuA68.id;

      if (fieldName == columnSTT) {
        val = tablePhieuA68.sTT;
        maxLen = chiTieuCot.giaTriLN != null
            ? chiTieuCot.giaTriLN!.toInt().toString().length
            : 3;
        minLen = chiTieuCot.giaTriNN != null
            ? chiTieuCot.giaTriNN!.toInt().toString().length
            : 1;
        maxValue =
            chiTieuCot.giaTriLN != null ? chiTieuCot.giaTriLN!.toInt() : 100;
        minValue =
            chiTieuCot.giaTriNN != null ? chiTieuCot.giaTriNN!.toInt() : 1;
      } else if (fieldName == columnPhieuMauA68A6_8_0) {
        val = tablePhieuA68.a6_8_0;
        maxLen = chiTieuCot.giaTriLN != null
            ? chiTieuCot.giaTriLN!.toInt().toString().length
            : 255;
        minLen = chiTieuCot.giaTriNN != null
            ? chiTieuCot.giaTriNN!.toInt().toString().length
            : 1;
      } else if (fieldName == columnPhieuMauA68A6_8_1) {
        val = tablePhieuA68.a6_8_1;

        maxValue =
            chiTieuCot.giaTriLN != null ? chiTieuCot.giaTriLN! : 99999999;
        minValue = chiTieuCot.giaTriNN != null ? chiTieuCot.giaTriNN! : 0;
      } else if (fieldName == columnPhieuMauA68A6_8_2) {
        val = tablePhieuA68.a6_8_2;
        maxValue =
            chiTieuCot.giaTriLN != null ? chiTieuCot.giaTriLN! : 99999999;
        minValue = chiTieuCot.giaTriNN != null ? chiTieuCot.giaTriNN! : 0;
      } else if (fieldName == columnPhieuMauA68A6_8_3) {
        val = tablePhieuA68.a6_8_3;
      }
    }
    switch (chiTieuCot.loaiCauHoi) {
      case 2:
        var wFilterInput = RegExp('[0-9]');

        if ((mainQuestion.maCauHoi == "A6_1") &&
            fieldName == columnPhieuMauA61A6_1_3 &&
            chiTieuCot.maChiTieu == '3') {
          return Obx(() {
            var totalValA6_1_3 = controller.getValueByFieldNameStt(
                mainQuestion.bangDuLieu!, fieldName, idValue);
            return InputIntChiTieu(
              key: ValueKey(
                  '${mainQuestion.cauHoiUUID}_${chiTieuCot.maCauHoi}_${chiTieuCot.maChiTieu}_${chiTieuCot.sTT}_${idValue!}_$totalValA6_1_3'),
              onChange: (value) => (),
              chiTieuCot: chiTieuCot,
              value: totalValA6_1_3,
              enable: false,
              txtStyle: styleMediumBold.copyWith(color: primaryColor),
            );
          });
        }
        return InputIntChiTieu(
          key: ValueKey(
              '${chiTieuCot.maPhieu}-${chiTieuCot.maCauHoi}-${chiTieuCot.maChiTieu}-${chiTieuCot.sTT}-${idValue!}'),
          onChange: (value) => controller.onChangeInputA6_1(
              mainQuestion.bangDuLieu!,
              mainQuestion.maCauHoi!,
              fieldName,
              idValue,
              value),
          chiTieuCot: chiTieuCot,
          subName: subName,
          value: val,
          enable: chiTieuCot.tenChiTieu == "STT" ? false : true,
          validator: (String? inputValue) => controller.onValidateInputA6_1(
              mainQuestion.bangDuLieu!,
              mainQuestion.maCauHoi!,
              fieldName,
              idValue,
              inputValue,
              minLen,
              maxLen,
              minValue,
              maxValue,
              chiTieuCot.loaiCauHoi!),
          flteringTextInputFormatterRegExp: wFilterInput,
        );
      case 3:
        var wFilterInput = RegExp(r'(^\d*\.?\d{0,2})'); // RegExp('[0-9]');
        int decimalDigits = 2;
        if ((mainQuestion.maCauHoi == "A6_8") &&
            fieldName == columnPhieuMauA68A6_8_3 &&
            chiTieuCot.maChiTieu == '3') {
          return Obx(() {
            var totalValA6_8_3 = controller.getValueByFieldNameStt(
                mainQuestion.bangDuLieu!, fieldName, idValue);
            return InputIntChiTieu(
              key: ValueKey(
                  '${mainQuestion.cauHoiUUID}_${chiTieuCot.maCauHoi}_${chiTieuCot.maChiTieu}-${chiTieuCot.sTT}-${idValue!}_$totalValA6_8_3'),
              onChange: (value) => (),
              chiTieuCot: chiTieuCot,
              value: val,
              enable: false,
              type: "double",
              decimalDigits: decimalDigits,
              txtStyle: styleMediumBold.copyWith(color: primaryColor),
              
            );
          });
        }
        return InputIntChiTieu(
          key: ValueKey(
              '${chiTieuCot.maPhieu}-${chiTieuCot.maCauHoi}-${chiTieuCot.maChiTieu}-${chiTieuCot.sTT}-${idValue!}'),
          onChange: (value) => controller.onChangeInputA6_1(
              mainQuestion.bangDuLieu!,
              mainQuestion.maCauHoi!,
              fieldName,
              idValue,
              value),
          chiTieuCot: chiTieuCot,
          subName: subName,
          type: "double",
          value: controller.getDoubleValue(val, "double"),
          enable: (chiTieuCot.tenChiTieu == "STT") ? false : true,
          validator: (inputValue) => controller.onValidateInputA6_1(
              mainQuestion.bangDuLieu!,
              mainQuestion.maCauHoi!,
              fieldName,
              idValue,
              inputValue,
              minLen,
              maxLen,
              minValue,
              maxValue,
              chiTieuCot.loaiCauHoi!),
          flteringTextInputFormatterRegExp: wFilterInput,
        );

      case 4:
        return InputStringChiTieuCT(
          key: ValueKey(
              '${chiTieuCot.maPhieu}-${chiTieuCot.maCauHoi}-${chiTieuCot.maChiTieu}-${chiTieuCot.sTT}-${idValue!}'),
          onChange: (inputValue) => controller.onChangeInputA6_1(
              mainQuestion.bangDuLieu!,
              mainQuestion.maCauHoi!,
              fieldName,
              idValue,
              inputValue),
          chiTieuCot: chiTieuCot,
          subName: subName,
          value: val,
          maxLen: maxLen,
          maxLine: 3,
          validator: (String? inputValue) => controller.onValidateInputA6_1(
              mainQuestion.bangDuLieu!,
              mainQuestion.maCauHoi!,
              fieldName,
              idValue,
              inputValue,
              minLen,
              maxLen,
              minValue,
              maxValue,
              chiTieuCot.loaiCauHoi!),
        );
      case 5:

      //  case 6:
      //return _renderQuestionType6(question);
      // case 7:
      //   return _renderQuestionType7(question);

      default:
        return Container();
    }
  }

  ///END:: Build cho A43
  /******/
  ///BEGIN:: Build câu vừa có chỉ tiêu dòng và chỉ tiêu cột
  buildQuestionChiTieuDongCot(QuestionCommonModel mainQuestion,
      {ProductModel? product, QuestionCommonModel? parentQuestion}) {
    var chiTieuCots = mainQuestion.danhSachChiTieu ?? [];
    var chiTieuDongs = mainQuestion.danhSachChiTieuIO ?? [];
    chiTieuCots.retainWhere((x) {
      return x.loaiCauHoi != null;
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichTextQuestion(mainQuestion.tenCauHoi ?? '',
            level: mainQuestion.cap ?? 3),
        ListView.builder(
            key: ObjectKey(chiTieuCots),
            itemCount: chiTieuDongs.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_, indexIO) {
              ChiTieuDongModel chiTieuDong = chiTieuDongs[indexIO];
              if (mainQuestion.maCauHoi == "A8_1" &&
                  (chiTieuDong.maSo == '3.1' || chiTieuDong.maSo == '5.1')) {
                return buildChiTieuDongCotItemA3_1VsA5_1(
                    mainQuestion, chiTieuDong, chiTieuCots);
              }
              if (mainQuestion.maCauHoi == 'A9_4') {
                return buildChiTieuDongCotItemA9_4(mainQuestion, chiTieuDong);
              } else {
                return buildChiTieuDongCotItem(
                    mainQuestion, chiTieuDong, chiTieuCots);
              }
            })
      ],
    );
  }

  buildChiTieuDongCotItem(QuestionCommonModel mainQuestion,
      ChiTieuDongModel chiTieuDong, List<ChiTieuModel> chiTieuCots) {
    ///Không build chỉ tiêu này; => Để kiểm tra ngành là H thì mới build sau
    // if (mainQuestion.maCauHoi == "A8_1" &&
    //     (chiTieuDong.maSo == "3.1" || chiTieuDong.maSo == "5.1")) {
    //   return const SizedBox();
    // }
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((chiTieuDong.maSo == '0' && chiTieuDong.maCauHoi == 'A4_7'))
            RichTextQuestionChiTieu(
              chiTieuDong.tenChiTieu ?? '',
              level: 2,
            )
          else
            RichTextQuestionChiTieu(
              chiTieuDong.tenChiTieu ?? '',
              prefixText: chiTieuDong.maSo,
              seperateSign: ' - ',
              level: 3,
            ),
          Container(
              margin: const EdgeInsets.fromLTRB(
                  0.0, 0.0, 0.0, AppValues.marginBottomBox),
              padding: const EdgeInsets.all(AppValues.paddingBox),
              decoration: BoxDecoration(
                  border: Border.all(color: greyDarkBorder, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  color: chiTieuDong.loaiCauHoi == AppDefine.loaiCauHoi_9
                      ? greyDarkBorder2
                      : Colors.white),
              child: Column(
                children: [
                  ListView.builder(
                      key: ObjectKey(chiTieuDong),
                      itemCount: chiTieuCots.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        ChiTieuModel chitieuCot = chiTieuCots[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (chitieuCot.loaiChiTieu.toString() ==
                                AppDefine.loaiChiTieu_1)
                              renderChiTieuDongCotQuestionByType(
                                  mainQuestion, chiTieuDong, chitieuCot)
                            else
                              const SizedBox(),
                          ],
                        );
                      }),
                ],
              )),
        ]);
  }

  buildChiTieuDongCotItemA9_4(
      QuestionCommonModel mainQuestion, ChiTieuDongModel chiTieuDong) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichTextQuestionChiTieu(
            chiTieuDong.tenChiTieu ?? '',
            prefixText: chiTieuDong.maSo,
            seperateSign: ' - ',
            level: 3,
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(
                  0.0, 0.0, 0.0, AppValues.marginBottomBox),
              padding: const EdgeInsets.all(AppValues.paddingBox),
              decoration: BoxDecoration(
                  border: Border.all(color: greyDarkBorder, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  color: chiTieuDong.loaiCauHoi == AppDefine.loaiCauHoi_9
                      ? greyDarkBorder2
                      : Colors.white),
              child: Column(
                children: [
                  renderQuestionType5DmChiTieuDongCotA9_4(
                      mainQuestion, chiTieuDong, tableDmCoKhong)
                ],
              )),
        ]);
  }

  buildChiTieuDongCotItemA3_1VsA5_1(QuestionCommonModel mainQuestion,
      ChiTieuDongModel chiTieuDong, List<ChiTieuModel> chiTieuCots) {
    ///Không build chỉ tiêu này; => Để kiểm tra ngành là H thì mới build sau
    // if (mainQuestion.maCauHoi == "A8_1" &&
    //     (chiTieuDong.maSo == "3.1" || chiTieuDong.maSo == "5.1")) {
    //   return const SizedBox();
    // }
    if (chiTieuDong.maCauHoi == 'A8_1') {
      return Obx(() {
        var a8_1_3Value =
            controller.getValueDmByFieldName(columnPhieuMauA8_1_3_1);
        var a8_1_5Value =
            controller.getValueDmByFieldName(columnPhieuMauA8_1_5_1);
        if (chiTieuDong.maSo == '3.1') {
          // if (a8_1_3Value == 1) {
          //   return Column(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         RichTextQuestionChiTieu(
          //           key: ValueKey(
          //               '${mainQuestion.maCauHoi}_${chiTieuDong.maSo}_$a8_1_3Value'),
          //           chiTieuDong.tenChiTieu ?? '',
          //           prefixText: chiTieuDong.maSo,
          //           seperateSign: ' - ',
          //           level: 3,
          //         ),
          //         Container(
          //             margin: const EdgeInsets.fromLTRB(
          //                 0.0, 0.0, 0.0, AppValues.marginBottomBox),
          //             padding: const EdgeInsets.all(AppValues.paddingBox),
          //             decoration: BoxDecoration(
          //                 border: Border.all(color: greyDarkBorder, width: 1),
          //                 borderRadius:
          //                     const BorderRadius.all(Radius.circular(5.0)),
          //                 color:
          //                     chiTieuDong.loaiCauHoi == AppDefine.loaiCauHoi_9
          //                         ? greyDarkBorder2
          //                         : Colors.white),
          //             child: Column(
          //               children: [
          //                 ListView.builder(
          //                     key: ObjectKey(chiTieuDong),
          //                     itemCount: chiTieuCots.length,
          //                     physics: const NeverScrollableScrollPhysics(),
          //                     shrinkWrap: true,
          //                     itemBuilder: (_, index) {
          //                       ChiTieuModel chitieuCot = chiTieuCots[index];
          //                       return Column(
          //                         mainAxisAlignment: MainAxisAlignment.start,
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           if (chitieuCot.loaiChiTieu.toString() ==
          //                               AppDefine.loaiChiTieu_1)
          //                             renderChiTieuDongCotQuestionByType(
          //                                 mainQuestion, chiTieuDong, chitieuCot)
          //                           else
          //                             const SizedBox(),
          //                         ],
          //                       );
          //                     }),
          //               ],
          //             )),
          //       ]);
          // }
          if (controller.isCap1HPhanVI.value == true &&
              (controller.isCap5VanTaiHanhKhachPhanVI.value == true ||
                  controller.isCap5DichVuHangHoaPhanVI.value)) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichTextQuestionChiTieu(
                    key: ValueKey(
                        '${mainQuestion.maCauHoi}_${chiTieuDong.maSo}_$a8_1_3Value'),
                    chiTieuDong.tenChiTieu ?? '',
                    prefixText: chiTieuDong.maSo,
                    seperateSign: ' - ',
                    level: 3,
                  ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(
                          0.0, 0.0, 0.0, AppValues.marginBottomBox),
                      padding: const EdgeInsets.all(AppValues.paddingBox),
                      decoration: BoxDecoration(
                          border: Border.all(color: greyDarkBorder, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          color:
                              chiTieuDong.loaiCauHoi == AppDefine.loaiCauHoi_9
                                  ? greyDarkBorder2
                                  : Colors.white),
                      child: Column(
                        children: [
                          ListView.builder(
                              key: ObjectKey(chiTieuDong),
                              itemCount: chiTieuCots.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (_, index) {
                                ChiTieuModel chitieuCot = chiTieuCots[index];
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (chitieuCot.loaiChiTieu.toString() ==
                                        AppDefine.loaiChiTieu_1)
                                      renderChiTieuDongCotQuestionByType(
                                          mainQuestion, chiTieuDong, chitieuCot)
                                    else
                                      const SizedBox(),
                                  ],
                                );
                              }),
                        ],
                      )),
                ]);
          }
          return const SizedBox();
        } else if (chiTieuDong.maSo == '5.1') {
          // if (a8_1_5Value == 1) {
          //   return Column(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         RichTextQuestionChiTieu(
          //           key: ValueKey(
          //               '${mainQuestion.maCauHoi}_${chiTieuDong.maSo}_$a8_1_3Value'),
          //           chiTieuDong.tenChiTieu ?? '',
          //           prefixText: chiTieuDong.maSo,
          //           seperateSign: ' - ',
          //           level: 3,
          //         ),
          //         Container(
          //             margin: const EdgeInsets.fromLTRB(
          //                 0.0, 0.0, 0.0, AppValues.marginBottomBox),
          //             padding: const EdgeInsets.all(AppValues.paddingBox),
          //             decoration: BoxDecoration(
          //                 border: Border.all(color: greyDarkBorder, width: 1),
          //                 borderRadius:
          //                     const BorderRadius.all(Radius.circular(5.0)),
          //                 color:
          //                     chiTieuDong.loaiCauHoi == AppDefine.loaiCauHoi_9
          //                         ? greyDarkBorder2
          //                         : Colors.white),
          //             child: Column(
          //               children: [
          //                 ListView.builder(
          //                     key: ObjectKey(chiTieuDong),
          //                     itemCount: chiTieuCots.length,
          //                     physics: const NeverScrollableScrollPhysics(),
          //                     shrinkWrap: true,
          //                     itemBuilder: (_, index) {
          //                       ChiTieuModel chitieuCot = chiTieuCots[index];
          //                       return Column(
          //                         mainAxisAlignment: MainAxisAlignment.start,
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           if (chitieuCot.loaiChiTieu.toString() ==
          //                               AppDefine.loaiChiTieu_1)
          //                             renderChiTieuDongCotQuestionByType(
          //                                 mainQuestion, chiTieuDong, chitieuCot)
          //                           else
          //                             const SizedBox(),
          //                         ],
          //                       );
          //                     }),
          //               ],
          //             )),
          //       ]);
          // }
          if (controller.isCap1HPhanVI.value == true &&
              (controller.isCap5VanTaiHanhKhachPhanVI.value == true ||
                  controller.isCap5DichVuHangHoaPhanVI.value)) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichTextQuestionChiTieu(
                    key: ValueKey(
                        '${mainQuestion.maCauHoi}_${chiTieuDong.maSo}_$a8_1_3Value'),
                    chiTieuDong.tenChiTieu ?? '',
                    prefixText: chiTieuDong.maSo,
                    seperateSign: ' - ',
                    level: 3,
                  ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(
                          0.0, 0.0, 0.0, AppValues.marginBottomBox),
                      padding: const EdgeInsets.all(AppValues.paddingBox),
                      decoration: BoxDecoration(
                          border: Border.all(color: greyDarkBorder, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          color:
                              chiTieuDong.loaiCauHoi == AppDefine.loaiCauHoi_9
                                  ? greyDarkBorder2
                                  : Colors.white),
                      child: Column(
                        children: [
                          ListView.builder(
                              key: ObjectKey(chiTieuDong),
                              itemCount: chiTieuCots.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (_, index) {
                                ChiTieuModel chitieuCot = chiTieuCots[index];
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (chitieuCot.loaiChiTieu.toString() ==
                                        AppDefine.loaiChiTieu_1)
                                      renderChiTieuDongCotQuestionByType(
                                          mainQuestion, chiTieuDong, chitieuCot)
                                    else
                                      const SizedBox(),
                                  ],
                                );
                              }),
                        ],
                      )),
                ]);
          }
          return const SizedBox();
        }
        return const SizedBox();
      });
    }
    return const SizedBox();
  }

  renderChiTieuDongCotQuestionByType(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    ///BUILD CAU 9.4
    if (question.maCauHoi == "A9_4") {
      return const SizedBox();
      // return renderQuestionType5DmChiTieuDongCotA9_4(
      //     question, chiTieuDong, chiTieuCot, tableDmCoKhong);
    }
    switch (chiTieuCot.loaiCauHoi) {
      case 2:
        return renderChiTieuDongCotQuestionType2(
            question, chiTieuDong, chiTieuCot);
      case 3:
        return renderChiTieuDongCotQuestionType3(
            question, chiTieuDong, chiTieuCot);
      case 5:
        // if (question.maCauHoi == "A8_1" &&
        //     (chiTieuDong.maSo == "3.1" || chiTieuDong.maSo == "5.1")) {
        //   return const SizedBox();
        // }
        if (question.maCauHoi == "A8_1" &&
            (chiTieuDong.maSo == "3.1" || chiTieuDong.maSo == "5.1")) {
          return const SizedBox();
        }
        return renderQuestionType5DmChiTieuDongCot(
            question, chiTieuDong, chiTieuCot, tableDmCoKhong);
      default:
        return Container();
    }
  }

  // renderChiTieuDongCotQuestionType2(QuestionCommonModel question,
  //     ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
  //     {String? subName, String? value}) {
  //   var fieldNameMaCauHoiMaSo =
  //       controller.getFieldNameByMaCauChiTieuDongCot(chiTieuCot, chiTieuDong)!;
  //   // var wFilterInput = chiTieuCot.maChiTieu == AppDefine.maChiTieu_2
  //   //     ? RegExp(r'(^\d*\.?\d{0,1})')
  //   //     : RegExp('[0-9]');
  //   var wFilterInput = RegExp('[0-9]');

  //   return Obx(() {
  //     var val = controller.getValueByFieldName(
  //         question.bangDuLieu!, fieldNameMaCauHoiMaSo);
  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         InputIntChiTieu(
  //           key: ValueKey(fieldNameMaCauHoiMaSo),
  //           // key: ValueKey<ChiTieuModel>(chiTieuCot),
  //           // key: ValueKey(
  //           //     '${chiTieuCot.maPhieu}-${chiTieuCot.maCauHoi}-${chiTieuDong.maIO}-${chiTieuCot.maChiTieu}-$fieldNameIO'),
  //           type: 'int',
  //           onChange: (value) => controller.onChangeInputChiTieuDongCot(
  //               question.bangDuLieu!,
  //               question.maCauHoi,
  //               fieldNameMaCauHoiMaSo,
  //               value,
  //               question: question,
  //               chiTieuCot: chiTieuCot,
  //               chiTieuDong: chiTieuDong),
  //           chiTieuCot: chiTieuCot,
  //           chiTieuDong: chiTieuDong,
  //           showDvtTheoChiTieuDong: question.buocNhay == 'exit' ? true : false,
  //           subName: subName,
  //           enable: (chiTieuDong.loaiCauHoi == AppDefine.loaiCauHoi_9 ||
  //                   question.buocNhay == 'exit')
  //               ? false
  //               : true,
  //           value: val,
  //           validator: (inputValue) => controller.onValidateInputChiTieuDongCot(
  //               question, chiTieuCot, chiTieuDong, inputValue),
  //           flteringTextInputFormatterRegExp: wFilterInput,
  //         ),
  //       ],
  //     );
  //   });
  // }
  renderChiTieuDongCotQuestionType2(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    var fieldNameMaCauHoiMaSo =
        controller.getFieldNameByMaCauChiTieuDongCot(chiTieuCot, chiTieuDong)!;
    return Obx(() {
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, fieldNameMaCauHoiMaSo);
      if (question.maCauHoi == "A7_1") {
        return renderChiTieuDongCotType2ByMaChiTieu(
            question, chiTieuDong, chiTieuCot,
            value: value);
      }
      return renderChiTieuDongCotType2(question, chiTieuDong, chiTieuCot);
    });
  }

  renderChiTieuDongCotType2ByMaChiTieu(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    var fieldNameMaCauHoiMaSo =
        controller.getFieldNameByMaCauChiTieuDongCot(chiTieuCot, chiTieuDong)!;
    // var wFilterInput = chiTieuCot.maChiTieu == AppDefine.maChiTieu_2
    //     ? RegExp(r'(^\d*\.?\d{0,1})')
    //     : RegExp('[0-9]');
    var wFilterInput = RegExp('[0-9]');

    return Obx(() {
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, fieldNameMaCauHoiMaSo);
      if (question.maCauHoi == "A7_1") {
        var a7_8_x_xFieldName = '${chiTieuDong.maCauHoi}_${chiTieuDong.maSo}_0';
        var a7_8_x_xValue = controller.getValueDmByFieldName(a7_8_x_xFieldName);
        if (a7_8_x_xValue == 1) {
          if (a7_8_x_xFieldName == columnPhieuMauA7_1_5_0) {
            return renderChiTieuDongCotType2(question, chiTieuDong, chiTieuCot);
          }
          return renderChiTieuDongCotType2(question, chiTieuDong, chiTieuCot);
        } else {
          return const SizedBox();
        }
      }
      return renderChiTieuDongCotType2(question, chiTieuDong, chiTieuCot);
    });
  }

  buildGhiRoPhanVIA7_1(
      QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot,
      String fieldNameLoaiKhac,
      selectedValue) {
    if ((selectedValue == 1 && question.maCauHoi == "A7_1") &&
        fieldNameLoaiKhac == columnPhieuMauA7_1_5_0) {
      var fieldNameGhiRo = '${chiTieuDong.maCauHoi}_${chiTieuDong.maSo}_GhiRo';
      var ghiRoValue =
          controller.getValueByFieldName(question.bangDuLieu!, fieldNameGhiRo);

      return InputStringCTDm(
        key: ValueKey('${question.cauHoiUUID}${question.maCauHoi}'),
        question: question,
        onChange: (value) => controller.onChangeGhiRoDm(question, value, null,
            fieldNameGhiRo: fieldNameGhiRo),
        titleText: 'Ghi rõ',
        level: 3,
        value: ghiRoValue,
        validator: (inputValue) => controller.onValidate(question.bangDuLieu!,
            question.maCauHoi!, fieldNameGhiRo, inputValue, 5, 250, 4, true),
      );
    }
    return const SizedBox();
  }

  renderChiTieuDongCotType2(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    var fieldNameMaCauHoiMaSo =
        controller.getFieldNameByMaCauChiTieuDongCot(chiTieuCot, chiTieuDong)!;
    // var wFilterInput = chiTieuCot.maChiTieu == AppDefine.maChiTieu_2
    //     ? RegExp(r'(^\d*\.?\d{0,1})')
    //     : RegExp('[0-9]');
    var wFilterInput = RegExp('[0-9]');

    if (question.maCauHoi == "A7_1") {
      if (controller.a7_1FieldWarning.contains(fieldNameMaCauHoiMaSo)) {
        controller.warningA7_1_X3SoPhongTangMoi(chiTieuDong.maSo!);
        return Obx(() {
          var valA7_1x = controller.getValueByFieldName(
              question.bangDuLieu!, fieldNameMaCauHoiMaSo);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputIntChiTieu(
                key: ValueKey(fieldNameMaCauHoiMaSo),
                type: 'int',
                onChange: (value) => controller.onChangeInputChiTieuDongCot(
                    question.bangDuLieu!,
                    question.maCauHoi,
                    fieldNameMaCauHoiMaSo,
                    value,
                    question: question,
                    chiTieuCot: chiTieuCot,
                    chiTieuDong: chiTieuDong),
                chiTieuCot: chiTieuCot,
                chiTieuDong: chiTieuDong,
                showDvtTheoChiTieuDong:
                    question.buocNhay == 'exit' ? true : false,
                subName: subName,
                enable: (chiTieuDong.loaiCauHoi == AppDefine.loaiCauHoi_9 ||
                        question.buocNhay == 'exit')
                    ? false
                    : true,
                value: valA7_1x,
                validator: (inputValue) =>
                    controller.onValidateInputChiTieuDongCot(
                        question, chiTieuCot, chiTieuDong, inputValue,
                        typing: true),
                flteringTextInputFormatterRegExp: wFilterInput,
                warningText:
                    controller.getA7_1WarningValue(fieldNameMaCauHoiMaSo),
              ),
            ],
          );
        });
      }
    }
    var val = controller.getValueByFieldName(
        question.bangDuLieu!, fieldNameMaCauHoiMaSo);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputIntChiTieu(
          key: ValueKey(fieldNameMaCauHoiMaSo),
          // key: ValueKey<ChiTieuModel>(chiTieuCot),
          // key: ValueKey(
          //     '${chiTieuCot.maPhieu}-${chiTieuCot.maCauHoi}-${chiTieuDong.maIO}-${chiTieuCot.maChiTieu}-$fieldNameIO'),
          type: 'int',
          onChange: (value) => controller.onChangeInputChiTieuDongCot(
              question.bangDuLieu!,
              question.maCauHoi,
              fieldNameMaCauHoiMaSo,
              value,
              question: question,
              chiTieuCot: chiTieuCot,
              chiTieuDong: chiTieuDong),
          chiTieuCot: chiTieuCot,
          chiTieuDong: chiTieuDong,
          showDvtTheoChiTieuDong: question.buocNhay == 'exit' ? true : false,
          subName: subName,
          enable: (chiTieuDong.loaiCauHoi == AppDefine.loaiCauHoi_9 ||
                  question.buocNhay == 'exit')
              ? false
              : true,
          value: val,
          validator: (inputValue) => controller.onValidateInputChiTieuDongCot(
              question, chiTieuCot, chiTieuDong, inputValue,
              typing: true),
          flteringTextInputFormatterRegExp: wFilterInput,
        ),
      ],
    );
  }

  renderChiTieuDongCotQuestionType3(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    var fieldNameMaCauHoiMaSo =
        controller.getFieldNameByMaCauChiTieuDongCot(chiTieuCot, chiTieuDong)!;
    //  return Obx(() {
    var val = controller.getValueByFieldName(
        question.bangDuLieu!, fieldNameMaCauHoiMaSo);
    if (question.maCauHoi == "A4_5" ||
        question.maCauHoi == "A4_7" ||
        question.maCauHoi == "A8_1") {
      return renderChiTieuDongCotType3ByMaChiTieu(
          question, chiTieuDong, chiTieuCot,
          value: value);
    }
    return renderChiTieuDongCotType3(question, chiTieuDong, chiTieuCot);
    // });
  }

  renderChiTieuDongCotType3ByMaChiTieu(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    var fieldNameMaCauHoiMaSo =
        controller.getFieldNameByMaCauChiTieuDongCot(chiTieuCot, chiTieuDong)!;
    // var wFilterInput = chiTieuCot.maChiTieu == AppDefine.maChiTieu_2
    //     ? RegExp(r'(^\d*\.?\d{0,1})')
    //     : RegExp('[0-9]');
    var wFilterInput = RegExp('[0-9]');

    return Obx(() {
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, fieldNameMaCauHoiMaSo);
      if (question.maCauHoi == "A4_5" || question.maCauHoi == "A4_7") {
        var a4_5_x_xFieldName = '${chiTieuDong.maCauHoi}_${chiTieuDong.maSo}_1';
        var a4_5_x_xValue = controller.getValueDmByFieldName(a4_5_x_xFieldName);
        if (a4_5_x_xValue == 1) {
          return renderChiTieuDongCotType3(question, chiTieuDong, chiTieuCot);
        } else {
          return const SizedBox();
        }
      } else if (question.maCauHoi == "A8_1") {
        if (chiTieuDong.maSo == "3.1") {
          // var a8_1_3_1FieldName = '${chiTieuDong.maCauHoi}_3_1';
          // var a8_1_3_1Value =
          //     controller.getValueDmByFieldName(a8_1_3_1FieldName);
          // if (a8_1_3_1Value == 1 && chiTieuCot.maChiTieu == '2') {
          //   return renderChiTieuDongCotType3(question, chiTieuDong, chiTieuCot);
          // } else {
          //   return const SizedBox();
          // }

          if (chiTieuCot.maChiTieu == '2') {
            return renderChiTieuDongCotType3(question, chiTieuDong, chiTieuCot);
          } else {
            return const SizedBox();
          }
        } else if (chiTieuDong.maSo == "5.1") {
          // var a8_1_5_1FieldName = '${chiTieuDong.maCauHoi}_5_1';
          // var a8_1_5_1Value =
          //     controller.getValueDmByFieldName(a8_1_5_1FieldName);
          // if (a8_1_5_1Value == 1 && chiTieuCot.maChiTieu == '2') {
          //   return renderChiTieuDongCotType3(question, chiTieuDong, chiTieuCot);
          // } else {
          //   return const SizedBox();
          // }

          if (chiTieuCot.maChiTieu == '2') {
            return renderChiTieuDongCotType3(question, chiTieuDong, chiTieuCot);
          } else {
            return const SizedBox();
          }
        } else if (chiTieuDong.maSo == "1.1" ||
            chiTieuDong.maSo == "1.2" ||
            chiTieuDong.maSo == "1.3" ||
            chiTieuDong.maSo == "1.4") {
          var a8_1_x_xFieldName =
              '${chiTieuDong.maCauHoi}_${chiTieuDong.maSo!.replaceAll('.', '_')}_1';
          var a8_1_x_xValue =
              controller.getValueDmByFieldName(a8_1_x_xFieldName);
          if (a8_1_x_xValue == 1) {
            return renderChiTieuDongCotType3(question, chiTieuDong, chiTieuCot);
          } else {
            return const SizedBox();
          }
        } else {
          var a8_1_x_xFieldName =
              '${chiTieuDong.maCauHoi}_${chiTieuDong.maSo}_1';
          var a8_1_x_xValue =
              controller.getValueDmByFieldName(a8_1_x_xFieldName);
          if (a8_1_x_xValue == 1) {
            return renderChiTieuDongCotType3(question, chiTieuDong, chiTieuCot);
          } else {
            return const SizedBox();
          }
        }
      }
      return renderChiTieuDongCotType3(question, chiTieuDong, chiTieuCot);
    });
  }

  renderChiTieuDongCotType3(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName}) {
    var wFilterInput = RegExp('[0-9]');
    int decimalDigits = 2;
    if (question.maCauHoi == 'A8_1' && chiTieuCot.maChiTieu == '2') {
      wFilterInput = RegExp(r'(^\d*\.?\d{0,2})');
      decimalDigits = 2;
    }
    var fieldNameMaCauHoiMaSo =
        controller.getFieldNameByMaCauChiTieuDongCot(chiTieuCot, chiTieuDong)!;
    return Obx(() {
      var xVal = controller.getValueByFieldName(
          question.bangDuLieu!, fieldNameMaCauHoiMaSo);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputIntChiTieu(
            key: ValueKey(fieldNameMaCauHoiMaSo),
            // key: ValueKey<ChiTieuModel>(chiTieuCot),
            // key: ValueKey(
            //     '${chiTieuCot.maPhieu}-${chiTieuCot.maCauHoi}-${chiTieuDong.maIO}-${chiTieuCot.maChiTieu}-$fieldNameIO'),
            type: 'double',
            onChange: (value) => controller.onChangeInputChiTieuDongCot(
                question.bangDuLieu!,
                question.maCauHoi,
                fieldNameMaCauHoiMaSo,
                value,
                question: question,
                chiTieuCot: chiTieuCot,
                chiTieuDong: chiTieuDong),
            chiTieuCot: chiTieuCot,
            chiTieuDong: chiTieuDong,
            showDvtTheoChiTieuDong:
                ((question.maCauHoi == 'A8_1' && chiTieuCot.maChiTieu == '2'))
                    ? true
                    : false,
            subName: subName,
            enable: (chiTieuDong.loaiCauHoi == AppDefine.loaiCauHoi_9 ||
                    question.buocNhay == 'exit')
                ? false
                : true,
            value: xVal,
            validator: (inputValue) => controller.onValidateInputChiTieuDongCot(
                question, chiTieuCot, chiTieuDong, inputValue,
                fieldName: fieldNameMaCauHoiMaSo),
            flteringTextInputFormatterRegExp: wFilterInput,
            decimalDigits: decimalDigits,
            warningText: buildWarningTextA8_1(
                question, chiTieuDong, chiTieuCot, fieldNameMaCauHoiMaSo),
          ),
        ],
      );
    });
  }

  renderQuestionType5DmChiTieuDongCot(
      QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot,
      String tenDanhMuc) {
    if (question.maCauHoi == "A4_7" && chiTieuDong.maSo == "0") {
      return Obx(() {
        var wFilterInput = RegExp('[0-9]');
        int decimalDigits = 2;
        var fieldName = controller.getFieldNameByMaCauChiTieuDongCot(
            chiTieuCot, chiTieuDong);
        //'${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo!}_${chiTieuCot.maChiTieu}';
        var xVal = controller.getValueDmByFieldName(fieldName);
        var dmChiTieu = controller.getDanhMucByTenDm(tenDanhMuc) ?? [];

        var a4_7_0_TongSo =
            controller.getValueDmByFieldName(columnPhieuMauA4_7_0);
        // return InputIntView(
        //   key: ValueKey('${question.cauHoiUUID}_$a4_7_0_TongSo'),
        //   question: question,
        //   onChange: (value) => {},
        //   value: a4_7_0_TongSo,
        //   enable: false,
        //   txtStyle: styleMediumBold.copyWith(color: primaryColor),
        //   hienThiTenCauHoi: false,
        // );
        return InputInt(
          key: ValueKey('${question.cauHoiUUID}'),
          question: question,
          onChange: (value) => controller.onChangeInputChiTieuDongCot(
              question.bangDuLieu!,
              question.maCauHoi,
              columnPhieuMauA4_7_0,
              value,
              question: question,
              chiTieuCot: chiTieuCot,
              chiTieuDong: chiTieuDong),
          value: a4_7_0_TongSo,
          showDtv: true,
          rightString: chiTieuDong.dVT,
          type: 'double',
          validator: (String? inputValue) =>
              controller.onValidateInputChiTieuDongCot(
                  question, chiTieuCot, chiTieuDong, inputValue,
                  typing: true, fieldName: columnPhieuMauA4_7_0),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
          hideQuestionCaption: true,
        );
      });
    }
    if (question.maCauHoi == "A7_1") {
      return Obx(() {
        var wFilterInput = RegExp('[0-9]');
        int decimalDigits = 0;
        var fieldName = controller.getFieldNameByMaCauChiTieuDongCot(
            chiTieuCot, chiTieuDong);
        //'${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo!}_${chiTieuCot.maChiTieu}';
        var xVal = controller.getValueDmByFieldName(fieldName);
        var dmChiTieu = controller.getDanhMucByTenDm(tenDanhMuc) ?? [];
        return Column(
          children: [
            SelectIntCTDm(
              key: ValueKey(
                  '${question.cauHoiUUID}_${chiTieuDong.maSo}_${chiTieuCot.maChiTieu}_$xVal'),
              question: question,
              listValue: dmChiTieu,
              tenDanhMuc: tenDanhMuc,
              onChange: (value, dmItem) => controller.onSelectDmA7_1(
                  question,
                  question.bangDuLieu!,
                  question.maCauHoi,
                  fieldName,
                  value,
                  dmItem,
                  chiTieuDong: chiTieuDong,
                  chiTieuCot: chiTieuCot),
              value: xVal,
              onChangeGhiRo: (value, dmItem) =>
                  controller.onChangeGhiRoDm(question, value, dmItem),
              hienThiTenCauHoi: false,
            ),
            if (chiTieuCot.maChiTieu == '0')
              buildGhiRoPhanVIA7_1(
                  question, chiTieuDong, chiTieuCot, fieldName, xVal),
          ],
        );
      });
    }
    // if (question.maCauHoi == "A8_1" &&
    //     (chiTieuDong.maSo == "4" || chiTieuDong.maSo == "5"|| chiTieuDong.maSo == "7")) {
    //   return Column(
    //     children: [
    //       SelectIntCTDm(
    //         key: ValueKey(
    //             '${question.cauHoiUUID}_${chiTieuDong.maSo}_${chiTieuCot.maChiTieu}_$val'),
    //         question: question,
    //         listValue: dmChiTieu,
    //         tenDanhMuc: tenDanhMuc,
    //         onChange: (value, dmItem) => controller.onSelectDm(
    //             question,
    //             question.bangDuLieu!,
    //             question.maCauHoi,
    //             fieldName,
    //             value,
    //             dmItem),
    //         value: val,
    //         onChangeGhiRo: (value, dmItem) =>
    //             controller.onChangeGhiRoDm(question, value, dmItem),
    //         hienThiTenCauHoi: false,
    //       ),
    //       buildWarningTextA8_1(question, chiTieuDong, chiTieuCot),
    //     ],
    //   );
    // }
    return Obx(() {
      var wFilterInput = RegExp('[0-9]');
      int decimalDigits = 0;
      var fieldName =
          controller.getFieldNameByMaCauChiTieuDongCot(chiTieuCot, chiTieuDong);
      //'${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo!}_${chiTieuCot.maChiTieu}';
      var xVal = controller.getValueDmByFieldName(fieldName);
      var dmChiTieu = controller.getDanhMucByTenDm(tenDanhMuc) ?? [];
      return Column(
        children: [
          SelectIntCTDm(
            key: ValueKey(
                '${question.cauHoiUUID}_${chiTieuDong.maSo}_${chiTieuCot.maChiTieu}_$xVal'),
            question: question,
            listValue: dmChiTieu,
            tenDanhMuc: tenDanhMuc,
            onChange: (value, dmItem) => controller.onSelectDm(
                question,
                question.bangDuLieu!,
                question.maCauHoi,
                fieldName,
                value,
                dmItem),
            value: xVal,
            onChangeGhiRo: (value, dmItem) =>
                controller.onChangeGhiRoDm(question, value, dmItem),
            hienThiTenCauHoi: false,
          ),
          buildGhiRo(question, xVal),
        ],
      );
    });
  }

  renderQuestionType5DmChiTieuDongCotA9_4(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, String tenDanhMuc) {
    return Obx(() {
      var fieldName =
          controller.getFieldNameByMaCauChiTieuDongCotA9_4(chiTieuDong);
      //'${chiTieuDong.maCauHoi!}_${chiTieuDong.maSo!}_${chiTieuCot.maChiTieu}';
      var val = controller.getValueDmByFieldName(fieldName);
      var dmChiTieu = controller.getDanhMucByTenDm(tenDanhMuc) ?? [];
      return Column(
        children: [
          SelectIntCTDm(
            key: ValueKey('${question.cauHoiUUID}_${chiTieuDong.maSo}'),
            question: question,
            listValue: dmChiTieu,
            tenDanhMuc: tenDanhMuc,
            onChange: (value, dmItem) => controller.onSelectDm(
                question,
                question.bangDuLieu!,
                question.maCauHoi,
                fieldName,
                value,
                dmItem),
            value: val,
            onChangeGhiRo: (value, dmItem) =>
                controller.onChangeGhiRoDm(question, value, dmItem),
            hienThiTenCauHoi: false,
          ),
        ],
      );
    });
  }

  renderQuestionType7(QuestionCommonModel question) {
    return Obx(() {
      var a4_3Value = controller.getValueByFieldName(
          question.bangDuLieu!, columnPhieuMauA4_3);
      if (a4_3Value == 1) {
        var val = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);

        return Column(
          children: [
            SelectMultipleIntDm(
              question: question,
              key: ValueKey('${question.cauHoiUUID}'),
              listValue: controller.parseDmLogisticToChiTieuModel() ?? [],
              onChange: (value) => controller.onSelect(question.bangDuLieu!,
                  question.maCauHoi!, question.maCauHoi!, value.join(';')),
              value: val,
            ),
            if ((val.toString().contains("1") ||
                    val.toString().contains("2")) &&
                question.danhSachCauHoiCon!.isNotEmpty)
              buildSubQuestionA4_4(question),
          ],
        );
      }
      return const SizedBox();
    });
  }

  buildSubQuestionA4_4(QuestionCommonModel question) {
    if (question.danhSachCauHoiCon!.isNotEmpty) {
      List<QuestionCommonModel> subQuestions = question.danhSachCauHoiCon!;
      return ListView.builder(
          itemCount: subQuestions.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            QuestionCommonModel subQuestionsItem = subQuestions[index];
            return renderQuestionType3A4_4(subQuestionsItem);
          });
    }
  }

  renderQuestionType3A4_4(QuestionCommonModel question) {
    var wFilterInput = RegExp('[0-9]');
    int decimalDigits = 2;
    var a4_4Value = controller.getValueByFieldName(
        question.bangDuLieu!, columnPhieuMauA4_4);
    if (a4_4Value.toString().contains("1") && question.maCauHoi == "A4_4_1") {
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, question.maCauHoi!);
      return InputInt(
        key: ValueKey(
            '${question.maPhieu}-${question.maCauHoi}-${question.sTT}'),
        question: question,
        onChange: (value) => controller.onChangeInput(
            question.bangDuLieu!, question.maCauHoi, question.maCauHoi, value),
        value: val,
        type: 'double',
        validator: (String? value) => controller.onValidate(
            question.bangDuLieu!,
            question.maCauHoi!,
            question.maCauHoi,
            value,
            question.giaTriNN,
            question.giaTriLN,
            question.loaiCauHoi!,
            true),
        flteringTextInputFormatterRegExp: wFilterInput,
        decimalDigits: decimalDigits,
      );
    } else if (a4_4Value.toString().contains("2") &&
        question.maCauHoi == "A4_4_2") {
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, question.maCauHoi!);
      return InputInt(
        key: ValueKey(
            '${question.maPhieu}-${question.maCauHoi}-${question.sTT}'),
        question: question,
        onChange: (value) => controller.onChangeInput(
            question.bangDuLieu!, question.maCauHoi, question.maCauHoi, value),
        value: val,
        type: 'double',
        validator: (String? value) => controller.onValidate(
            question.bangDuLieu!,
            question.maCauHoi!,
            question.maCauHoi,
            value,
            question.giaTriNN,
            question.giaTriLN,
            question.loaiCauHoi!,
            true),
        flteringTextInputFormatterRegExp: wFilterInput,
        decimalDigits: decimalDigits,
      );
    }
    return const SizedBox();
  }

  buildSubQuestion(QuestionCommonModel question) {
    if (question.danhSachCauHoiCon!.isNotEmpty) {
      List<QuestionCommonModel> subQuestions = question.danhSachCauHoiCon!;
      return ListView.builder(
          itemCount: subQuestions.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            QuestionCommonModel subQuestionsItem = subQuestions[index];

            switch (subQuestionsItem.loaiCauHoi) {
              case 4:
                return _renderQuestionType4(subQuestionsItem);
              case 3:
                return _renderQuestionType3(subQuestionsItem);

              default:
                return Container();
            }
          });
    }
  }

  ///Phần V
  buildPhanV(QuestionCommonModel mainQuestion, {String? subName}) {
    return Obx(() {
      // var yesNoMoreProduct =
      //     controller.getValueA5_0(mainQuestion.bangChiTieu!, "A5_0");
      var a5_7Value =
          controller.getValueByFieldName(tablePhieuMau, columnPhieuMauA5_7);
      if (controller.tblPhieuMauSanPham != null &&
          controller.tblPhieuMauSanPham.isNotEmpty) {
        if (mainQuestion.danhSachCauHoiCon != null &&
            mainQuestion.danhSachCauHoiCon!.isNotEmpty) {
          var lastProduct = controller.tblPhieuMauSanPham.lastOrNull;
          int lastStt = 0;
          if (lastProduct != null) {
            lastStt = lastProduct.sTTSanPham!;
          }
          return Column(
              children: controller.tblPhieuMauSanPham.map<Widget>((product) {
            List<QuestionCommonModel> questionsCon =
                mainQuestion.danhSachCauHoiCon!;

            var questionA5_7 =
                questionsCon.where((x) => x.maCauHoi == "A5_7").first;

            return Column(
              children: [
                // if (controller.countProduct(tablePhieuMauSanPham) == 1) ...[
                //   InputIntView(
                //     key: ValueKey('${questionA5_7.maCauHoi}_$a5_7Value'),
                //     question: questionA5_7,
                //     onChange: (value) => (),
                //     value: a5_7Value,
                //     enable: false,
                //   ),
                // ],
                if (product.sTTSanPham! == controller.sttProduct.value)
                  ListView.builder(
                      //   key: ValueKey(product),
                      itemCount: questionsCon.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        QuestionCommonModel questionC = questionsCon[index];
                        return questionItemPhanV(questionC, product);
                      })
                else
                  Obx(() {
                    return Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: greyDarkBorder, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.sTTSanPham! !=
                                controller.sttProduct.value)
                              Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromARGB(255, 240, 212, 154),
                                          Color.fromARGB(255, 234, 232, 226),
                                          Color.fromARGB(255, 234, 232, 226),
                                          Color.fromARGB(255, 240, 212, 154),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          topRight: Radius.circular(
                                              5.0))), // Adds a gradient background and rounded corners to the container
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Sản phẩm thứ ${product.sTTSanPham}",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 62, 65, 68),
                                              ),
                                            ),
                                            if (controller.allowDeleteProduct(
                                                    product) ==
                                                true)
                                              ElevatedButton(
                                                  onPressed: () {
                                                    controller.onDeleteProduct(
                                                        product.id);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.red,
                                                      backgroundColor:
                                                          Colors.white,
                                                      surfaceTintColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(AppValues
                                                                  .borderLv5)),
                                                      elevation: 1.0,
                                                      side: const BorderSide(
                                                          color: Colors.red)),
                                                  child: const Text('Xoá')),
                                          ],
                                        ),
                                      ])),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: ListView.builder(
                                  key: ValueKey<QuestionCommonModel>(
                                      mainQuestion),
                                  itemCount: questionsCon.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    QuestionCommonModel questionC =
                                        questionsCon[index];
                                    return questionItemPhanV(
                                        questionC, product);
                                  }),
                            )
                          ],
                        ));
                  }),

                if (lastStt > 0 && lastStt == product.sTTSanPham!) ...[
                  InputIntView(
                    key: ValueKey('${questionA5_7.maCauHoi}_$a5_7Value'),
                    question: questionA5_7,
                    onChange: (value) => (),
                    value: a5_7Value,
                    enable: false,
                    type: "double",
                    decimalDigits: 2,
                    txtStyle: styleMedium.copyWith(color: primaryColor),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (controller.countHasMoreProduct(tablePhieuMauSanPham) > 0)
                    Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.add_outlined),
                          label: const Text("Thêm sản phẩm"),
                          onPressed: () => controller.addNewRowProduct(),
                          style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                  width: 1.0, color: primaryLightColor),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppValues.borderLv5),
                              ),
                              foregroundColor: primaryColor),
                        )),
                  const SizedBox(height: 16)
                ]
              ],
            );
          }).toList());
        }
        return const SizedBox();
      }
      return const SizedBox();
    });
  }

  questionItemPhanV(QuestionCommonModel question, TablePhieuMauSanPham product,
      {QuestionCommonModel? parentQestion}) {
    var wFilterInput = RegExp('[0-9]');
    int decimalDigits = 0;
    var a5_1_2Val =
        controller.getValueSanPham(question.bangDuLieu!, 'A5_1_2', product.id!);
    switch (question.maCauHoi) {
      case "A5_1":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichTextQuestion(
              question.tenCauHoi ?? '',
              level: question.cap ?? 2,
            ),
            buildPhanVType0Sub(question, product)
          ],
        );
      case "A5_2":
        decimalDigits = 2;
        var val = product.a5_2;
        return InputInt(
          key: ValueKey(
              '${question.maCauHoi}-${product.id}-${product.sTTSanPham}-$a5_1_2Val'),
          question: question,
          onChange: (value) => controller.onChangeInputPhanV(
              question.bangDuLieu!,
              question.maCauHoi,
              question.maCauHoi,
              product.id!,
              value),
          value: val,
          type: 'double',
          validator: (String? value) => controller.onValidateInputA5(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              product.id!,
              value ?? value!.replaceAll(' ', ''),
              0,
              0,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              product.sTTSanPham!,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
        );
      case "A5_3":

        //  var val = product.a5_3;
        var val = controller.getValueSanPham(
            question.bangDuLieu!, 'A5_3', product.id!);
        var dvt = product.donViTinh != null &&
                product.donViTinh != '' &&
                question.dVT != null &&
                question.dVT != ''
            ? question.dVT!
                .replaceAll('[ĐVT]', '${product.donViTinh!} ')
                .replaceAll('  ', ' ')
            : '';
        //question.dVT = dvt;
        var hasA5_3Cap1BCDE = controller.getValueDanhDauSP(ddSpIsCap1BCDE,
            stt: product.sTTSanPham);

        if (hasA5_3Cap1BCDE != null && hasA5_3Cap1BCDE == true) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputInt(
                  key: ValueKey(
                      '${question.maCauHoi}-${product.id}-${product.sTTSanPham}-$a5_1_2Val'),
                  question: question,
                  onChange: (value) => controller.onChangeInputPhanV(
                      question.bangDuLieu!,
                      question.maCauHoi,
                      question.maCauHoi,
                      product.id!,
                      value),
                  value: val,
                  type: 'double',
                  validator: (String? value) => controller.onValidateInputA5(
                      question.bangDuLieu!,
                      question.maCauHoi!,
                      question.maCauHoi,
                      product.id!,
                      value,
                      0,
                      0,
                      question.giaTriNN,
                      question.giaTriLN,
                      question.loaiCauHoi!,
                      product.sTTSanPham!,
                      true),
                  flteringTextInputFormatterRegExp: wFilterInput,
                  decimalDigits: 2,
                  showDtv: true,
                  rightString: dvt,
                ),
                renderPhanVType3Sub(question, product)
              ]);
        }
        return const SizedBox();

      case "A5_4":
        var val = product.a5_4;
        var dvt = product.donViTinh != null &&
                product.donViTinh != '' &&
                question.dVT != null &&
                question.dVT != ''
            ? question.dVT!
                .replaceAll('[ĐVT]', '${product.donViTinh!} ')
                .replaceAll('  ', ' ')
            : '';
        var hasA5_4Cap1BCDE = controller.getValueDanhDauSP(ddSpIsCap1BCDE,
            stt: product.sTTSanPham);

        if (hasA5_4Cap1BCDE != null && hasA5_4Cap1BCDE == true) {
          return InputInt(
            key: ValueKey(
                '${question.maCauHoi}-${product.id}-${product.sTTSanPham}-$a5_1_2Val'),
            question: question,
            onChange: (value) => controller.onChangeInputPhanV(
                question.bangDuLieu!,
                question.maCauHoi,
                question.maCauHoi,
                product.id!,
                value),
            value: val,
            type: 'double',
            validator: (String? value) => controller.onValidateInputA5(
                question.bangDuLieu!,
                question.maCauHoi!,
                question.maCauHoi,
                product.id!,
                value,
                0,
                0,
                question.giaTriNN,
                question.giaTriLN,
                question.loaiCauHoi!,
                product.sTTSanPham!,
                true),
            flteringTextInputFormatterRegExp: wFilterInput,
            decimalDigits: 2,
            showDtv: true,
            rightString: dvt,
          );
        }
        return const SizedBox();
      case "A5_5":
        decimalDigits = 2;
        return Obx(() {
          var val = product.a5_5;
          var valA5_1_2 = product.a5_1_2;
          var hasA5_5G_L6810 = controller.getValueDanhDauSP(ddSpIsCap1GL,
              stt: product.sTTSanPham);

          if (hasA5_5G_L6810 != null && hasA5_5G_L6810 == true) {
            return InputInt(
              key: ValueKey(
                  '${question.maCauHoi}-${product.id}-${product.sTTSanPham}-$a5_1_2Val'),
              question: question,
              onChange: (value) => controller.onChangeInputPhanV(
                  question.bangDuLieu!,
                  question.maCauHoi,
                  question.maCauHoi,
                  product.id!,
                  value),
              value: val,
              type: 'double',
              validator: (String? value) => controller.onValidateInputA5(
                  question.bangDuLieu!,
                  question.maCauHoi!,
                  question.maCauHoi,
                  product.id!,
                  value,
                  0,
                  0,
                  question.giaTriNN,
                  question.giaTriLN,
                  question.loaiCauHoi!,
                  product.sTTSanPham!,
                  true),
              flteringTextInputFormatterRegExp: wFilterInput,
              decimalDigits: decimalDigits,
            );
          }
          return const SizedBox();
        });

      case "A5_6":
        var hasCap2_56 = controller.getValueDanhDauSP(ddSpIsCap2_56,
            stt: product.sTTSanPham);
        if (hasCap2_56 != null && hasCap2_56 == true) {
          return renderPhanVType5(question, product);
        }
        return const SizedBox();
      case "A5_0":
        if (product.sTTSanPham! == controller.sttProduct.value) {
          return buildPhanVA5_0(question, product,
              parentQuestion: parentQestion);
        } else {
          return const SizedBox();
        }
      // case "A5_7":
      //   var val = product.a5_7;
      //   return InputIntView(
      //     question: question,
      //     onChange: (value) => (),
      //     value: val,
      //     type: 'double',
      //   );
      default:
        return Container();
    }
  }

  buildPhanVType0Sub(
      QuestionCommonModel question, TablePhieuMauSanPham product) {
    if (question.danhSachCauHoiCon!.isNotEmpty) {
      List<QuestionCommonModel> questionCon = question.danhSachCauHoiCon!;

      return ListView.builder(
          itemCount: questionCon.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            QuestionCommonModel questionConItem = questionCon[index];
            switch (questionConItem.loaiCauHoi) {
              case 4:
                return renderPhanVType4(questionConItem, product);
              default:
                return Container();
            }
          });
    }
    return const SizedBox();
  }

  renderPhanVType4(QuestionCommonModel question, TablePhieuMauSanPham product) {
    if (question.maCauHoi == "A5_1_1") {
      //return Obx(() {
      var a5_1_1 = controller.getValueSanPham(
          question.bangDuLieu!, columnPhieuMauSanPhamA5_1_1, product.id!);
      // if (product != null) {
      //   a5_1_1 = product.a5_1_1;
      // }

      String vkey =
          '${question.maCauHoi}_${product.id}_${product.sTTSanPham}_1';
      // if (a5_1_1 != null && a5_1_1 != '') {
      //   vkey =
      //       '${question.maCauHoi}_${product.id}_${product.sTTSanPham}_1_';
      // }
      return InputString(
        //  key: ValueKey<TablePhieuMauSanPham>(product),
        key: ValueKey(vkey),
        onChange: (value) => controller.onChangeInputPhanV(question.bangDuLieu!,
            question.maCauHoi, question.maCauHoi, product.id!, value),
        question: question,
        value: a5_1_1,
        validator: (String? value) => controller.onValidate(
            question.bangDuLieu!,
            question.maCauHoi!,
            question.maCauHoi,
            value,
            question.giaTriNN,
            question.giaTriLN,
            question.loaiCauHoi!,
            true),
        maxLine: 5,
      );
      // });
    } else if (question.maCauHoi == "A5_1_2") {
      var a5_1_2;
      if (product != null) {
        a5_1_2 = product.a5_1_2;
      }
      return InkWell(
        onTap: () {
          controller.onOpenDialogSearchType(
              question,
              question.maCauHoi!,
              product,
              product.id!,
              product.sTTSanPham!,
              product.a5_1_1 ?? '',
              a5_1_2);
        },
        child: IgnorePointer(
            child: InputStringVcpa(
          key: ValueKey(
              '${question.maCauHoi}_${product.id}_${product.sTTSanPham}_2$a5_1_2'),
          onChange: (value) => controller.onChangeInputPhanV(
              question.bangDuLieu!,
              question.maCauHoi,
              question.maCauHoi,
              product.id!,
              value),
          question: question,
          value: a5_1_2,
          validator: (String? value) => controller.onValidate(
            question.bangDuLieu!,
            question.maCauHoi!,
            question.maCauHoi,
            value,
            question.giaTriNN,
            question.giaTriLN,
            question.loaiCauHoi!,
            true,
          ),
          readOnly: false,
          suffix: const Icon(
            Icons.arrow_drop_down,
            color: primaryColor,
          ),
        )),
      );
    }
  }

  renderPhanVType2(QuestionCommonModel question, TablePhieuMauSanPham product) {
    var wFilterInput = RegExp('[0-9]');
    int decimalDigits = 0;
    var val;
    var dvt = '';
    if (product != null) {
      if (question.maCauHoi == "A5_3") {
        val = product.a5_3;
      } else if (question.maCauHoi == "A5_3_1") {
        val = product.a5_3_1;
        dvt = product.donViTinh != null &&
                product.donViTinh != '' &&
                question.dVT != null &&
                question.dVT != ''
            ? question.dVT!
                .replaceAll('[ĐVT]', '${product.donViTinh!} ')
                .replaceAll('  ', ' ')
            : '';
      } else if (question.maCauHoi == "A5_4") {
        val = product.a5_4;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputInt(
          question: question,
          onChange: (value) => controller.onChangeInputPhanV(
              question.bangDuLieu!,
              question.maCauHoi,
              question.maCauHoi,
              product.id!,
              value),
          value: val,
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
          showDtv: true,
          rightString: dvt,
        ),
        renderPhanVType2Sub(question, product)
      ],
    );
  }

  renderPhanVType3(QuestionCommonModel question, TablePhieuMauSanPham product) {
    var wFilterInput = RegExp('[0-9]');
    int decimalDigits = 2;
    var val;
    var dvt = '';
    var a5_1_2Val =
        controller.getValueSanPham(question.bangDuLieu!, 'A5_1_2', product.id!);
    if (product != null) {
      if (question.maCauHoi == "A5_3") {
        val = product.a5_3;
      } else if (question.maCauHoi == "A5_3_1") {
        val = product.a5_3_1;
        dvt = product.donViTinh != null &&
                product.donViTinh != '' &&
                question.dVT != null &&
                question.dVT != ''
            ? question.dVT!
                .replaceAll('[ĐVT]', '${product.donViTinh!} ')
                .replaceAll('  ', ' ')
            : '';
      } else if (question.maCauHoi == "A5_4") {
        val = product.a5_4;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputInt(
          key: ValueKey(
              '${question.maCauHoi}-${product.id}-${product.sTTSanPham}-${question.sTT}-$a5_1_2Val'),
          question: question,
          onChange: (value) => controller.onChangeInputPhanV(
              question.bangDuLieu!,
              question.maCauHoi,
              question.maCauHoi,
              product.id!,
              value),
          value: val,
          type: "double",
          validator: (String? value) => controller.onValidate(
              question.bangDuLieu!,
              question.maCauHoi!,
              question.maCauHoi,
              value,
              question.giaTriNN,
              question.giaTriLN,
              question.loaiCauHoi!,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
          showDtv: true,
          rightString: dvt,
        ),
        renderPhanVType3Sub(question, product)
      ],
    );
  }

  renderPhanVType2Sub(
      QuestionCommonModel question, TablePhieuMauSanPham product) {
    if (question.danhSachCauHoiCon != null &&
        question.danhSachCauHoiCon!.isNotEmpty) {
      var questionCon = question.danhSachCauHoiCon!;
      return ListView.builder(
          itemCount: questionCon.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            QuestionCommonModel questionConItem = questionCon[index];
            switch (questionConItem.loaiCauHoi) {
              case 2:
                return renderPhanVType2(questionConItem, product);
              default:
                return Container();
            }
          });
    }
    return const SizedBox();
  }

  renderPhanVType3Sub(
      QuestionCommonModel question, TablePhieuMauSanPham product) {
    if (question.danhSachCauHoiCon != null &&
        question.danhSachCauHoiCon!.isNotEmpty) {
      var questionCon = question.danhSachCauHoiCon!;
      return ListView.builder(
          itemCount: questionCon.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            QuestionCommonModel questionConItem = questionCon[index];
            switch (questionConItem.loaiCauHoi) {
              case 3:
                return renderPhanVType3(questionConItem, product);
              default:
                return Container();
            }
          });
    }
    return const SizedBox();
  }

  renderPhanVType5(QuestionCommonModel question, TablePhieuMauSanPham product) {
    return Obx(() {
      var val = controller.getValueSanPham(
          question.bangDuLieu!, question.maCauHoi!, product.id!);

      var dmChiTieu = controller.tblDmCoKhong;
      return Column(
        children: [
          SelectIntCTDm(
            key: ValueKey('${question.cauHoiUUID}${question.maCauHoi}$val'),
            question: question,
            listValue: dmChiTieu,
            tenDanhMuc: tableDmCoKhong,
            onChange: (value, dmItem) => controller.onSelectDmPhanV(
                question,
                question.bangDuLieu!,
                question.maCauHoi,
                question.maCauHoi,
                product.id!,
                value,
                dmItem),
            value: val,
            isbg: true,
          ),
          renderPhanVType5_6_1(question, product)
        ],
      );
    });
  }

  renderPhanVType5_6_1(
      QuestionCommonModel mainQuestion, TablePhieuMauSanPham product) {
    if (mainQuestion.danhSachCauHoiCon != null &&
        mainQuestion.danhSachCauHoiCon!.isNotEmpty) {
      var questionCon = mainQuestion.danhSachCauHoiCon!;
      var wFilterInput = RegExp('[0-9]');
      int decimalDigits = 2;
      var a5_6Val = controller.getValueSanPham(
          tablePhieuMauSanPham, columnPhieuMauSanPhamA5_6, product.id!);
      if (a5_6Val != null && (a5_6Val == 1 || a5_6Val == '1')) {
        return ListView.builder(
            itemCount: questionCon.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              QuestionCommonModel questionConItem = questionCon[index];
              switch (questionConItem.loaiCauHoi) {
                case 3:
                  var val;
                  if (product != null) {
                    if (questionConItem.maCauHoi == "A5_6_1") {
                      val = product.a5_6_1;
                    }
                  }
                  return InputInt(
                    question: questionConItem,
                    onChange: (value) => controller.onChangeInputPhanV(
                        questionConItem.bangDuLieu!,
                        questionConItem.maCauHoi,
                        questionConItem.maCauHoi,
                        product.id!,
                        value),
                    value: val,
                    type: 'double',
                    validator: (String? value) => controller.onValidate(
                        questionConItem.bangDuLieu!,
                        questionConItem.maCauHoi!,
                        questionConItem.maCauHoi,
                        value,
                        questionConItem.giaTriNN,
                        questionConItem.giaTriLN,
                        questionConItem.loaiCauHoi!,
                        true),
                    flteringTextInputFormatterRegExp: wFilterInput,
                    decimalDigits: decimalDigits,
                  );
                default:
                  return Container();
              }
            });
      }
      return const SizedBox();
    }
  }

  buildPhanVA5_0(QuestionCommonModel questionA5_0, TablePhieuMauSanPham product,
      {QuestionCommonModel? parentQuestion}) {
    return Obx(() {
      var val = controller.getValueA5_0(
          questionA5_0.bangDuLieu!, questionA5_0.maCauHoi!);
      return Column(
        children: [
          NewYesNoQuestion(
            key: ValueKey('${questionA5_0.maCauHoi}_'),
            onChange: (value) => controller.onSelectYesNoProduct(
                questionA5_0.bangDuLieu!,
                questionA5_0.maCauHoi!,
                questionA5_0.maCauHoi!,
                product.id!,
                value),
            question: questionA5_0,
            value: val,
            child: const Column(
              children: [],
            ),
          ),
        ],
      );
    });
  }

  buildWarningText(QuestionCommonModel question, selectedValue) {
    if (question.maCauHoi == columnPhieuMauA1_4) {
      if (selectedValue == 2) {
        var a1_3Value = controller.getValueDmByFieldName("A1_3");
        if (a1_3Value != null) {
          if (a1_3Value.toString() == "6") {
            return const Text(
              'Cảnh báo: Câu 1.3 đã chọn 6 - Cơ sở không có địa điểm cố định. Vui lòng kiểm tra lại.',
              style: TextStyle(color: Colors.orange),
            );
          }
        }
      }
      return const SizedBox();
    } else if (question.maCauHoi == columnPhieuMauA1_5_6) {
      if (controller.a1_5_6MaWarning.contains(selectedValue)) {
        var a1_5_3val = controller.getValueDmByFieldName("A1_5_3");
        if (selectedValue == 4 ||
            selectedValue == 5 ||
            selectedValue == 6 ||
            selectedValue == 7) {
          if (a1_5_3val != null && a1_5_3val >= 2007) {
            var tblTDCM = controller.tblDmTrinhDoChuyenMon
                .where((x) => x.ma == selectedValue)
                .firstOrNull;
            String selectedText = tblTDCM!.ten ?? '';
            return Text(
              'Cảnh báo: Câu 1.5.3 Năm sinh = $a1_5_3val, câu 1.5.6 chọn $selectedValue - $selectedText. Vui lòng kiểm tra lại.',
              style: const TextStyle(color: Colors.orange),
            );
          }
        } else if (selectedValue == 8) {
          if (a1_5_3val != null && a1_5_3val >= 2004) {
            var tblTDCM = controller.tblDmTrinhDoChuyenMon
                .where((x) => x.ma == selectedValue)
                .firstOrNull;
            String selectedText = tblTDCM!.ten ?? '';
            return Text(
              'Cảnh báo: Câu 1.5.3 Năm sinh = $a1_5_3val, câu 1.5.6 chọn $selectedValue - $selectedText. Vui lòng kiểm tra lại.',
              style: const TextStyle(color: Colors.orange),
            );
          }
        } else if (selectedValue == 9 || selectedValue == 10) {
          if (a1_5_3val != null && a1_5_3val >= 2002) {
            var tblTDCM = controller.tblDmTrinhDoChuyenMon
                .where((x) => x.ma == selectedValue)
                .firstOrNull;
            String selectedText = tblTDCM!.ten ?? '';
            return Text(
              'Cảnh báo: Câu 1.5.3 Năm sinh = $a1_5_3val, câu 1.5.6 chọn $selectedValue - $selectedText. Vui lòng kiểm tra lại.',
              style: const TextStyle(color: Colors.orange),
            );
          }
        }
      }
      return const SizedBox();
    } else if (question.maCauHoi == columnPhieuMauA9_1) {
      if (selectedValue != 1) {
        var a4_5_3_1Value = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuMauA4_5_3_1);
        var a4_5_3_2Value = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuMauA4_5_3_2);
        if (a4_5_3_1Value != null && a4_5_3_1Value == 1 ||
            (a4_5_3_2Value != null &&
                !controller.validate0InputValue(a4_5_3_2Value))) {
          return const Text(
            'Cảnh báo: Câu 4.5 chỉ tiêu 3.Thuê đường truyền internet, cước điện thoại đã có giá trị. Vui lòng kiểm tra lại câu 9.1.',
            style: TextStyle(color: Colors.orange),
          );
        }
      }
      return const SizedBox();
    }
  }

  buildWarningTextA8_1(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot, String fieldName) {
    if (chiTieuDong.maSo == '4') {
      if (controller.isCap1HPhanVI.value &&
          (controller.isCap5VanTaiHanhKhachPhanVI.value ||
              controller.isCap5DichVuHangHoaPhanVI.value)) {
        var selectedValue = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuMauA8_1_4_1);
        if (selectedValue == 1) {
          var a8_1_4_xValue =
              controller.getValueByFieldName(question.bangDuLieu!, fieldName);
          if (a8_1_4_xValue != null &&
              controller.validate0InputValue(a8_1_4_xValue)) {
            return 'Cảnh báo: Mục VI, Mục VII có thông tin. Vui lòng kiểm tra lại chỉ tiêu này.';
          }
        }
      }
    } else if (chiTieuDong.maSo == '5') {
      if (controller.isCap1HPhanVI.value &&
          (controller.isCap5VanTaiHanhKhachPhanVI.value ||
              controller.isCap5DichVuHangHoaPhanVI.value)) {
        var selectedValue = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuMauA8_1_5_1);
        if (selectedValue == 1) {
          var a8_1_4_xValue =
              controller.getValueByFieldName(question.bangDuLieu!, fieldName);
          if (a8_1_4_xValue != null &&
              controller.validate0InputValue(a8_1_4_xValue)) {
            return 'Cảnh báo: Mục VI, Mục VII có thông tin. Vui lòng kiểm tra lại chỉ tiêu này.';
          }
        }
      }
    } else if (chiTieuDong.maSo == '7') {
      if (controller.isCap1HPhanVI.value &&
          (controller.isCap5VanTaiHanhKhachPhanVI.value ||
              controller.isCap5DichVuHangHoaPhanVI.value)) {
        var selectedValue = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuMauA8_1_7_1);
        if (selectedValue == 1) {
          var a8_1_4_xValue =
              controller.getValueByFieldName(question.bangDuLieu!, fieldName);
          if (a8_1_4_xValue != null &&
              controller.validate0InputValue(a8_1_4_xValue)) {
            return 'Cảnh báo: Mục VI, Mục VII có thông tin. Vui lòng kiểm tra lại chỉ tiêu này.';
          }
        }
      }
    }
    return '';
  }

  ///
}
