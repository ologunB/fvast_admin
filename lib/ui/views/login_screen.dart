import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fvast_admin/constants/styles.dart';
import 'package:fvast_admin/ui/views/home_screen.dart';
import 'package:fvast_admin/ui/widgets/custom_button.dart';
import 'package:fvast_admin/ui/widgets/custom_text_widget.dart';
import 'package:fvast_admin/ui/widgets/custom_textfield.dart';
import 'package:fvast_admin/ui/widgets/show_exception_alert_dialog.dart';
import 'package:fvast_admin/ui/widgets/snackbar.dart';
import 'package:fvast_admin/utils/router.dart';
import 'package:fvast_admin/utils/spacing.dart';
import 'package:fvast_admin/utils/util.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _riderLoginKey = GlobalKey<FormState>();
  bool formValid = false;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.colorWhite,
      body: LoadingOverlay(
        isLoading: isLoading,
        progressIndicator: SpinKitFadingCube(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Styles.colorWhite : Styles.appCanvasBlue,
              ),
            );
          },
          size: 40,
        ),
        color: Colors.grey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _riderLoginKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                verticalSpaceMedium,
                SafeArea(
                    child: Center(
                        child: Image.asset("images/logo.png", width: screenWidth(context) / 3))),
                CustomText(
                  text: 'ADMIN SIGNUP',
                  fontSize: 24.0,
                  fontWeight: FontWeight.w800,
                  color: Styles.colorGreyDark,
                ),
                verticalSpaceLarge,
                CustomTextField(
                  inputType: TextInputType.emailAddress,
                  controller: emailController,
                  inputAction: TextInputAction.done,
                  maxLines: 1,
                  labelText: 'Email Address',
                  validator: Util.validateEmail,
                  onChanged: (a) {
                    formValid = _riderLoginKey.currentState.validate();
                    setState(() {});
                  },
                ),
                verticalSpaceMedium,
                CustomTextField(
                  inputType: TextInputType.text,
                  controller: passwordController,
                  inputAction: TextInputAction.done,
                  maxLines: 1,
                  obscure: true,
                  labelText: 'Password',
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Field cannot be Empty";
                    } else if (value.length < 6) {
                      return "Password ust be up to 6 characters";
                    } else
                      return null;
                  },
                  onChanged: (a) {
                    formValid = _riderLoginKey.currentState.validate();
                    setState(() {});
                  },
                ),
                verticalSpaceMedium,
                CustomButton(
                  title: "LOGIN",
                  buttonColor: formValid ? Styles.appCanvasBlue : Styles.colorGreyDark,
                  textColor: formValid ? Styles.colorWhite : Colors.white30,
                  onPressed: formValid ? () => signIn(context) : null,
                ),
                MediaQuery.of(context).viewInsets.bottom == 0.0 ? verticalSpaceMassive : SizedBox(),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  signIn(context) async {
    Util.offKeyboard(context);
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    if (emailController.text.toString().isEmpty) {
      showSnackBar(context, "Error", "Email is required");
      return;
    } else if (passwordController.text.toString().isEmpty) {
      showSnackBar(context, "Error", "Email is required");
      return;
    }

    setState(() {
      isLoading = true;
    });
    await _firebaseAuth
        .signInWithEmailAndPassword(email: emailController.text, password: passwordController.text)
        .then((value) {
      if (value.user != null) {
        routeToReplace(context, HomeScreen());
      } else {
        setState(() {
          isLoading = false;
        });
        _firebaseAuth.signOut();
      }
      return;
    }).catchError((e) {
      showExceptionAlertDialog(context: context, exception: e, title: "Error");
      setState(() {
        isLoading = false;
      });
      return;
    });
  }
}
