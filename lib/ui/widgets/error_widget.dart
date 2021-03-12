import 'package:flutter/material.dart';
 import 'package:fvast_admin/constants/styles.dart';

import 'custom_text_widget.dart';

class ErrorOccurredWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error,
          size: 40,
          color: Styles.appCanvasBlue,
        ),
        CustomText(
            text: "An error occurred",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Styles.appCanvasBlue),
      ],
    ));
  }
}
