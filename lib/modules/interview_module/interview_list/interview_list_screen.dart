import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_tongdtkt_tongiao/common/common.dart';
import 'package:gov_tongdtkt_tongiao/common/widgets/categories/widget_row_item.dart';
import 'package:gov_tongdtkt_tongiao/config/config.dart';
import 'package:gov_tongdtkt_tongiao/modules/modules.dart';

///Danh sách phỏng vấn:
///Gồm:
/// 1. currentMaDoiTuongDT=4
/// - Xã chưa phỏng vấn
/// - Xã đã phỏng vấn
/// hoặc
/// 2. currentMaDoiTuongDT=4
/// - Hộ chưa phỏng vấn
/// - Hộ đã phỏng vấn
class InterviewListScreen extends GetView<InterviewListController> {
  const InterviewListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingFullScreen(
      loading: controller.loadingSubject,
      child: Scaffold(
        appBar: AppBarHeader(
          title: 'interview_list'.tr,
          onPressedLeading: () => Get.back(),
          iconLeading: const Icon(Icons.arrow_back_ios_new_rounded),
          subTitle: controller.getSubTitle(),
          //   backAction: () => controller.backInterviewObjectList(),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: AppValues.padding),
            WidgetRowItem(
              title: 'un_interviewed'.trParams({
                'param': (controller.currentMaDoiTuongDT ==
                            '${AppDefine.maDoiTuongDT_07Mau}' ||
                        controller.currentMaDoiTuongDT ==
                            '${AppDefine.maDoiTuongDT_07TB}')
                    ? 'coso'.tr
                    : 'commune'.tr,
              }),
              count: controller.countOfUnInterviewed.value,
              onPressed: () =>
                  controller.toInterViewListDetail(AppDefine.chuaPhongVan),
              subTextColor: textDarkGreenColor,
            ),
            WidgetRowItem(
                title: 'interviewed'.trParams({
                  'param': (controller.currentMaDoiTuongDT ==
                              '${AppDefine.maDoiTuongDT_07Mau}' ||
                          controller.currentMaDoiTuongDT ==
                              '${AppDefine.maDoiTuongDT_07TB}')
                      ? 'coso'.tr
                      : 'commune'.tr,
                }),
                count: controller.countOfInterviewed.value,
                onPressed: () =>
                    controller.toInterViewListDetail(AppDefine.dangPhongVan),
                subTextColor: textDarkGreenColor,),
                
          ],
        ),
      );
    });
  }
}
