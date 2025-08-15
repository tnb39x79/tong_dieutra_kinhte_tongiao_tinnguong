import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:gov_tongdtkt_tongiao/common/utils/utils.dart';
import 'package:gov_tongdtkt_tongiao/common/widgets/input/search_dantoc.dart';
import 'package:gov_tongdtkt_tongiao/common/widgets/input/search_vcpa_cap5.dart';

import 'package:gov_tongdtkt_tongiao/common/widgets/question/input_string.dart';
import 'package:gov_tongdtkt_tongiao/common/widgets/question/select_int.dart';

import 'package:gov_tongdtkt_tongiao/common/widgets/sidebar/sidebar.dart';
import 'package:gov_tongdtkt_tongiao/common/widgets/widgets.dart';
import 'package:gov_tongdtkt_tongiao/config/config.dart';
import 'package:gov_tongdtkt_tongiao/modules/question_module/question_no08/widget/input_string_vcpa.dart';
import 'package:gov_tongdtkt_tongiao/modules/question_module/question_no08/widget/select_int_ct_dm.dart';
import 'package:gov_tongdtkt_tongiao/modules/question_module/question_no08/widget/select_mutil_int_dm.dart';
import 'package:gov_tongdtkt_tongiao/modules/question_module/question_no08/widget/input_string_dm.dart';
import 'package:gov_tongdtkt_tongiao/modules/question_module/question_no08/widget/select_int_dm.dart';
import 'package:gov_tongdtkt_tongiao/modules/question_module/question_no08/widget/select_string_dm.dart';
import 'package:gov_tongdtkt_tongiao/modules/question_module/question_no08/widget/input_string_chitieu_c1.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/filed_common.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_dm08.dart';
import 'package:gov_tongdtkt_tongiao/resource/database/table/table_p08.dart';
import 'package:gov_tongdtkt_tongiao/resource/model/model.dart';

import 'question_no08_controller.dart';

class QuestionNo08Screen extends GetView<QuestionNo08Controller> {
  const QuestionNo08Screen({super.key});

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
              controller.onMenuPress),
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
                              parentQuestion: parentQuestion)
                        ],
                      ));
                } else {}
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
              case 3:
                return _renderQuestionType3(question);
              case 2:
                return _renderQuestionType2(question);

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
        if (question.maCauHoi == "A4_3") {
          return buildQuestionA43(question);
        }
        if (question.bangChiTieu == "2") {
          return buildQuestionChiTieuDongCot(question);
        } else {
          return renderQuestionType0(question);
        }
      // return RichTextQuestion(question.tenCauHoi ?? '', level: question.cap!);
      case 1:
        if (question.bangChiTieu == '2') {
          // return _renderChiTieuDongCotType1(question);
        } else {
          return _renderQuestionType1(question);
        }

      case 2:
        return _renderQuestionType2WithSub(question);
      case 3:
        return _renderQuestionType3(question);
      case 4:
        if (question.maCauHoi == "A1_5") {
          return renderThongTinNguoiDungDau(question);
        }
        return _renderQuestionType4(question);
      case 5:
        return _renderQuestionType5Dm(question);
      case 7:
        return renderQuestionType7(question);
      default:
        if (question.bangChiTieu == '2') {
          if (question.maCauHoi == "A6_2") {
            return buildQuestionChiTieuDongCotA6_2(question);
          }
          return buildQuestionChiTieuDongCot(question);
        }
        return Container();
    }
  }

  renderQuestionType0(QuestionCommonModel question,
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
            // return _renderQuestionType0(question, product: product);

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
    return Obx(() {
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, question.maCauHoi!);
      var wFilterInput = RegExp('[0-9]');
      if (!enable) {
        return ViewInput(
          question: question,
          value: val,
        );
      }

      return InputInt(
        key: ValueKey('${question.maCauHoi}${question.cauHoiUUID}'),
        question: question,
        onChange: (value) => controller.onChangeInput(
            question.bangDuLieu!, question.maCauHoi, question.maCauHoi, value),
        enable: enable,
        subName: subName,
        value: val,
        type: "int",
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
        warningText: warningTextType4(question, val),
      );
    });
  }

  _renderQuestionType2WithSub(QuestionCommonModel question,
      {String? subName,
      ProductModel? product,
      QuestionCommonModel? parentQuestion}) {
    var val = controller.getValueByFieldName(
        question.bangDuLieu!, question.maCauHoi!);
    var wFilterInput = RegExp('[0-9]');

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
          type: "int",
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
          warningText: warningTextType4(question, val),
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
    //  });
  }

  _questionSubType2(QuestionCommonModel question,
      {QuestionCommonModel? parentQuestion}) {
    switch (question.loaiCauHoi) {
      case 1:
        if (question.bangChiTieu == '2') {
          // return _renderChiTieuDongCotType1(question);
        } else {
          return _renderQuestionType1(question);
        }

      case 2:
        return _renderQuestionType2(question);
      case 3:
        return _renderQuestionType3(question);
      case 4:
        return _renderQuestionType4(question);
      case 5:
        if (question.bangChiTieu == tableDmDanToc) {
          return buildDmDanToc(question);
        } else {
          return _renderQuestionType5Dm(question);
        }
      default:
        return Container();
    }
  }

  _renderQuestionType3(
    QuestionCommonModel question, {
    String? subName,
    ProductModel? product,
  }) {
    var val = controller.getValueByFieldName(
        question.bangDuLieu!, question.maCauHoi!);

    var wFilterInput = RegExp('[0-9]');
    if (question.maCauHoi == "A3_1" ||
        question.maCauHoi == "A3_2" ||
        question.maCauHoi == "A3_2_1") {
      wFilterInput = RegExp(r'(^\d*\.?\d{0,2})');
      return Obx(() {
        var valA3 = controller.getValueByFieldName(
            question.bangDuLieu!, question.maCauHoi!);
        return InputInt(
          key: ValueKey(
              '${question.maPhieu}-${question.maCauHoi}-${question.sTT}'),
          question: question,
          onChange: (value) => controller.onChangeInput(question.bangDuLieu!,
              question.maCauHoi, question.maCauHoi, value),
          subName: subName,
          value: valA3,
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
          warningText: warningTextType3(question, valA3),
        );
      });
    }

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
    );
    // }
  }

  _renderQuestionType4(QuestionCommonModel question, {String? subName}) {
    return Obx(() {
      var _val = controller.getValueByFieldName(
          question.bangDuLieu!, question.maCauHoi!);

      return InputString(
        key: ValueKey(question.maCauHoi),
        onChange: (value) => controller.onChangeInput(
            question.bangDuLieu!, question.maCauHoi, question.maCauHoi, value),
        question: question,
        subName: subName,
        value: _val,
        validator: (String? value) => controller.onValidate(
            question.bangDuLieu!,
            question.maCauHoi!,
            question.maCauHoi,
            value,
            question.giaTriNN,
            question.giaTriLN,
            question.loaiCauHoi!,
            true),
        warningText: warningTextType4(question, _val),
      );
    });
    // var _val = controller.getValueByFieldName(
    //     question.bangDuLieu!, question.maCauHoi!);

    // return InputString(
    //   key: ValueKey(question.maCauHoi),
    //   onChange: (value) => controller.onChangeInput(
    //       question.bangDuLieu!, question.maCauHoi, question.maCauHoi, value),
    //   question: question,
    //   subName: subName,
    //   value: _val,
    //   validator: (String? value) => controller.onValidate(
    //       question.bangDuLieu!,
    //       question.maCauHoi!,
    //       question.maCauHoi,
    //       value,
    //       question.giaTriNN,
    //       question.giaTriLN,
    //       question.loaiCauHoi!,
    //       true),
    //   warningText: warningTextType4(question, _val),
    // );
  }

  renderThongTinNguoiDungDau(QuestionCommonModel question, {String? subName}) {
    if (question.danhSachCauHoiCon != null) {
      List<QuestionCommonModel> questionsCon = question.danhSachCauHoiCon!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichTextQuestion(question.tenCauHoi ?? '', level: question.cap!),
          Container(
              margin: const EdgeInsets.fromLTRB(
                  0.0, 0.0, 0.0, AppValues.marginBottomBox),
              padding: const EdgeInsets.all(AppValues.paddingBox),
              decoration: BoxDecoration(
                  border: Border.all(color: greyDarkBorder, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  color: Colors.white),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                        itemCount: questionsCon.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          QuestionCommonModel questionItem =
                              questionsCon[index];
                          return _questionItemNguoiDungDau(questionItem,
                              parentQuestion: question);
                        })
                  ]))
        ],
      );
    }
    return RichTextQuestion(
        controller.questions[controller.questionIndex.value].tenCauHoi ?? '',
        level: controller.questions[controller.questionIndex.value].cap!,
        notes: controller.questions[controller.questionIndex.value].giaiThich ??
            '');
  }

  _questionItemNguoiDungDau(QuestionCommonModel question,
      {QuestionCommonModel? parentQuestion}) {
    switch (question.loaiCauHoi) {
      case 1:
        if (question.bangChiTieu == '2') {
          // return _renderChiTieuDongCotType1(question);
        } else {
          return _renderQuestionType1(question);
        }

      case 2:
        return _renderQuestionType2(question);
      case 3:
        return _renderQuestionType3(question);
      case 4:
        return _renderQuestionType4(question);
      case 5:
        if (question.bangChiTieu == tableDmDanToc) {
          return buildDmDanToc(question);
        } else {
          return _renderQuestionType5Dm(question);
        }
      default:
        return Container();
    }
  }

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
    if (question.maCauHoi == "A1_7") {
      return Obx(() {
        var valA1_6 = controller.getValueDmA1_8('A1_6');
        var valA1_6GhiRo = controller.getValueDmA1_8('A1_6_GhiRo');
        var valA1_7 = controller.getValueDmA1_8('A1_7');
        var dmChiTieuA1_7 =
            controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];
        if ((valA1_6 != 12 &&
                valA1_6 != 13 &&
                valA1_6 != 14 &&
                valA1_6 != 15 &&
                valA1_6 != 16) &&
            (valA1_6GhiRo == 2 ||
                valA1_6GhiRo == null ||
                valA1_6GhiRo.toString() == '' ||
                valA1_6GhiRo.toString() == 'null')) {
          return Column(
            children: [
              SelectIntDm(
                key: ValueKey<QuestionCommonModel>(question),
                question: question,
                listValue: dmChiTieuA1_7,
                tenDanhMuc: question.bangChiTieu,
                onChange: (value, dmItem) => controller.onSelectDm(
                    question,
                    question.bangDuLieu!,
                    question.maCauHoi!,
                    question.maCauHoi!,
                    value,
                    dmItem),
                value: valA1_7,
                titleGhiRoText: 'Ghi rõ',
                onChangeGhiRo: (value, dmItem) =>
                    controller.onChangeGhiRoDm(question, value, dmItem),
              ),
              buildWarningText(question, valA1_7),
              buildGhiRo(question, valA1_7),
            ],
          );
        }
        return const SizedBox();
      });
    }
    if (question.maCauHoi == "A1_8") {
      return Obx(() {
        var valA1_8 = controller.getValueDmA1_8('A1_8_1');

        var dmChiTieuA1_8 =
            controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];
        return Column(
          children: [
            SelectIntDm(
              key: ValueKey<QuestionCommonModel>(question),
              question: question,
              listValue: dmChiTieuA1_8,
              tenDanhMuc: question.bangChiTieu,
              onChange: (value, dmItem) => controller.onSelectDmA1_8(
                  question.bangDuLieu!,
                  question.maCauHoi,
                  "A1_8_1",
                  value,
                  dmItem),
              value: valA1_8,
            ),
            buildWarningText(question, valA1_8),
            buildDmXepHangDiTich(question, valA1_8),
          ],
        );
      });
    }
    if (question.maCauHoi == "A1_9") {
      return Obx(() {
        var valA1_9 = controller.getValueDmA1_8('A1_9');
        var valA1_8_1 = controller.getValueDmA1_8('A1_8_1');
        var dmChiTieuA1_9 =
            controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];
        if (valA1_8_1 != 1) {
          return Column(
            children: [
              SelectIntDm(
                key: ValueKey<QuestionCommonModel>(question),
                question: question,
                listValue: dmChiTieuA1_9,
                tenDanhMuc: question.bangChiTieu,
                onChange: (value, dmItem) => controller.onSelectDm(
                    question,
                    question.bangDuLieu!,
                    question.maCauHoi!,
                    question.maCauHoi!,
                    value,
                    dmItem),
                value: valA1_9,
              ),
            ],
          );
        }
        return const SizedBox();
      });
    }

    if (question.maCauHoi == columnPhieuTonGiaoA4_2) {
      return buildQuestionA4_2(question);
    }
    if (question.maCauHoi == columnPhieuTonGiaoA5_2) {
      return buildQuestionA5_2(question);
    }

    // if (question.maCauHoi == columnPhieuTonGiaoA6_1) {
    //    return buildQuestionA6_1(question);
    //  }
    return Obx(() {
      var val = controller.getValueDm(question);

      var dmChiTieu =
          controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];
      return Column(
        children: [
          SelectIntDm(
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
          buildWarningText(question, val),
          buildGhiRo(question, val),
        ],
      );
    });
  }

  renderQuestionType7(QuestionCommonModel question) {
    return Obx(() {
      var a7_1Value = controller.getValueByFieldName(
          question.bangDuLieu!, columnPhieuTonGiaoA7_1);
      if (a7_1Value == 1) {
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
              buildSubQuestionA7_2(question),
          ],
        );
      }
      return const SizedBox();
    });
  }

  buildSubQuestionA7_2(QuestionCommonModel question) {
    if (question.danhSachCauHoiCon!.isNotEmpty) {
      List<QuestionCommonModel> subQuestions = question.danhSachCauHoiCon!;
      return ListView.builder(
          itemCount: subQuestions.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            QuestionCommonModel subQuestionsItem = subQuestions[index];
            return renderQuestionType3A7_2(subQuestionsItem);
          });
    }
  }

  renderQuestionType3A7_2(QuestionCommonModel question) {
    var wFilterInput = RegExp('[0-9]');
    int decimalDigits = 2;
    var a7_2Value = controller.getValueByFieldName(
        question.bangDuLieu!, columnPhieuTonGiaoA7_2);
    if (a7_2Value.toString().contains("1") && question.maCauHoi == "A7_2_1") {
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
    } else if (a7_2Value.toString().contains("2") &&
        question.maCauHoi == "A7_2_2") {
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

  buildQuestionA4_2(QuestionCommonModel question, {String? subName}) {
    return Obx(() {
      var val = controller.getValueDm(question);

      var dmChiTieu =
          controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];
      return Column(
        children: [
          SelectIntDm(
            key: ValueKey('${question.cauHoiUUID}${question.maCauHoi}$val'),
            question: question,
            listValue: dmChiTieu,
            tenDanhMuc: question.bangChiTieu,
            onChange: (value, dmItem) => controller.onSelectDmA4_2(
                question,
                question.bangDuLieu!,
                question.maCauHoi,
                question.maCauHoi,
                value,
                dmItem),
            value: val,
          ),
          // buildQuestionA43(question, val),
        ],
      );
    });
  }

  ///C4.3 Build câu hỏi có/không không có câu hỏi con nhưng có bước nhảy qua câu khác nếu chọn không
  buildQuestionA43(QuestionCommonModel question,
      {QuestionCommonModel? parentQuestion}) {
    return Obx(() {
      var valA4_2 = controller.getValueByFieldName(
          tablePhieuTonGiao, columnPhieuTonGiaoA4_2);
      if (valA4_2 != 1) {
        return const SizedBox();
      }
      return Column(children: [
        RichTextQuestion(
          question.tenCauHoi ?? '',
          level: question.cap!,
        ),
        buildOnlyQuestionChiTieuCot(question, parentQuestion: parentQuestion)
      ]);
    });
  }

  buildQuestionA5_2(QuestionCommonModel question, {String? subName}) {
    return Obx(() {
      var a5_1Value = controller.getValueDmA1_8(columnPhieuTonGiaoA5_1);
      if (a5_1Value != 1) {
        return const SizedBox();
      }
      var val = controller.getValueDm(question);
      var dmChiTieu =
          controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];
      return Column(
        children: [
          SelectIntDm(
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

  // buildQuestionA6_1(QuestionCommonModel question, {String? subName}) {
  //   return Obx(() {
  //     var val = controller.getValueDm(question);
  //     var dmChiTieu =
  //         controller.getDanhMucByTenDm(question.bangChiTieu ?? '') ?? [];
  //     return Column(
  //       children: [
  //         SelectStringDm(
  //           key: ValueKey('${question.cauHoiUUID}${question.maCauHoi}$val'),
  //           question: question,
  //           listValue: dmChiTieu,
  //           tenDanhMuc: question.bangChiTieu,
  //           onChangeSelectStringDm: (value, dmItem) => controller.onSelectDm(
  //               question,
  //               question.bangDuLieu!,
  //               question.maCauHoi,
  //               question.maCauHoi,
  //               value,
  //               dmItem),
  //           value: val,
  //           titleGhiRoText: 'Ghi rõ',
  //           onChangeSelectStringDmGhiRo: (value, dmItem) =>
  //               controller.onChangeGhiRoDm(question, value, dmItem),
  //         ),
  //         buildGhiRo(question, val),
  //       ],
  //     );
  //   });
  // }

  buildGhiRo(QuestionCommonModel question, selectedValue) {
    if ((selectedValue == 17 &&
            question.bangChiTieu == tableTGDmLoaiHinhTonGiao) ||
        (selectedValue == 11 &&
            question.bangChiTieu == tableTGDmTrinhDoChuyenMon)) {
      // var hasGhiRo = controller.hasDanhMucGhiRoByTenDm(question.bangChiTieu!);
      // if (hasGhiRo && (question.bangChiTieu == tableTGDmTrinhDoChuyenMon ||question.bangChiTieu == tableTGDmLoaiHinhTonGiao)) {
      var ghiRoValue = controller.getValueByFieldName(
          question.bangDuLieu!, '${question.maCauHoi}_GhiRo');
      var fieldNameGhiRo = '${question.maCauHoi}_GhiRo';
      return InputStringDm(
        key: ValueKey('${question.cauHoiUUID}${question.maCauHoi}'),
        question: question,
        onChange: (value) => controller.onChangeGhiRoDm(question, value, null),
        titleText: 'Ghi rõ',
        level: 3,
        value: ghiRoValue,
        validator: (inputValue) => controller.onValidate(question.bangDuLieu!,
            question.maCauHoi!, fieldNameGhiRo, inputValue, 5, 250, 4, true),
      );
    } else if (selectedValue == 17 &&
        (question.bangChiTieu == tableTGDmLoaiCoSo)) {
      return buildDmLoaiTonGiao(question, selectedValue);
    } else if (selectedValue == 1 && question.maCauHoi == "A5_2") {
      var ghiRoValue = controller.getValueByFieldName(
          question.bangDuLieu!, '${question.maCauHoi}_GhiRo');
      var fieldNameGhiRo = '${question.maCauHoi}_GhiRo';
      return InputStringDm(
        key: ValueKey('${question.cauHoiUUID}${question.maCauHoi}'),
        question: question,
        onChange: (value) => controller.onChangeGhiRoDm(question, value, null),
        titleText: 'Địa chỉ truy cập',
        level: 3,
        value: ghiRoValue,
        validator: (inputValue) => controller.onValidate(question.bangDuLieu!,
            question.maCauHoi!, fieldNameGhiRo, inputValue, 5, 250, 4, true),
        warningText: warningTextTypeGhiRo(question, fieldNameGhiRo, ghiRoValue),
      );
    } else if (selectedValue == 'I' &&
        question.bangChiTieu == tableTGDmNangLuong) {
      var ghiRoValue = controller.getValueByFieldName(
          question.bangDuLieu!, '${question.maCauHoi}_GhiRo');
      var fieldNameGhiRo = '${question.maCauHoi}_GhiRo';
      return InputStringDm(
        key: ValueKey('${question.cauHoiUUID}${question.maCauHoi}'),
        question: question,
        onChange: (value) => controller.onChangeGhiRoDm(question, value, null),
        titleText: 'Ghi rõ',
        level: 3,
        value: ghiRoValue,
        validator: (inputValue) => controller.onValidate(question.bangDuLieu!,
            question.maCauHoi!, fieldNameGhiRo, inputValue, 5, 250, 4, true),
      );
    }
    return const SizedBox();
  }

  buildDmXepHangDiTich(QuestionCommonModel question, selectedValue) {
    if (selectedValue == 2) {
      return Obx(() {
        var val = controller.getValueDmA1_8('A1_8_2');
        return Container(
            margin: const EdgeInsets.fromLTRB(
                0.0, 0.0, 0.0, AppValues.marginBottomBox),
            padding: const EdgeInsets.all(AppValues.paddingBox),
            decoration: BoxDecoration(
                border: Border.all(color: greyDarkBorder, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                color: Colors.white),
            child: Column(
              children: [
                SelectIntDm(
                  question: question,
                  listValue: controller.tblDmXepHangDiTich,
                  tenDanhMuc: tableTGDmXepHangDiTich,
                  onChange: (value, dmItem) => controller.onSelectDm(
                      question,
                      question.bangDuLieu!,
                      question.maCauHoi,
                      "A1_8_2",
                      value,
                      dmItem),
                  value: val,
                  hienThiTenCauHoi: false,
                ),
              ],
            ));
      });
    }
    return const SizedBox();
  }

  buildDmLoaiTonGiao(QuestionCommonModel question, selectedValue) {
    if (selectedValue == 17) {
      return Obx(() {
        var val = controller.getValueDmA1_8(columnPhieuTonGiaoA1_6GhiRo);
        return Container(
            margin: const EdgeInsets.fromLTRB(
                0.0, 0.0, 0.0, AppValues.marginBottomBox),
            padding: const EdgeInsets.all(AppValues.paddingBox),
            decoration: BoxDecoration(
                border: Border.all(color: greyDarkBorder, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                color: Colors.white),
            child: Column(
              children: [
                SelectIntDm(
                  key: ValueKey<QuestionCommonModel>(question),
                  question: question,
                  listValue: controller.tblDmLoaiTonGiao,
                  tenDanhMuc: tableDmLoaiTonGiao,
                  onChange: (value, dmItem) => controller.onSelectDm(
                      question,
                      question.bangDuLieu!,
                      question.maCauHoi,
                      columnPhieuTonGiaoA1_6GhiRo,
                      value,
                      dmItem),
                  value: val,
                  titleGhiRoText:
                      "Ghi rõ thuộc loại cơ sở tín ngưỡng hay tôn giáo?",
                  hienThiTenCauHoi: false,
                ),
              ],
            ));
      });
    }
    return const SizedBox();
  }

  ///BEGIN::  Build cho A43; Dành cho các câu chỉ có chi tiêu cột, thêm mới dòng bằng nút Thêm mới
  buildOnlyQuestionChiTieuCot(QuestionCommonModel mainQuestion,
      {ProductModel? product, QuestionCommonModel? parentQuestion}) {
    var chiTieus = mainQuestion.danhSachChiTieu ?? [];

    dynamic recordList = [];
    if (mainQuestion.maCauHoi == 'A4_3') {
      recordList = controller.tblPhieuTonGiaoA43;
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
          const Text('Chưa có sản phẩm.', style: TextStyle(color: errorColor)),
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
              label: const Text("Thêm sản phẩm"),
              onPressed: () => controller.addNewRowPhieuTonGiaoA43(
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
        )
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
                top: 7.0,
                right: 10.0,
                child: ElevatedButton(
                    onPressed: () {
                      controller.deleteA43Item(mainQuestion.bangDuLieu!,
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

    if (recordValue is TablePhieuTonGiaoA43) {
      TablePhieuTonGiaoA43 tablePhieuA43 = recordValue;
      fieldName = '${chiTieuCot.maCauHoi}_${chiTieuCot.maChiTieu}';
      //if(fieldName)
      idValue = tablePhieuA43.id;

      if (fieldName == columnSTT) {
        val = tablePhieuA43.sTT;
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
      } else if (fieldName == columnPhieuTonGiaoA43A4_3_1) {
        val = tablePhieuA43.a4_3_1;
        maxLen =
            chiTieuCot.giaTriLN != null ? chiTieuCot.giaTriLN!.toInt() : 255;
        minLen = chiTieuCot.giaTriNN != null ? chiTieuCot.giaTriNN!.toInt() : 5;
        // maxValue = chiTieuCot.giaTriLN != null ? chiTieuCot.giaTriLN! : 255;
        // minValue = chiTieuCot.giaTriNN != null ? chiTieuCot.giaTriNN! :1;
      } else if (fieldName == columnPhieuTonGiaoA43A4_3_2) {
        val = tablePhieuA43.a4_3_2;
        maxLen = 8;
        minLen = 5;
      } else if (fieldName == columnPhieuTonGiaoA43A4_3_3) {
        val = tablePhieuA43.a4_3_3;
        maxLen = chiTieuCot.giaTriLN != null
            ? chiTieuCot.giaTriLN!.toInt().toString().length
            : 5;
        minLen = chiTieuCot.giaTriNN != null
            ? chiTieuCot.giaTriNN!.toInt().toString().length
            : 1;
        maxValue =
            chiTieuCot.giaTriLN != null ? chiTieuCot.giaTriLN!.toInt() : 1;
        minValue =
            chiTieuCot.giaTriNN != null ? chiTieuCot.giaTriNN!.toInt() : 9999;
      } else if (fieldName == columnPhieuTonGiaoA43A4_3_4) {
        val = tablePhieuA43.a4_3_4;
        maxLen = chiTieuCot.giaTriLN != null
            ? chiTieuCot.giaTriLN!.toInt().toString().length
            : 1;
        minLen = chiTieuCot.giaTriNN != null
            ? chiTieuCot.giaTriNN!.toInt().toString().length
            : 7;
        maxValue =
            chiTieuCot.giaTriLN != null ? chiTieuCot.giaTriLN!.toInt() : 999999;
        minValue =
            chiTieuCot.giaTriNN != null ? chiTieuCot.giaTriNN!.toInt() : 1;
      } else if (fieldName == columnPhieuTonGiaoA43A4_3_5) {
        val = tablePhieuA43.a4_3_5;
        maxLen = chiTieuCot.giaTriLN != null
            ? chiTieuCot.giaTriLN!.toInt().toString().length
            : 1;
        minLen = chiTieuCot.giaTriNN != null
            ? chiTieuCot.giaTriNN!.toInt().toString().length
            : 10;
        maxValue = chiTieuCot.giaTriLN != null
            ? chiTieuCot.giaTriLN!.toInt()
            : 9999999999999;
        minValue =
            chiTieuCot.giaTriNN != null ? chiTieuCot.giaTriNN!.toInt() : 0;
      }
    }

    switch (chiTieuCot.loaiCauHoi) {
      case 2:
        var wFilterInput = RegExp('[0-9]');
        return InputIntChiTieu(
          key: ValueKey(
              '${chiTieuCot.maPhieu}-${chiTieuCot.maCauHoi}-${chiTieuCot.maChiTieu}-${chiTieuCot.sTT}-${idValue!}'),
          onChange: (value) => controller.onChangeInputA43(
              mainQuestion.bangDuLieu!,
              mainQuestion.maCauHoi!,
              fieldName,
              idValue,
              value),
          chiTieuCot: chiTieuCot,
          subName: subName,
          value: val,
          enable: chiTieuCot.tenChiTieu == "STT" ? false : true,
          validator: (String? inputValue) => controller.onValidateInputA43(
              mainQuestion.bangDuLieu!,
              mainQuestion.maCauHoi!,
              fieldName,
              idValue,
              inputValue,
              minLen,
              maxLen,
              minValue,
              maxValue,
              chiTieuCot.loaiCauHoi!,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          warningText: warningTextType4_3(mainQuestion, fieldName, val),
        );
      case 3:
        var wFilterInput = RegExp('[0-9]');
        if (chiTieuCot.maChiTieu == "4" || chiTieuCot.maChiTieu == "5") {
          wFilterInput = RegExp(r'(^\d*\.?\d{0,2})');
        }
        return InputIntChiTieu(
          key: ValueKey(
              '${chiTieuCot.maPhieu}-${chiTieuCot.maCauHoi}-${chiTieuCot.maChiTieu}-${chiTieuCot.sTT}-${idValue!}'),
          onChange: (value) => controller.onChangeInputA43(
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
          validator: (inputValue) => controller.onValidateInputA43(
              mainQuestion.bangDuLieu!,
              mainQuestion.maCauHoi!,
              fieldName,
              idValue,
              inputValue,
              minLen,
              maxLen,
              minValue,
              maxValue,
              chiTieuCot.loaiCauHoi!,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          warningText: warningTextType4_3(mainQuestion, fieldName, val),
          decimalDigits: 2,
        );

      case 4:
        if (fieldName == columnPhieuTonGiaoA43A4_3_2) {
          TablePhieuTonGiaoA43 tPhieuA43 = recordValue;
          return InkWell(
              onTap: () {
                controller.onOpenDialogSearchType(
                    mainQuestion,
                    mainQuestion.maCauHoi!,
                    tPhieuA43,
                    tPhieuA43.id!,
                    tPhieuA43.sTT!,
                    tPhieuA43.a4_3_1 ?? '',
                    val);
              },
              child: IgnorePointer(
                  child: InputStringChiTieuC1(
                key: ValueKey(
                    '${chiTieuCot.maPhieu}-${chiTieuCot.maCauHoi}-${chiTieuCot.maChiTieu}-${chiTieuCot.sTT}-${idValue!}-$val'),
                onChange: (inputValue) => controller.onChangeInputVCPACap5A4_3(
                    mainQuestion.bangDuLieu!,
                    mainQuestion.maCauHoi!,
                    fieldName,
                    idValue,
                    inputValue),
                chiTieuCot: chiTieuCot,
                subName: subName,
                value: val,
                maxLen: maxLen,
                validator: (String? inputValue) =>
                    controller.onValidateInputA43(
                        mainQuestion.bangDuLieu!,
                        mainQuestion.maCauHoi!,
                        fieldName,
                        idValue,
                        inputValue,
                        minLen,
                        maxLen,
                        minValue,
                        maxValue,
                        chiTieuCot.loaiCauHoi!,
                        true),
                warningText: warningTextType4_3(mainQuestion, fieldName, val),
                kieuChiTieu: true,
                suffix: const Icon(
                  Icons.arrow_drop_down,
                  color: primaryColor,
                ),
              )));
          // return Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       RichTextQuestionChiTieu(
          //         chiTieuCot.tenChiTieu ?? '',
          //         level: 3,
          //       ),
          //       SearchVCPACap5(
          //         // listValue: controller.tblDmVsicIO,
          //         onSearch: (pattern) =>
          //             controller.onSearchVcpaCap5A4_3(pattern),
          //         value: val,
          //         key: ValueKey(
          //             '${chiTieuCot.maPhieu}-${chiTieuCot.maCauHoi}-${chiTieuCot.maChiTieu}-${chiTieuCot.sTT}-${idValue!}'),
          //         onChange: (inputValue) =>
          //             controller.onChangeInputVCPACap5A4_3(
          //                 mainQuestion.bangDuLieu!,
          //                 mainQuestion.maCauHoi!,
          //                 fieldName,
          //                 idValue,
          //                 inputValue),
          //         isError: controller.searchResult.value,
          //         validator: (String? inputValue) =>
          //             controller.onValidateInputA43(
          //                 mainQuestion.bangDuLieu!,
          //                 mainQuestion.maCauHoi!,
          //                 fieldName,
          //                 idValue,
          //                 inputValue,
          //                 minLen,
          //                 maxLen,
          //                 minValue,
          //                 maxValue,
          //                 chiTieuCot.loaiCauHoi!,
          //                 true),
          //       )
          //     ]);
        } else {
          return InputStringChiTieuC1(
            key: ValueKey(
                '${chiTieuCot.maPhieu}-${chiTieuCot.maCauHoi}-${chiTieuCot.maChiTieu}-${chiTieuCot.sTT}-${idValue!}'),
            onChange: (inputValue) => controller.onChangeInputA43(
                mainQuestion.bangDuLieu!,
                mainQuestion.maCauHoi!,
                fieldName,
                idValue,
                inputValue),
            chiTieuCot: chiTieuCot,
            subName: subName,
            value: val,
            maxLen: maxLen,
            validator: (String? inputValue) => controller.onValidateInputA43(
                mainQuestion.bangDuLieu!,
                mainQuestion.maCauHoi!,
                fieldName,
                idValue,
                inputValue,
                minLen,
                maxLen,
                minValue,
                maxValue,
                chiTieuCot.loaiCauHoi!,
                true),
            warningText: warningTextType4_3(mainQuestion, fieldName, val),
            kieuChiTieu: true,
            maxLine: 3,
          );
        }
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
            level: mainQuestion.cap!),
        ListView.builder(
            key: ObjectKey(chiTieuCots),
            itemCount: chiTieuDongs.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_, indexIO) {
              ChiTieuDongModel chiTieuIO = chiTieuDongs[indexIO];
              return buildChiTieuDongCotItem(
                  mainQuestion, chiTieuIO, chiTieuCots);
            })
      ],
    );
  }

  buildQuestionChiTieuDongCotA6_2(QuestionCommonModel mainQuestion,
      {ProductModel? product, QuestionCommonModel? parentQuestion}) {
    return Obx(() {
      // if (mainQuestion.maCauHoi == "A6_2") {
      //   var a6_1Value = controller.getValueByFieldName(
      //       mainQuestion.bangDuLieu!, columnPhieuTonGiaoA6_1);
      //   if (a6_1Value != "A" &&
      //       a6_1Value != "F" &&
      //       a6_1Value != "G" &&
      //       a6_1Value != "H") {
      //     return const SizedBox();
      //   }
      // }

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
              level: mainQuestion.cap!),
          ListView.builder(
              key: ObjectKey(chiTieuCots),
              itemCount: chiTieuDongs.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, indexIO) {
                ChiTieuDongModel chiTieuIO = chiTieuDongs[indexIO];
                return buildChiTieuDongCotItem(
                    mainQuestion, chiTieuIO, chiTieuCots);
              })
        ],
      );
    });
  }

  buildChiTieuDongCotItem(QuestionCommonModel mainQuestion,
      ChiTieuDongModel chiTieuDong, List<ChiTieuModel> chiTieuCots) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (chiTieuDong.maSo == '01')
          //   RichTextQuestionChiTieu(
          //     chiTieuDong.tenChiTieu ?? '',
          //     level: 2,
          //   )
          // else
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
                                AppDefine.maChiTieu_1)
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

  renderChiTieuDongCotQuestionByType(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    switch (chiTieuCot.loaiCauHoi) {
      case 2:
        return renderChiTieuDongCotQuestionType2(
            question, chiTieuDong, chiTieuCot);
      case 3:
        return renderChiTieuDongCotQuestionType3(
            question, chiTieuDong, chiTieuCot);
      case 5:
        return renderQuestionType5DmChiTieuDongCot(
            question, chiTieuDong, chiTieuCot, tableDmCoKhong);
      default:
        return Container();
    }
  }

  renderChiTieuDongCotQuestionType2(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    var fieldNameMaCauHoiMaSo =
        controller.getFieldNameByChiTieuDongCot(chiTieuCot, chiTieuDong)!;
    return Obx(() {
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, fieldNameMaCauHoiMaSo);

      return renderChiTieuDongCotType2(question, chiTieuDong, chiTieuCot);
    });
  }

  renderChiTieuDongCotType2ByMaChiTieu(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    var fieldNameMaCauHoiMaSo =
        controller.getFieldNameByChiTieuDongCot(chiTieuCot, chiTieuDong)!;

    var wFilterInput = RegExp('[0-9]');

    return Obx(() {
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, fieldNameMaCauHoiMaSo);

      return renderChiTieuDongCotType2(question, chiTieuDong, chiTieuCot);
    });
  }

  renderChiTieuDongCotType2(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    var fieldNameMaCauHoiMaSo =
        controller.getFieldNameByChiTieuDongCot(chiTieuCot, chiTieuDong)!;
    var wFilterInput = RegExp('[0-9]');
    return Obx(() {
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
              showDvtTheoChiTieuDong:
                  question.buocNhay == 'exit' ? true : false,
              subName: subName,
              enable: (chiTieuDong.loaiCauHoi == AppDefine.loaiCauHoi_9 ||
                      question.buocNhay == 'exit')
                  ? false
                  : true,
              value: val,
              validator: (inputValue) =>
                  controller.onValidateInputChiTieuDongCot(question, chiTieuCot,
                      chiTieuDong, fieldNameMaCauHoiMaSo, inputValue, true),
              flteringTextInputFormatterRegExp: wFilterInput,
              warningText:
                  warningTextType4A2_2(question, chiTieuDong, chiTieuCot, val)),
        ],
      );
    });
  }

  renderChiTieuDongCotQuestionType3(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    var fieldNameMaCauHoiMaSo =
        controller.getFieldNameByChiTieuDongCot(chiTieuCot, chiTieuDong)!;
    //  return Obx(() {
    var val = controller.getValueByFieldName(
        question.bangDuLieu!, fieldNameMaCauHoiMaSo);
    if (question.maCauHoi == "A5_3" || question.maCauHoi == "A6_1") {
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
        controller.getFieldNameByChiTieuDongCot(chiTieuCot, chiTieuDong)!;
    // var wFilterInput = chiTieuCot.maChiTieu == AppDefine.maChiTieu_2
    //     ? RegExp(r'(^\d*\.?\d{0,1})')
    //     : RegExp('[0-9]');
    var wFilterInput = RegExp(r'(^\d*\.?\d{0,2})');

    return Obx(() {
      var val = controller.getValueByFieldName(
          question.bangDuLieu!, fieldNameMaCauHoiMaSo);
      if (question.maCauHoi == "A5_3" || question.maCauHoi == "A6_1") {
        var a4_5_x_xFieldName = '${chiTieuDong.maCauHoi}_${chiTieuDong.maSo}_1';
        var a4_5_x_xValue = controller.getValueByFieldName(
            question.bangDuLieu!, a4_5_x_xFieldName);
        if (a4_5_x_xValue == 1) {
          return renderChiTieuDongCotType3(question, chiTieuDong, chiTieuCot);
        } else {
          return const SizedBox();
        }
      }
      return renderChiTieuDongCotType3(question, chiTieuDong, chiTieuCot);
    });
  }

  renderChiTieuDongCotType3(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot,
      {String? subName, String? value}) {
    var fieldNameMaCauHoiMaSo =
        controller.getFieldNameByChiTieuDongCot(chiTieuCot, chiTieuDong)!;
    // var wFilterInput = chiTieuCot.maChiTieu == AppDefine.maChiTieu_2
    //     ? RegExp(r'(^\d*\.?\d{0,1})')
    var wFilterInput = RegExp('[0-9]');
    int decimalDigits = 0;
    if (question.maCauHoi == "A4_1") {
      wFilterInput = RegExp(r'(^\d*\.?\d{0,2})');
      decimalDigits = 2;
    }
    var isA2_2 = (chiTieuDong.maSo == '01' &&
        question.maCauHoi == "A2_2" &&
        chiTieuCot.maChiTieu == AppDefine.maChiTieu_1);
    var isA4_1 = ((chiTieuDong.maSo == '01' || chiTieuDong.maSo == '02') &&
        question.maCauHoi == "A4_1" &&
        chiTieuCot.maChiTieu == AppDefine.maChiTieu_1);

    // if (isA2_2 || isA4_1) {
    //   return Obx(() {
    //     var totalVal = controller.getValueByFieldName(
    //         question.bangDuLieu!, fieldNameMaCauHoiMaSo);
    //     var dt = DateTime.now().toIso8601String();
    //     return InputIntChiTieu(
    //       // key: ValueKey<ChiTieuDongModel>(chiTieuDong ),
    //       key: ValueKey(
    //           '${chiTieuCot.maPhieu}-${chiTieuCot.maCauHoi}-${chiTieuCot.maChiTieu}-${chiTieuDong.maSo}-$fieldNameMaCauHoiMaSo-$dt-${chiTieuDong.chiTieuIOUUID}'),
    //       type: 'double',
    //       onChange: (value) => {},
    //       chiTieuCot: chiTieuCot,
    //       chiTieuDong: chiTieuDong,
    //       showDvtTheoChiTieuDong: question.buocNhay == 'exit' ? true : false,
    //       subName: subName,
    //       enable: false,
    //       value: totalVal,
    //     );
    //   });
    // }
    if (question.maCauHoi == "A4_1" &&
        (chiTieuDong.maSo == "07.1" || chiTieuDong.maSo == "10")) {
      return Obx(() {
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
                  question.buocNhay == 'exit' ? true : false,
              subName: subName,
              enable: (chiTieuDong.loaiCauHoi == AppDefine.loaiCauHoi_9 ||
                      question.buocNhay == 'exit')
                  ? false
                  : true,
              value: val,
              validator: (inputValue) =>
                  controller.onValidateInputChiTieuDongCot(question, chiTieuCot,
                      chiTieuDong, fieldNameMaCauHoiMaSo, inputValue, true),
              flteringTextInputFormatterRegExp: wFilterInput,
              decimalDigits: decimalDigits,
            ),
            buildChiTieuDongGhiRoA4_1(
                question, val, chiTieuDong, chiTieuCot, fieldNameMaCauHoiMaSo)
          ],
        );
      });
    } else {
      if (question.maCauHoi == "A6_1" || question.maCauHoi == "A5_3") {
        wFilterInput = RegExp(r'(^\d*\.?\d{0,2})');
        decimalDigits = 2;
        if (chiTieuCot.maChiTieu == '3') {
          //  decimalDigits = 0;
        }
      }
      return Obx(() {
        var val = controller.getValueByFieldName(
            question.bangDuLieu!, fieldNameMaCauHoiMaSo);
        return InputIntChiTieu(
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
              (question.maCauHoi == 'A6_1' && chiTieuCot.maChiTieu == '2')
                  ? true
                  : false,
          subName: subName,
          enable: (chiTieuDong.loaiCauHoi == AppDefine.loaiCauHoi_9 ||
                  question.buocNhay == 'exit')
              ? false
              : true,
          value: val,
          validator: (inputValue) => controller.onValidateInputChiTieuDongCot(
              question,
              chiTieuCot,
              chiTieuDong,
              fieldNameMaCauHoiMaSo,
              inputValue,
              true),
          flteringTextInputFormatterRegExp: wFilterInput,
          decimalDigits: decimalDigits,
          warningText:
              warningTextTypeA4_1(question, chiTieuDong, chiTieuCot, val),
        );
      });
    }
  }

  buildChiTieuDongGhiRoA4_1(QuestionCommonModel question, inputValue,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot, String fieldName) {
    if (chiTieuDong.maSo == '07.1' || chiTieuDong.maSo == '10') {
      if (inputValue != null && inputValue != '' && inputValue > 0) {
        var fieldNameGhiRo = '${fieldName}_GhiRo';
        var ghiRoValue = controller.getValueByFieldName(
            question.bangDuLieu!, fieldNameGhiRo);

        return InputStringDm(
          key: ValueKey('${question.cauHoiUUID}${question.maCauHoi}'),
          question: question,
          onChange: (value) => controller.onChangeChiTieuDongGhiRo(
              question, value, fieldNameGhiRo),
          titleText: 'Ghi rõ',
          level: 3,
          value: ghiRoValue,
          validator: (inputValue) => controller.onValidate(question.bangDuLieu!,
              question.maCauHoi!, fieldNameGhiRo, inputValue, 5, 250, 4, true),
        );
      }
    }
    return const SizedBox();
  }

  renderQuestionType5DmChiTieuDongCot(
      QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong,
      ChiTieuModel chiTieuCot,
      String tenDanhMuc) {
    return Obx(() {
      var fieldName =
          controller.getFieldNameByChiTieuDongCot(chiTieuCot, chiTieuDong);
      var val = controller.getValueByFieldName(question.bangDuLieu!, fieldName);
      var dmChiTieu = controller.getDanhMucByTenDm(tenDanhMuc) ?? [];

      return Column(
        children: [
          SelectIntCTDm(
            key: ValueKey(
                '${question.cauHoiUUID}_${chiTieuDong.maSo}_${chiTieuCot.maChiTieu}_$val'),
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
          buildGhiRo(question, val),
        ],
      );
    });
  }

  warningTextType4(QuestionCommonModel question, value) {
    if (question.maCauHoi == columnPhieuTonGiaoA1_1) {
      if (controller.validateNotEmptyString(value) &&
          value!.length >= 3 &&
          value!.length < 5) {
        return 'Cảnh báo: Tên cơ sở quá ngắn.';
      }
    } else if (question.maCauHoi == columnPhieuTonGiaoA1_2) {
      if (controller.validateNotEmptyString(value) &&
          value!.length >= 3 &&
          value!.length < 5) {
        return 'Cảnh báo: Địa chỉ cơ sở quá ngắn.';
      }
    } else if (question.maCauHoi == columnPhieuTonGiaoA1_5_1) {
      if (controller.validateNotEmptyString(value) &&
          value!.length >= 3 &&
          value!.length < 5) {
        return 'Cảnh báo: Họ và tên chủ cơ sở quá ngắn.';
      }
    } else if (question.maCauHoi == columnPhieuTonGiaoA1_5_2) {
      if (controller.validateNotEmptyString(value) &&
          value!.length >= 3 &&
          value!.length < 5) {
        return 'Cảnh báo: Phẩm sắc tôn giáo người đứng đầu cơ sở mô tả quá ngắn.';
      }
    } else if (question.maCauHoi == columnPhieuTonGiaoA1_5_4) {
      if ((controller.validateNotEmptyString(value.toString()) &&
          !controller.validate0InputValue(value))) {
        var currTMin = DateTime.now().year - 18;
        var currTMax = DateTime.now().year - 103;

        if (value > currTMin) {
          return 'Cảnh báo: Năm sinh $value đang nhỏ hơn 18 tuổi.';
        } else if (value < currTMax) {
          return 'Cảnh báo: Năm sinh $value đang lớn hơn 103 tuổi.';
        }
      }
    } else if (question.maCauHoi == "A2_1") {
      if (controller.validateNotEmptyString(value.toString()) &&
          !controller.validate0InputValue(value) &&
          value > 30) {
        return 'Cảnh báo: Số lao động quá nhiều $value > 30 người.';
      }
    } else if (question.maCauHoi == "A2_1_1") {
      if (controller.validateNotEmptyString(value.toString()) &&
          !controller.validate0InputValue(value) &&
          value > 30) {
        return 'Cảnh báo: Số lao động nữ quá nhiều $value > 30 người.';
      }
    }

    return '';
  }

  warningTextType4A2_2(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot, value) {
    if (question.maCauHoi == "A2_2" &&
        chiTieuDong.maSo == '04' &&
        chiTieuCot.maChiTieu == '1') {
      if (controller.validateNotEmptyString(value.toString()) &&
          !controller.validate0InputValue(value) &&
          value > 30) {
        return 'Cảnh báo: Số lao động nữ quá nhiều $value > 30 người.';
      }
    }
    return '';
  }

  warningTextType3(QuestionCommonModel question, value) {
    if (question.maCauHoi == "A3_1") {
      if (controller.validateNotEmptyString(value.toString()) &&
          !controller.validate0InputValue(value) &&
          value > 100000) {
        return 'Cảnh báo: Diện tích đất của cơ sở > 100.000 m2 có đúng không?';
      }
    } else if (question.maCauHoi == "A3_2") {
      if (controller.validateNotEmptyString(value.toString()) &&
          !controller.validate0InputValue(value) &&
          value > 100000) {
        return 'Cảnh báo: Diện tích xây dựng của cơ sở >100.000 m2 có đúng không?';
      }
    }
    return '';
  }

  warningTextTypeA4_1(QuestionCommonModel question,
      ChiTieuDongModel chiTieuDong, ChiTieuModel chiTieuCot, value) {
    if (question.maCauHoi == "A4_1") {
      if (chiTieuDong.maSo == '01' && chiTieuCot.maChiTieu == '1') {
        //01>100 000
        if (controller.validateNotEmptyString(value.toString()) &&
            !controller.validate0InputValue(value) &&
            value > 100000) {
          return 'Cảnh báo: Tổng chi trong năm 2024 của cơ sở là $value triệu đồng > 100 tỷ?';
        }
      }
      if (chiTieuDong.maSo == '02' && chiTieuCot.maChiTieu == '1') {
        //01>100
        if (controller.validateNotEmptyString(value.toString()) &&
            !controller.validate0InputValue(value) &&
            value > 100) {
          return 'Cảnh báo: Chi hoạt động quản lý cơ sở là $value triệu đồng > 100 triệu quá cao';
        }
        if (controller.validateNotEmptyString(value.toString()) &&
            !controller.validate0InputValue(value) &&
            value < 10) {
          var a2_2_01TongSoLD = controller.getValueByFieldName(
              question.bangDuLieu!, columnPhieuTonGiaoA2_2_01);
          if (controller.validateNotEmptyString(a2_2_01TongSoLD.toString()) &&
              !controller.validate0InputValue(a2_2_01TongSoLD) &&
              a2_2_01TongSoLD >= 10) {
            return 'Cảnh báo: Số lao động của cơ sở là A2.2_Tổng số lao động là $a2_2_01TongSoLD mà chi hoạt động quản lý vận hành cơ sở năm 2024 là $value triệu đồng quá ít';
          }
        }
      }
      if (chiTieuDong.maSo == '03' && chiTieuCot.maChiTieu == '1') {
        if (controller.validateNotEmptyString(value.toString()) &&
            controller.validate0InputValue(value)) {
          return 'Cảnh báo: Chi phí điện nước chất đốt của cơ sở = 0';
        }
      }
      if (chiTieuDong.maSo == '04' && chiTieuCot.maChiTieu == '1') {
        if (controller.validateNotEmptyString(value.toString()) &&
            controller.validate0InputValue(value)) {
          return 'Cảnh báo: Chi mua đồ lễ, tổ chức hành lễ (nến, hương, hoa…) = 0';
        }
      }
      if (chiTieuDong.maSo == '08' && chiTieuCot.maChiTieu == '1') {
        //08 > 50 tỷ (50 000)
        if (controller.validateNotEmptyString(value.toString()) &&
            !controller.validate0InputValue(value) &&
            value > 50000) {
          return 'Cảnh báo: Chi xây dựng cơ bản, mua sắm TSCĐ, sửa chữa lớn của cơ sở là $value triệu đồng quá cao > 50 tỷ';
        }
      }
      if (chiTieuDong.maSo == '09' && chiTieuCot.maChiTieu == '1') {
        //09 > 10 tỷ (10 000)
        if (controller.validateNotEmptyString(value.toString()) &&
            !controller.validate0InputValue(value) &&
            value > 10000) {
          return 'Cảnh báo: Chi Chi cho hoạt động từ thiện của cơ sở là $value triệu đồng quá cao > 10 tỷ';
        }
      }
      if (chiTieuDong.maSo == '10' && chiTieuCot.maChiTieu == '1') {
        //10 > 10 tỷ (10 000)
        if (controller.validateNotEmptyString(value.toString()) &&
            !controller.validate0InputValue(value) &&
            value > 10000) {
          return 'Cảnh báo: Chi Các khoản chi khác của cơ sở là $value triệu đồng quá cao > 10 tỷ';
        }
      }
    }
    return '';
  }

  buildWarningText(QuestionCommonModel question, selectedValue) {
    if (question.maCauHoi == columnPhieuTonGiaoA1_5_6) {
      if (selectedValue == 1) {
        var a1_5_2val = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuTonGiaoA1_5_2);

        if (controller.validateNotEmptyString(a1_5_2val)) {
          var tblTDCM = controller.tblDmTrinhDoChuyenMon
              .where((x) => x.ma == selectedValue)
              .firstOrNull;
          String selectedText = tblTDCM!.ten ?? '';
          return Text(
            'Cảnh báo: Người đứng đầu cơ sở có phẩm sắc tôn giáo mà trình độ chuyên môn kỹ thuật chưa qua đào tạo ($selectedText).',
            style: const TextStyle(color: Colors.orange),
          );
        }
      }
      return const SizedBox();
    }
    if (question.maCauHoi == columnPhieuTonGiaoA1_7) {
      if (controller.a1_7MaWarningL1.contains(selectedValue)) {
        var a1_6val = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuTonGiaoA1_6);
        if (controller.a1_6MaWarningL1.contains(a1_6val)) {
          var tblDmA1_6 = controller.tblDmLoaiCoSo
              .where((x) => x.ma == a1_6val)
              .firstOrNull;
          String selectedTextA1_6 = tblDmA1_6!.ten ?? '';

          return Text(
            'Cảnh báo: Cơ sở là $selectedTextA1_6 nhưng loại hình tôn giáo không phải phật giáo (A1.7= 2|3|6|7|13|14|16).',
            style: const TextStyle(color: Colors.orange),
          );
        }
      }
      if (controller.a1_7MaWarningL2.contains(selectedValue)) {
        var a1_6val = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuTonGiaoA1_6);
        if (controller.a1_6MaWarningL2.contains(a1_6val)) {
          var tblDmA1_6 = controller.tblDmLoaiCoSo
              .where((x) => x.ma == a1_6val)
              .firstOrNull;
          String selectedTextA1_6 = tblDmA1_6!.ten ?? '';

          return Text(
            'Cảnh báo: cơ sở là $selectedTextA1_6 nhưng loại hình tôn giáo là phật giáo (A1.7 = 1|5|8|9|10|11|15)',
            style: const TextStyle(color: Colors.orange),
          );
        }
      }
    }
    if (question.maCauHoi == "A1_8") {
      if (selectedValue == 2) {
        var a1_6val = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuTonGiaoA1_6);
        if ((a1_6val != null && a1_6val == 5) ||
            (a1_6val != null && a1_6val == 11)) {
          var tblDmA1_6 = controller.tblDmLoaiCoSo
              .where((x) => x.ma == a1_6val)
              .firstOrNull;
          String selectedTextA1_6 = tblDmA1_6!.ten ?? '';

          return Text(
            'Cảnh báo: Cơ sở là $selectedTextA1_6 nhưng được xếp hạng di tích.',
            style: const TextStyle(color: Colors.orange),
          );
        }
      }
    }
    if (question.maCauHoi == columnPhieuTonGiaoA5_4) {
      if (selectedValue == 2) {
        var a5_3_1val = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuTonGiaoA5_3_1_1);
        var a5_3_2val = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuTonGiaoA5_3_2_1);
        var a5_3_3val = controller.getValueByFieldName(
            question.bangDuLieu!, columnPhieuTonGiaoA5_3_3_1);
        if ((a5_3_1val != null && a5_3_1val == 1) ||
            (a5_3_2val != null && a5_3_2val == 2) ||
            (a5_3_3val != null && a5_3_3val == 2)) {
          return const Text(
            'Cảnh báo: Cơ sở có sử dụng phần mềm quản lý phục vụ cho các hoạt động của cơ sở (A5.3=1|2|3) mà không sử dụng biện pháp an toàn, an ninh mạng (A5.4=2).',
            style: TextStyle(color: Colors.orange),
          );
        }
      }
    }
    return const SizedBox();
  }

  warningTextType4_3(QuestionCommonModel question, String fieldName, value) {
    if (question.maCauHoi == "A4_3") {
      if (fieldName == columnPhieuTonGiaoA43A4_3_1) {
        if (controller.validateNotEmptyString(value.toString()) &&
            value!.length < 10) {
          return 'Cảnh báo: Mô tả hoạt động quá ngắn.';
        }
      } else if (fieldName == columnPhieuTonGiaoA43A4_3_3) {
        if (controller.validateNotEmptyString(value.toString()) &&
            value > 100) {
          return 'Cảnh báo: Lao động quá cao >100 người.';
        }
      } else if (fieldName == columnPhieuTonGiaoA43A4_3_4) {
        //Nếu Chi phí trực tiếp cho hoạt động > 50 tỷ
        if (controller.validateNotEmptyString(value.toString()) &&
            value > 50000) {
          return 'Cảnh báo: Chi phí trực tiếp cho hoạt động quá cao > 50 tỷ';
        }
      } else if (fieldName == columnPhieuTonGiaoA43A4_3_5) {
        //Nếu Chi phí trực tiếp cho hoạt động > 50 tỷ
        if (controller.validateNotEmptyString(value.toString()) &&
            value > 50000) {
          return 'Cảnh báo: Giá trị mua hàng hóa bán lại quá cao>50 tỷ';
        }
      }
    }

    return '';
  }

  warningTextTypeGhiRo(QuestionCommonModel question, String fieldName, value) {
    if (question.maCauHoi == "A5_2") {
      if (fieldName == columnPhieuTonGiaoA5_2GhiRo) {
        if (controller.validateNotEmptyString(value.toString()) &&
            value!.length < 5) {
          return 'Cảnh báo: Địa chỉ truy cập trang thông tin cơ sở quá ngắn.';
        }
      }
    }

    return '';
  }
}
