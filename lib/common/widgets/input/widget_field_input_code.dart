import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gov_tongdtkt_tongiao/config/config.dart';

class WidgetFieldInputCode extends StatelessWidget {
  const WidgetFieldInputCode({
    super.key,
    required this.controller,
    required this.hint,
    this.validator,
    this.label,
    this.prefix,
    this.suffix,
    this.bgColor,
    this.isHideContent,
    this.enable,
    this.keyboardType,
    this.onChanged,
    this.inputFormatters,
    this.maxLength,
    this.maxLine = 1,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hint;
  final String? label;
  final Widget? prefix;
  final Widget? suffix;
  final Color? bgColor;
  final bool? isHideContent;
  final bool? enable;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? maxLine;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null ? Text(label!, style: styleSmall) : const SizedBox(),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppValues.borderLv1),
          ),
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            child: TextFormField(
              textAlign: TextAlign.center,
              maxLength: maxLength,
              controller: controller,
              style:  (enable != null && enable != true )? styleSmall.copyWith(color: disabledblackText):styleSmall,
              obscureText: isHideContent ?? false,
              enabled: enable ?? true,
              validator: validator,
              maxLines: maxLine,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                 
                prefixIcon: prefix,
                suffixIcon: suffix,
                hintText: hint,
                errorMaxLines: 2,
                fillColor: bgColor ??
                    (enable != null && enable != true
                        ? backgroundDisableColor
                        : backgroundWhiteColor),
                filled: true,
                contentPadding:
                    const EdgeInsets.only(top: 4, left: 16, right: 16),
                hintStyle: styleSmall.copyWith(color: greyColor),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: BorderSide(
                    color: (enable != null && enable != true)
                        ? greyBorder
                        : primaryLightColor,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: BorderSide(
                    color: (enable != null && enable != true)
                        ? greyBorder
                        : primaryColor,
                    width: 1.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: const BorderSide(
                    color: errorColor,
                    width: 1.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: const BorderSide(
                    color: errorColor,
                    width: 1.0,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppValues.borderLv1),
                  borderSide: const BorderSide(
                    color: greyBorder,
                    width: 1.0,
                  ),
                ),
              ),
              keyboardType: keyboardType,
              onChanged: onChanged,
              inputFormatters: inputFormatters,
            ),
          ),
        ),
      ],
    );
  }
}
