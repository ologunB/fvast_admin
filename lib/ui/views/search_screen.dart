import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvast_admin/constants/styles.dart';
import 'package:fvast_admin/models/user.dart';
import 'package:fvast_admin/ui/widgets/custom_text_widget.dart';
import 'package:fvast_admin/ui/widgets/custom_textfield.dart';
import 'package:fvast_admin/utils/router.dart';
import 'package:fvast_admin/utils/spacing.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:logger/logger.dart';

import 'customer_details.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<UserModel> usersList = [];
  List<UserModel> sortedList = [];
  bool noUserFound = false;
  bool showService = true;
  bool showSearch = false;

  void onSearchUsers(String val) {
    if (usersList != null) {
      val = val.trim();
      if (val.isNotEmpty) {
        sortedList.clear();
        for (UserModel item in usersList) {
          if (item.name.toUpperCase().contains(val.toUpperCase())) {
            sortedList.add(item);
          }
        }
        if (sortedList.isEmpty) {
          setState(() {
            showService = false;
            showSearch = true;
            noUserFound = true;
          });
          return;
        }
        setState(() {
          noUserFound = false;

          showService = false;
          showSearch = true;
        });
      } else {
        setState(() {
          noUserFound = false;
          showService = true;
          showSearch = false;
          FocusScope.of(context).unfocus();
        });
      }
    } else {
      return;
    }
  }

  bool isLoading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await FirebaseFirestore.instance.collection('All').snapshots().forEach((element) {
      element.docs.forEach((doc) {
        UserModel model = UserModel.map(doc.data());
        usersList.add(model);
      });
      isLoading = false;
      setState(() {});
    });


  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
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
      child: Scaffold(
        appBar: AppBar(
            elevation: 1,
            title: CustomTextField(
              hintText: "Search...",
              onChanged: onSearchUsers,
            )),
        body: sortedList.isEmpty
            ? Container(
                color: Colors.white,
                alignment: Alignment.center,
                height: screenHeight(context),
                child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "images/empty.svg",
                            height: screenWidthFraction(context, dividedBy: 4),
                          ),
                          verticalSpaceMedium,
                          CustomText(
                            text: "Empty List.",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Styles.colorBlack,
                          ),
                          verticalSpaceSmall,
                        ],
                      ),
                    )))
            : ListView.builder(
                itemCount: sortedList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      routeTo(context, AccountDetails(model: sortedList[index]));
                    },
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                                  child: Text(
                                    sortedList[index].name,
                                    style: GoogleFonts.nunito(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                                  child: Text(
                                    sortedList[index].type,
                                    style: GoogleFonts.nunito(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                sortedList[index].email,
                                style: GoogleFonts.nunito(
                                    fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
                              ),
                            ),
                            verticalSpaceSmall,
                            Divider(height: 0)
                          ],
                          mainAxisSize: MainAxisSize.min,
                        )),
                  );
                }),
      ),
    );
  }
}
