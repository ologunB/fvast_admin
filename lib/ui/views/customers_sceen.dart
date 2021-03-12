import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fvast_admin/constants/styles.dart';
import 'package:fvast_admin/models/user.dart';
import 'package:fvast_admin/utils/router.dart';
import 'package:fvast_admin/utils/spacing.dart';
import 'package:google_fonts/google_fonts.dart';

import 'customer_details.dart';

class CustomersScreen extends StatefulWidget {
  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            bottom: TabBar(
                isScrollable: true,
                unselectedLabelColor: Colors.grey[500],
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: Styles.appCanvasBlue),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Users",
                        style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Riders",
                          style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ]),
            title: Text(
              "Manage Accounts",
              style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            elevation: 2),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                TabBarView(children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("All")
                          .orderBy("Timestamp", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CupertinoActivityIndicator());
                          default:
                            return snapshot.data.docs.isEmpty
                                ? Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "No Account yet",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.nunito(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView(
                                    children: snapshot.data.docs.map<Widget>((document) {
                                      UserModel model = UserModel.map(document);

                                      return InkWell(
                                        onTap: () {
                                          routeTo(context, AccountDetails(model: model));
                                        },
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 4),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 8.0, vertical: 2),
                                                  child: Text(
                                                    model.name,
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 16, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Text(
                                                    model.email,
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                verticalSpaceSmall,
                                                Divider(height: 0)
                                              ],
                                              mainAxisSize: MainAxisSize.min,
                                            )),
                                      );
                                    }).toList(),
                                  );
                        }
                      }),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("All")
                          .orderBy("Timestamp", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CupertinoActivityIndicator());
                          default:
                            return snapshot.data.docs.isEmpty
                                ? Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "No Account yet",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.nunito(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView(
                                    children: snapshot.data.docs.map<Widget>((document) {
                                      UserModel model = UserModel.map(document);
                                      return InkWell(
                                        onTap: () {
                                          routeTo(context, AccountDetails(model: model));
                                        },
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 4),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 8.0, vertical: 2),
                                                  child: Text(
                                                    model.name,
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 16, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Text(
                                                    model.email,
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                verticalSpaceSmall,
                                                Divider(height: 0)
                                              ],
                                              mainAxisSize: MainAxisSize.min,
                                            )),
                                      );
                                    }).toList(),
                                  );
                        }
                      })
                ]),
              ],
            )),
      ),
    );
  }
}
