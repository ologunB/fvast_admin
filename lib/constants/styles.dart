import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static Color appCanvasBlue = Color(0xff14A2EA);
  static Color colorWhite = Colors.white;
  static Color colorBlack = Color(0xff222222);
  static Color colorRed = Color(0xffEC0000);
  static Color colorLemon = Color(0xff32D74B);
  static Color colorGreyDark = Color(0xff222222).withOpacity(.5);
  static Color colorGreyLight = Color(0xff222222).withOpacity(.05);

  static InputDecoration inputDec1 = InputDecoration(
    contentPadding: EdgeInsets.all(8),
    fillColor: Styles.colorGreyDark.withOpacity(0.05),
    filled: true,
    labelStyle:
        GoogleFonts.nunito(color: Styles.colorGreyDark, fontWeight: FontWeight.w600, fontSize: 16),
    errorStyle: TextStyle(
      color: Color(0xff222222),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff082485), width: 1.7),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Styles.colorBlack.withOpacity(0.2), width: 2),
    ),
    border: OutlineInputBorder(),
    counterText: '',
  );
}
