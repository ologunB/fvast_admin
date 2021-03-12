import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fvast_admin/constants/styles.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_order_page.dart';

class OrdersView extends StatefulWidget {
  final String uid;

  const OrdersView({Key key, this.uid}) : super(key: key);
  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1.0,
          leadingWidth: 0,
          leading: SizedBox(),centerTitle: true,
          title: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.grey[500],
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Styles.appCanvasBlue),
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("En Route",
                        style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Completed",
                        style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Cancelled",
                        style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ]),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: TabBarView(children: [
            CustomOrderPage(type: "Pending", color: Styles.appCanvasBlue, theUID: widget.uid),
            CustomOrderPage(type: "Completed", color: Colors.green, theUID:widget.uid),
            CustomOrderPage(type: "Cancelled", color: Colors.red, theUID: widget.uid)
          ]),
        ),
      ),
    );
  }
}
