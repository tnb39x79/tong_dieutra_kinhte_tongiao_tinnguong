import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gov_tongdtkt_tongiao/common/common.dart';
import 'package:gov_tongdtkt_tongiao/resource/resource.dart';

class SelectMultipleInt extends StatefulWidget {
  final QuestionCommonModel question;
  final Function(List<int>) onChange;
  final List<ChiTieuIntModel> listValue;
  final Function()? onFinish;
  final String? value;

  const SelectMultipleInt({
    super.key,
    required this.question,
    required this.onChange,
    required this.listValue,
    this.value,
    this.onFinish,
  });

  @override
  SelectMultipleIntState createState() => SelectMultipleIntState();
}

class SelectMultipleIntState extends State<SelectMultipleInt> {
  final List<int> _values = [];

  @override
  void initState() {
    if (widget.value != null && widget.value != "") {
      var valueSelected = widget.value!.split(';');
      for (var element in valueSelected) {
        _values.add(int.parse(element));
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextQuestion(widget.question.tenCauHoi ?? ''),
        _buildValues(),
      ],
    );
  }

  Widget _buildValues() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.listValue.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          ChiTieuIntModel item = widget.listValue[index];
          var name = widget.listValue[index].tenChiTieu!.split('>>');

          return CheckBoxRectangle(
            text: name[0],
            index: index,
            currentIndex: -1,
            showIndex: false,
            isSelected: _values.contains(item.maChiTieu),
            onPressed: (value) {
              int _val = item.maChiTieu ?? 0;
              if (index == widget.listValue.length - 1 &&
                  widget.onFinish != null) {
                log('ONFINISH');
                widget.onFinish!();
              } else {
                setState(() {
                  if (!_values.contains(_val)) {
                    _values.add(_val);
                  } else {
                    _values.remove(_val);
                  }

                  widget.onChange(_values);
                });
              }
            },
          );
        });
  }
}
