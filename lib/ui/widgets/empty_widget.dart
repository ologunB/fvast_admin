import 'package:flutter/material.dart';
import 'package:fvast_admin/constants/styles.dart';

import 'custom_text_widget.dart';

class EmptyWidget extends StatelessWidget {
  final String text;

  const EmptyWidget({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.hourglass_empty,
          size: 30,
          color: Styles.appCanvasBlue,
        ),
        CustomText(
            text: text,
            centerText: true,

            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Styles.colorGreyDark),
      ],
    ));
  }
}
