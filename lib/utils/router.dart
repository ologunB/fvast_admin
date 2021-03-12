import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

routeTo(BuildContext context, Widget view, {bool dialog = false}) {
  Navigator.push(
      context,
      Platform.isIOS
          ? CupertinoPageRoute(builder: (context) => view, fullscreenDialog: dialog)
          : MaterialPageRoute(builder: (context) => view, fullscreenDialog: dialog));
}

routeToReplace(BuildContext context, Widget view) {
  Navigator.pushAndRemoveUntil(
      context,
      Platform.isIOS
          ? CupertinoPageRoute(builder: (context) => view)
          : MaterialPageRoute(builder: (context) => view),
      (route) => false);
}
