import 'package:flutter/material.dart';
import 'package:fvast_admin/constants/styles.dart';
import 'package:fvast_admin/ui/views/search_screen.dart';
import 'package:fvast_admin/ui/views/signup_screen.dart';
import 'package:fvast_admin/ui/widgets/custom_text_widget.dart';
import 'package:fvast_admin/utils/router.dart';
import 'package:fvast_admin/utils/spacing.dart';

import 'customers_sceen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.colorWhite,
      appBar: AppBar(
          elevation: 0,
          title: CustomText(text: "My Admin", fontSize: 16, fontWeight: FontWeight.w700)),
      body: Column(
        children: [
          Container(
            width: screenWidth(context),
            padding: EdgeInsets.all(40),
            margin: EdgeInsets.all(20),
            child: CustomText(
              text: "Welcome",
              fontSize: 24,
              centerText: true,
              color: Styles.colorWhite,
              fontWeight: FontWeight.w700,
            ),
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20), color: Styles.colorBlack),
          ),
          CustomText(
            text: "Manage Operations",
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          verticalSpaceMedium,
          GridView.builder(
              itemCount: 3,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    routeTo(context, gotos[index]);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Styles.colorWhite,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 5, color: Styles.colorGreyLight, blurRadius: 10)
                            ]),
                        child: Icon(
                          iconDatas[index],
                          size: 30,
                        ),
                      ),
                      verticalSpaceSmall,
                      CustomText(text: texts[index], fontSize: 16)
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  List<Widget> gotos = [SignupScreen(), SearchScreen(), CustomersScreen()];
  List<IconData> iconDatas = [
    Icons.person_add,
    Icons.search,
    Icons.group,
  ];
  List<String> texts = ["Make Admin", "Search", "Users"];
}
