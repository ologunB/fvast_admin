import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fvast_admin/models/task.dart';
import 'package:google_fonts/google_fonts.dart';

import 'each_order_item.dart';

class CustomOrderPage extends StatefulWidget {
  final String type;
  final Color color;
  final String theUID;

  const CustomOrderPage({Key key, this.type, this.color, this.theUID}) : super(key: key);

  @override
  _ListViewNoteState createState() => _ListViewNoteState();
}

class _ListViewNoteState extends State<CustomOrderPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Orders")
          .doc(widget.type)
          .collection(widget.theUID)
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
                  CircularProgressIndicator(),
                  SizedBox(height: 30),
                  Text(
                    "Getting Data",
                    textAlign: TextAlign.center,
                    style:
                    GoogleFonts.nunito(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
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
                          style: GoogleFonts.nunito(
                              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  )
                : ListView(
                    children: snapshot.data.docs.map((document) {
                      return EachOrderItem(
                          task: Task.map(document),
                          color: widget.color,
                          type: widget.type,
                          map: document.data());
                    }).toList(),
                  );
        }
      },
    );
  }
}
