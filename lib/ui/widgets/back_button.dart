
import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final Color color;

  const BackButtonWidget({Key key, this.color = const Color(0xffffffff)}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(40), color: color),
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.only(left: 8),
          child: Icon(Icons.arrow_back_ios, size: 18)));
}
