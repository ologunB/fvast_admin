import 'package:flutter/cupertino.dart';
//import 'package:intl/intl.dart';

abstract class Util {
  static bool isValidPhone(String phone) {
    return phone != null && phone.length == 11 && phone.startsWith("0");
  }

  static bool isValidOtp(String num) {
    return num != null && num.length == 4;
  }
  static bool isValidPassword(String password) {
    return password.length > 6;
  }

  static String isValidName(String value) {
    if (value.isEmpty) {
      return 'Field cannot be Empty!';
    }
    return null;
  }

  static String validateEmail(value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    } else if (value.isEmpty) {
      return 'Please enter your email!';
    } else
      return null;
  }

  static void offKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
      return;
    }
    currentFocus.unfocus();
  }

 /* static String timeFormatter(String time) {
    return DateFormat("EEE, MMM dd-yyyy, HH:mm a").format(DateTime.parse(time));
  }*/

  static String timeConvert(int d) {
    if (d == 1) {
      return "1 sec";
    } else if (d < 120)
      return "1 min";
    else if (d > 60 && d < 3600)
      return "${(d / 60).floor()} mins";
    else
      return "1 Hour";
  }
}
