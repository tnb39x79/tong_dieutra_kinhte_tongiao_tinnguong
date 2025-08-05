import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gov_tongdtkt_tongiao/config/config.dart';

class WidgetRowItem extends StatelessWidget {
  const WidgetRowItem({
    Key? key,
    required this.title,
    required this.count,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final int count;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          AppValues.padding,
          0,
          AppValues.padding,
          AppValues.padding,
        ),
        padding: const EdgeInsets.all(AppValues.padding),
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppValues.borderLv2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _info()),
            _iconActions(),
          ],
        ),
      ),
    );
  }

  Widget _info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _titleTop(),
        _titleBottom(),
      ],
    );
  }

  Widget _iconActions() {
    return const Icon(Icons.arrow_forward_ios_rounded, color: greyBorder);
  }

  Widget _titleTop() {  
    return Text(title, style: styleMediumBold);
  }

  Widget _titleBottom() {
    return RichText(
      text: TextSpan(
        text: 'count'.tr,
        style: styleMedium.copyWith(color: warningColor, fontWeight: FontWeight.w400),
        children: <TextSpan>[
          TextSpan(
            text: '$count',
            style: styleMediumBold.copyWith(color: warningColor),
          ),
        ],
      ),
    );
  }
}
