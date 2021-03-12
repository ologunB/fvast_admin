import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fvast_admin/constants/styles.dart';
import 'package:fvast_admin/ui/views/login_screen.dart';
import 'package:fvast_admin/utils/router.dart';
import 'package:fvast_admin/utils/spacing.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    User user = FirebaseAuth.instance.currentUser;

    Future.delayed(Duration(seconds: 3)).then((value) {
      if (user == null) {
        routeToReplace(context, LoginScreen());
      } else {
        routeToReplace(context, HomeScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Styles.colorWhite,
        body: Center(child: Image.asset("images/logo.png", width: screenWidth(context) / 2)));
  }
}
