import 'package:fvast_admin/models/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'order_details.dart';

class EachOrderItem extends StatelessWidget {
  final Task task;
  final Color color;
  final String type;
  final Map<String, dynamic> map;

  const EachOrderItem(
      {Key key, @required this.task, @required this.color, @required this.type, this.map})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => OrderDetails(task: task, dataMap: map)));
      },
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      task.id,
                      style: GoogleFonts.nunito(
                          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                  ),
                ),
                Icon(
                  Icons.payment,
                  color: color,
                ),
                SizedBox(width: 10),
                Text("₦${task.amount}",
                    style: GoogleFonts.nunito(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black))
              ],
            ),
            Row(
              children: <Widget>[
                Icon(Icons.label, color: color),
                SizedBox(width: 10),
                Text(task.disName ?? "--",
                    style: GoogleFonts.nunito(
                        fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black))
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.date_range, color: color),
                      SizedBox(width: 10),
                      Text(task.startDate,
                          style: GoogleFonts.nunito(
                              fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black))
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300].withAlpha(111),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(5),
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Text(
                        type,
                        style: GoogleFonts.nunito(
                            color: color, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Divider(),
            )
          ],
        ),
      ),
    );
  }
}
