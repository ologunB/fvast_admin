import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final double leftMargin;
  final double topMargin;
  final double rightMargin;
  final double bottomMargin;
  final bool centerText;

  const CustomText(
      {Key key,
      this.text,
      this.fontSize,
      this.fontWeight,
      this.centerText = false,
      this.color,
      this.leftMargin = 0.0,
      this.topMargin = 0.0,
      this.rightMargin = 0.0,
      this.bottomMargin = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(leftMargin, topMargin, rightMargin, bottomMargin),
      child: Text(
        text,//overflow: TextOverflow.ellipsis,
        textAlign: centerText ? TextAlign.center : null,
        style: GoogleFonts.nunito(fontSize: fontSize, fontWeight: fontWeight, color: color),
      ),
    );
  }
}
