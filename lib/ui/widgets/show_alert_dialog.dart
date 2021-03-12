import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fvast_admin/constants/styles.dart';
import 'package:google_fonts/google_fonts.dart';

// Querying the environment via [Plattform] throws and exception on Flutter web
// This extension adds a new [isWeb] getter that should be used
// before checking for any of the other environments

Future<bool> showAlertDialog({
  @required BuildContext context,
  @required String title,
  @required String content,
  String cancelActionText,
  @required String defaultActionText,
}) async {
  if (!Platform.isIOS) {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          title,
          style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: title.contains("Error") ? Colors.red : Colors.black),
        ),
        content: Text(
          content,
          style: GoogleFonts.nunito(
              fontSize: 16, fontWeight: FontWeight.w600, color: Styles.colorBlack),
        ),
        actions: <Widget>[
          cancelActionText != null
              ? FlatButton(
                  child: Text(
                    cancelActionText,
                    style: GoogleFonts.nunito(
                        fontSize: 12,
                        letterSpacing: 1,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                )
              : Container(),
          FlatButton(
            child: Text(
              defaultActionText,
              style: GoogleFonts.nunito(
                  fontSize: 12, letterSpacing: 1, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
  return await showCupertinoDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        title,
        style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: title.contains("Error") ? Colors.red : Colors.black),
      ),
      content: Text(
        content,
        style:
            GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600, color: Styles.colorBlack),
      ),
      actions: <Widget>[
        cancelActionText != null
            ? CupertinoDialogAction(
                child: Text(
                  cancelActionText,
                  style: GoogleFonts.nunito(
                      fontSize: 12,
                      letterSpacing: 1,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.of(context).pop(false),
              )
            : Container(),
        CupertinoDialogAction(
          child: Text(
            defaultActionText,
            style: GoogleFonts.nunito(
                fontSize: 12, letterSpacing: 1, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}
