import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fvast_admin/models/wallet.dart';
import 'package:google_fonts/google_fonts.dart';

import 'order_details.dart';

class EachTransactionItem extends StatefulWidget {
  final TransactionModel transaction;

  const EachTransactionItem({Key key, @required this.transaction}) : super(key: key);

  @override
  _EachTransactionItemState createState() => _EachTransactionItemState();
}

class _EachTransactionItemState extends State<EachTransactionItem> {
  @override
  Widget build(BuildContext context) {
    Color color = Colors.green;
    if (widget.transaction.type == "Deposit") {
      color = Colors.green;
    } else if (widget.transaction.type == "Withdrawal") {
      color = Colors.red;
    } else if (widget.transaction.type == "Card Payment") {
      color = Colors.blueAccent;
    } else if (widget.transaction.type == "Cash Payment") {
      color = Colors.deepOrange;
    } else if (widget.transaction.type == "Bitcoin Payment") {
      color = Colors.blueAccent;
    }

    TransactionModel transaction = widget.transaction;

    return Container(
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
                    transaction.id,
                    style: GoogleFonts.nunito(
                        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                ),
              ),
              Icon(
                Icons.payment,
                color: color,
              ),
              SizedBox(width: 10),
              Text("₦ " + commaFormat.format(transaction.amount),
                  style: GoogleFonts.nunito(
                      fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black))
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.date_range, color: color),
                    SizedBox(width: 10),
                    Text(transaction.date,
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
                    transaction.type,
                    style:
                        GoogleFonts.nunito(color: color, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(left: 8, right: 8, top: 8), child: Divider())
        ],
      ),
    );
  }
}
