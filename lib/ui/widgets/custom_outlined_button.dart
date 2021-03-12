import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fvast_admin/utils/spacing.dart';

import 'custom_text_widget.dart';

class CustomOutlinedButton extends StatefulWidget {
  final String title;
  final GestureTapCallback onPressed;
  final Color textColor;
  final Color buttonColor;
  final Color borderColor;
  final double fontSize;
  final double height;
  final IconData iconData;

  CustomOutlinedButton({
    Key key,
    @required this.title,
    @required this.onPressed,
    this.textColor = const Color(0xff0D562D),
    this.borderColor = const Color(0xff0D562D),
    this.buttonColor = const Color(0xffffffff),
    this.fontSize = 16,
    this.iconData, this.height,
  }) : super(key: key);

  @override
  _CustomOutlinedButtonState createState() => _CustomOutlinedButtonState();
}

class _CustomOutlinedButtonState extends State<CustomOutlinedButton> {
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
              side: BorderSide(color: widget.borderColor, width: 1.2)),
          color: widget.buttonColor,
          child: InkWell(
            onTap: widget.onPressed,
            child: Container(
                width: screenWidth(context),
                height: widget.height,
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
                decoration: BoxDecoration(
                  //   color: Color(0xff245DE8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    widget.iconData == null
                        ? SizedBox()
                        : Icon(widget.iconData, color: widget.textColor),
                    Expanded(
                      child: Center(
                        child: CustomText(
                          text: widget.title,
                          color: widget.textColor,
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                )),
          )),
    );
  }
}
