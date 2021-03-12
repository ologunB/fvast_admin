import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fvast_admin/utils/spacing.dart';
import 'dart:io';

import 'custom_text_widget.dart';

class CustomButton extends StatefulWidget {
  final String title;
  final GestureTapCallback onPressed;
  bool busy;
  final Color textColor;
  final Color buttonColor;
  final double fontSize;
  final double height;

  CustomButton({
    Key key,
    @required this.title,
    this.busy = false,
    @required this.onPressed,
    this.textColor = const Color(0xffffffff),
    this.buttonColor = const Color(0xff0D562D),
    this.fontSize = 16, this.height,

  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Material(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            // side: BorderSide(color: Colors.red)
          ),
          color: widget.buttonColor,
          child: InkWell(
            onTap: widget.onPressed,
            child: Container(
                width: screenWidth(context),
                height: widget.height,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                decoration: BoxDecoration(
                  //   color: Color(0xff245DE8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: widget.busy
                    ? Platform.isIOS
                        ? CupertinoActivityIndicator(radius: 12)
                        : CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                    : CustomText(
                        text: widget.title,
                        color: widget.textColor,
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.w600,
                      )),
          )),
    );
  }
}
