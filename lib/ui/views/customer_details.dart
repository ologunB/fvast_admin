import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fvast_admin/constants/styles.dart';
import 'package:fvast_admin/models/notification.dart';
import 'package:fvast_admin/models/user.dart';
import 'package:fvast_admin/models/wallet.dart';
import 'package:fvast_admin/ui/widgets/network_image.dart';
import 'package:fvast_admin/utils/spacing.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'orders/each_order_item.dart';
import 'orders/each_transaction_item.dart';
import 'orders/order_view.dart';

class AccountDetails extends StatefulWidget {
  final UserModel model;

  const AccountDetails({Key key, this.model}) : super(key: key);

  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  bool isLoading = false;
  List<String> images = [];

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
        progressIndicator: CupertinoActivityIndicator(radius: 15),
        isLoading: isLoading,
        color: Colors.grey,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              title: Text(
                "Account Details",
                style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              elevation: 2),
          body: Column(
            children: [
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CachedImage(size: 70, imageUrl: widget.model.avatar ?? "")],
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(5),
                child: Text(
                  widget.model.name,
                  style: GoogleFonts.nunito(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              Center(
                child: Text(
                  widget.model.email,
                  style: GoogleFonts.nunito(
                      fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                ),
              ),
              Divider(),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar: AppBar(
                      leading: Container(),
                      flexibleSpace: TabBar(
                          indicatorWeight: 0,
                          isScrollable: true,
                          indicatorPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          unselectedLabelColor: Colors.grey[500],
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(10), color: Styles.appCanvasBlue),
                          tabs: [
                            Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Orders",
                                  style:
                                      GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Transactions",
                                  style:
                                      GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text("Notifications",
                                    style: GoogleFonts.nunito(
                                        fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ]),
                      iconTheme: IconThemeData(color: Colors.white),
                      backgroundColor: Colors.white,
                      elevation: 0.0,
                      centerTitle: true,
                    ),
                    body: Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: TabBarView(children: [
                        OrdersView(uid: widget.model.uid),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Utils")
                              .doc("Wallet")
                              .collection(widget.model.uid)
                              .orderBy("Timestamp", descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CupertinoActivityIndicator(),
                                      SizedBox(height: 30),
                                      Text(
                                        "Getting Data",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20),
                                      ),
                                      SizedBox(height: 30),
                                    ],
                                  ),
                                  height: 300,
                                  width: 300,
                                );
                              default:
                                return snapshot.data.docs.isEmpty
                                    ? Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "No transactions yet",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20),
                                            ),
                                            SizedBox(height: 30),
                                          ],
                                        ),
                                      )
                                    : ListView(
                                        children: snapshot.data.docs.map((document) {
                                          TransactionModel transaction = TransactionModel.map(document);
                                          return EachTransactionItem(transaction: transaction);
                                        }).toList(),
                                      );
                            }
                          },
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Utils")
                              .doc("Notification")
                              .collection(widget.model.uid)
                              .orderBy("Timestamp", descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      CircularProgressIndicator(),
                                      SizedBox(height: 30),
                                      Text(
                                        "Getting Data",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 22),
                                      ),
                                      SizedBox(height: 30),
                                    ],
                                  ),
                                  height: 300,
                                  width: 300,
                                );
                              default:
                                return snapshot.data.docs.isEmpty
                                    ? Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Center(
                                              child: Text(
                                                "No Notifications!",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 22),
                                              ),
                                            ),
                                            SizedBox(height: 30),
                                          ],
                                        ),
                                      )
                                    : ListView(
                                        children: snapshot.data.docs.map((document) {
                                          MyNotification item = MyNotification.map(document);
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(left: 3, top: 3, right: 3),
                                            child: Card(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      item.message,
                                                      style: TextStyle(
                                                          fontSize: 16, color: Colors.grey[800]),
                                                    ),
                                                  ),
                                                  Divider(
                                                    height: 0,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      item.date,
                                                      style: TextStyle(
                                                          fontSize: 14, color: Colors.red),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      );
                            }
                          },
                        ),
                      ]),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
