import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String title, String msg,
    {int duration = 6, Color color = Colors.grey}) {
  Flushbar(
    title: title,
    message: msg,
    margin: EdgeInsets.all(8),
    flushbarStyle: FlushbarStyle.FLOATING,
    flushbarPosition: FlushbarPosition.TOP,
    duration: Duration(seconds: duration),
    borderRadius: 8,
    backgroundColor: title == "Error" ? Colors.red : color,
  ).show(context);
}