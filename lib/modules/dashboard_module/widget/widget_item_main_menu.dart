import 'package:flutter/material.dart';
import 'package:gov_tongdtkt_tongiao/config/config.dart';

class WidgetItemMainMenu extends StatelessWidget {
  const WidgetItemMainMenu({
    Key? key,
    required this.name,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final String name;
  final String icon;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(AppValues.padding),
        decoration: BoxDecoration(
            color: primaryColorMenuItem,
            borderRadius: BorderRadius.circular(AppValues.borderLv2),
            boxShadow: [
              BoxShadow(
                color:primaryColorMenuItemShadow,
                offset: const Offset(0, 10),
                spreadRadius: 5,
                blurRadius: 20,
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _itemBorder(),
            const SizedBox(height: 8),
            Text(
              name,
              style: styleSmallBold.copyWith(color: defaultPrimaryText),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget _itemBorder() {
    return Container(
      padding: const EdgeInsets.all(AppValues.padding / 2),
      decoration: BoxDecoration(
          color: primaryColorMenuIcon,
          borderRadius: BorderRadius.circular(AppValues.borderLv2)),
      child: Image.asset(icon),
    );
  }
}
