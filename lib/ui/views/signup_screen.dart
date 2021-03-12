import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fvast_admin/constants/styles.dart';
import 'package:fvast_admin/ui/widgets/back_button.dart';
import 'package:fvast_admin/ui/widgets/custom_button.dart';
import 'package:fvast_admin/ui/widgets/custom_text_widget.dart';
import 'package:fvast_admin/ui/widgets/custom_textfield.dart';
import 'package:fvast_admin/ui/widgets/show_exception_alert_dialog.dart';
import 'package:fvast_admin/utils/spacing.dart';
import 'package:fvast_admin/utils/util.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final _riderLoginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Util.offKeyboard(context),
      child: Scaffold(
          backgroundColor: Styles.colorWhite,
          appBar: AppBar(elevation: 0, leading: BackButtonWidget(color: Styles.colorGreyLight)),
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
                size: 40),
            color: Colors.grey,
            child: Container(
              height: screenHeight(context),
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Form(
                key: _riderLoginKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  children: <Widget>[
                    Container(
                      width: screenWidth(context),
                      padding: EdgeInsets.all(40),
                      margin: EdgeInsets.all(10),
                      child: CustomText(
                        text: "Hello, Sandra",
                        fontSize: 24,
                        centerText: true,
                        color: Styles.colorWhite,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20), color: Styles.colorBlack),
                    ),
                    verticalSpaceMedium,
                    CustomText(
                      bottomMargin: 10,
                      text: 'Admin Info',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Styles.colorBlack,
                    ),
                    verticalSpaceMedium,
                    CustomTextField(
                      inputType: TextInputType.text,
                      controller: nameController,
                      inputAction: TextInputAction.next,
                      maxLines: 1,
                      labelText: 'Name',
                      validator: Util.isValidName,
                    ),
                    verticalSpaceMedium,
                    CustomTextField(
                      inputType: TextInputType.emailAddress,
                      controller: emailController,
                      inputAction: TextInputAction.next,
                      maxLines: 1,
                      labelText: 'Email Address',
                      validator: Util.validateEmail,
                    ),
                    verticalSpaceMedium,
                    CustomTextField(
                      inputType: TextInputType.text,
                      controller: passwordController,
                      inputAction: TextInputAction.next,
                      maxLines: 1,
                      obscure: true,
                      labelText: 'Password',
                      validator: (a) {
                        if (passwordController.text.length < 6) {
                          return "Password isnt strong enough";
                        } else if (a.isEmpty) {
                          return "Password cannot be empty";
                        }
                      },
                    ),
                    verticalSpaceMedium,
                    CustomTextField(
                      inputType: TextInputType.text,
                      controller: confirmPasswordController,
                      inputAction: TextInputAction.done,
                      maxLines: 1,
                      obscure: true,
                      labelText: 'Confirm Password',
                      validator: (a) {
                        if (passwordController.text != confirmPasswordController.text) {
                          return "Password must be the same";
                        } else if (a.isEmpty) {
                          return "Password cannot be empty";
                        }
                      },
                    ),
                    verticalSpaceMedium,
                    CustomButton(
                        title: "Signup",
                        buttonColor: Styles.appCanvasBlue,
                        textColor: Styles.colorWhite,
                        onPressed: () {
                          _riderLoginKey.currentState.validate();
                          if (_riderLoginKey.currentState.validate()) {
                            signUp(context);
                          }
                        }),
                    verticalSpaceMedium,
                  ],
                ),
              ),
            ),
          )),
    );
  }

  bool iAgree = false;

  bool isLoading = false;

  Future signUp(context) async {
    Util.offKeyboard(context);
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    String email = emailController.text;
    String password = passwordController.text;
    String name = nameController.text;
    setState(() {
      isLoading = true;
    });
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      User user = value.user;

      if (user != null) {
        user.sendEmailVerification().then((v) {
          Map<String, Object> mData = Map();
          mData.putIfAbsent("name", () => name);
          mData.putIfAbsent("email", () => email);
          mData.putIfAbsent("uid", () => user.uid);
          mData.putIfAbsent("created_at", () => DateTime.now().millisecondsSinceEpoch);

          FirebaseFirestore.instance.collection("Admin Data").doc(user.uid).set(mData).then((val) {
            emailController.clear();
            passwordController.clear();
            confirmPasswordController.clear();
            nameController.clear();
            _firebaseAuth.signOut();

            showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    content: Text(
                      "User created, Check email for verification.",
                      style: GoogleFonts.nunito(
                          fontSize: 16, fontWeight: FontWeight.w600, color: Styles.colorBlack),
                    ),
                    actions: <Widget>[
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "OK",
                            style: GoogleFonts.nunito(
                                fontSize: 12,
                                letterSpacing: 1,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  );
                });

            setState(() {
              isLoading = false;
            });
          }).catchError((e) {
            _firebaseAuth.signOut();
            showExceptionAlertDialog(context: context, exception: e, title: "Error");
            setState(() {
              isLoading = false;
            });
          });
        }).catchError((e) {
          _firebaseAuth.signOut();

          showExceptionAlertDialog(context: context, exception: e, title: "Error");
          setState(() {
            isLoading = false;
          });
        });
      } else {
        _firebaseAuth.signOut();
        setState(() {
          isLoading = false;
        });
      }
      return;
    }).catchError((e) {
      _firebaseAuth.signOut();
      showExceptionAlertDialog(context: context, exception: e, title: "Error");
      setState(() {
        isLoading = false;
      });
      return;
    });
  }
}
