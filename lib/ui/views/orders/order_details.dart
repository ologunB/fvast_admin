import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fvast_admin/ui/widgets/active_trip_map.dart';
import 'package:fvast_admin/utils/router.dart';
import 'package:fvast_admin/utils/spacing.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fvast_admin/models/task.dart';

class OrderDetails extends StatefulWidget {
  final Task task;
  final Map dataMap;

  const OrderDetails({Key key, this.task, this.dataMap}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Widget _tabStep() => Container(
        margin: EdgeInsets.only(top: 10),
        child: Stepper(
          physics: ClampingScrollPhysics(),
          currentStep: 1,
          steps: steppers(),
          controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
              Container(),
        ),
      );

  List<Step> steppers() {
    List<Step> bb = [];

    bb.add(Step(
      title: Column(
        children: <Widget>[
          Text(
            widget.task.startDate,
            style: GoogleFonts.nunito(color: Colors.grey),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .70,
            child: Text(
              widget.task.from + " - " + todo1(widget.task.status),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: GoogleFonts.nunito(fontSize: 16),
            ),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      content: Container(),
    ));

    for (String i in widget.task.to) {
      bb.add(Step(
        title: Column(
          children: <Widget>[
            Text(
              widget.task.acceptedDate ?? "--",
              style: GoogleFonts.nunito(color: Colors.grey),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .70,
              child: Text(
                i + " - " + todo2(widget.task.status),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: GoogleFonts.nunito(fontSize: 16),
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        content: SizedBox(),
      ));
    }
    return bb;
  }

  double ratingNum = 2;

  List<LatLng> allStops = [];

  @override
  void initState() {
    allStops.add(LatLng(widget.task.fromLat, widget.task.fromLong));
    for (int i = 0; i < widget.task.toLat.length; i++) {
      allStops.add(LatLng(widget.task.toLat[i], widget.task.toLong[i]));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int routeType = widget.task.routeType;

    int baseFare = routeTypes[routeType].baseFare;
    int distance = widget.task.distance;
    int perKiloCharge = (routeTypes[routeType].perKilo * distance).round();
    int tax = (0.075 * (baseFare + perKiloCharge)).floor();

    int total = baseFare + perKiloCharge + tax;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.task.id,
              style: GoogleFonts.nunito(fontSize: 18),
            ),
          ),
          actions: <Widget>[
            Center(
              child: InkWell(
                onTap: () {
                  routeTo(context, ActiveTripMap(stops: allStops));
                },
                child: Text(
                  "Open Map",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(fontSize: 16),
                ),
              ),
            ),
            horizontalSpaceSmall
          ],
          elevation: 0,
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Dispatcher Details",
                      style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  widget.task.disName == null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "No dispatcher has taken the order",
                            style: GoogleFonts.nunito(
                                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.white, borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: widget.task.disImage ?? "img",
                                  height: 70,
                                  width: 70,
                                  placeholder: (context, url) => Image(
                                      image: AssetImage("images/person.png"),
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.contain),
                                  errorWidget: (context, url, error) => Image(
                                      image: AssetImage("images/person.png"),
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.contain),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        widget.task.disName ?? "--",
                                        style: GoogleFonts.nunito(
                                            fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        widget.task.disNumber ?? "--",
                                        style: GoogleFonts.nunito(
                                            fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        widget.task.plateNumber ?? "--",
                                        style: GoogleFonts.nunito(
                                            fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                                      // Text( widget.task.disImage ?? "--"),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.call),
                                  onPressed: () {
                                    try {
                                      launch(
                                        "tel://${widget.task.disNumber}",
                                      );
                                    } catch (e) {
                                      print(e);
                                    }
                                  })
                            ],
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Stages",
                      style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(15)),
                      child: _tabStep()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Task Summary",
                      style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    decoration:
                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Route: ", style: GoogleFonts.nunito(fontSize: 16)),
                              Expanded(child: Divider(thickness: 2)),
                              Text(routeTypes[routeType].type,
                                  style: GoogleFonts.nunito(fontSize: 16))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Payment Type: ", style: GoogleFonts.nunito(fontSize: 16)),
                              Expanded(child: Divider(thickness: 2)),
                              Text(widget.task.paymentType ?? "r",
                                  style: GoogleFonts.nunito(fontSize: 16))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Coupon: ", style: GoogleFonts.nunito(fontSize: 16)),
                              Expanded(child: Divider(thickness: 2)),
                              Text(" -- ", style: GoogleFonts.nunito(fontSize: 16))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Receiver's Name: ", style: GoogleFonts.nunito(fontSize: 16)),
                              Expanded(child: Divider(thickness: 2)),
                              Text(widget.task.reName ?? "r",
                                  style: GoogleFonts.nunito(fontSize: 16))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Receiver's  Mobile", style: GoogleFonts.nunito(fontSize: 16)),
                              Expanded(child: Divider(thickness: 2)),
                              Text(widget.task.reNum ?? "r",
                                  style: GoogleFonts.nunito(fontSize: 16))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Package Size/Weight", style: GoogleFonts.nunito(fontSize: 16)),
                              Expanded(child: Divider(thickness: 2)),
                              Text(widget.task.size ?? "r", style: GoogleFonts.nunito(fontSize: 16))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Package Type ", style: GoogleFonts.nunito(fontSize: 16)),
                              Expanded(child: Divider(thickness: 2)),
                              Text(widget.task.type ?? "r", style: GoogleFonts.nunito(fontSize: 16))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Payment Summary",
                      style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    decoration:
                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Base Fare: ", style: GoogleFonts.nunito(fontSize: 16)),
                              Expanded(child: Divider(thickness: 2)),
                              Text(" \₦ " + commaFormat.format((baseFare)),
                                  style: GoogleFonts.nunito(fontSize: 16))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Distance charge: ", style: GoogleFonts.nunito(fontSize: 16)),
                              Expanded(child: Divider(thickness: 2)),
                              Text(" \₦ " + commaFormat.format(perKiloCharge),
                                  style: GoogleFonts.nunito(fontSize: 16))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Tax: ", style: GoogleFonts.nunito(fontSize: 16)),
                              Expanded(child: Divider(thickness: 2)),
                              Text(" \₦ " + commaFormat.format(tax),
                                  style: GoogleFonts.nunito(fontSize: 16))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Others: ", style: GoogleFonts.nunito(fontSize: 16)),
                              Expanded(child: Divider(thickness: 2)),
                              Text(" \₦ " + commaFormat.format(widget.task.amount - total),
                                  style: GoogleFonts.nunito(fontSize: 16))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Text("Total: ",
                                  style: GoogleFonts.nunito(
                                      fontSize: 18, fontWeight: FontWeight.w600)),
                              Expanded(child: Divider(thickness: 2)),
                              Text(" \₦ " + commaFormat.format(toTens(widget.task.amount)),
                                  style:
                                      GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

var widgetColor = Colors.blue[200];

String userHomeNext(status) {
  String todo = "";

  if (status == "Pending") {
    widgetColor = Colors.redAccent[200];
    todo = "Awaiting";
  } else if (status == "Accepted") {
    todo = "Task Accepted";
    widgetColor = Colors.lightBlueAccent[200];
  } else if (status == "Start Task 1") {
    todo = "Task 1 Started";
    widgetColor = Colors.greenAccent[200];
  } else if (status == "End Task 1") {
    todo = "Task 1 Ended";
    widgetColor = Colors.lightBlueAccent[200];
  } else if (status == "End Task 2") {
    todo = "Task 2 Ended";
    widgetColor = Colors.lightBlueAccent[200];
  } else if (status == "Start Task 2") {
    todo = "Task 2 Started";
    widgetColor = Colors.greenAccent[200];
  } else if (status == "Start Task 3") {
    todo = "Task 3 Started";
    widgetColor = Colors.greenAccent[200];
  } else if (status == "End Task 3") {
    todo = "Task 3 Ended";
    widgetColor = Colors.lightBlueAccent[200];
  } else if (status == "Start Task 4") {
    todo = "Task 4 Started";
    widgetColor = Colors.greenAccent[200];
  } else if (status == "End Task 4") {
    todo = "Task 4 Ended";
    widgetColor = Colors.lightBlueAccent[200];
  } else if (status == "Completed") {
    widgetColor = Colors.greenAccent[200];
    todo = "Completed";
  }

  return todo;
}

String todo1(status) {
  String fromStatus = "Pending";

  if (status == "Start Arrival") {
    fromStatus = "Completed";
  }
  return fromStatus;
}

String todo2(status) {
  String toStatus = "Pending";

  if (status == "Start Arrival") {
    toStatus = "Completed";
  }
  return toStatus;
}

List<RouteModel> routeTypes = [
  RouteModel(
    icon: Icons.directions_bike,
    type: "Bike",
    desc: "Easy Delivery and Small Packages",
    baseFare: 400,
    perKilo: 50,
  ),
  RouteModel(
    icon: Icons.directions_car,
    type: "Car",
    desc: "Fast Delivery for Medium Small Packages",
    baseFare: 700,
    perKilo: 50,
  ),
  RouteModel(
    icon: Icons.airport_shuttle,
    type: "Truck",
    desc: "Fast Delivery for Heavy Packages",
    baseFare: 9000,
    perKilo: 100,
  ),
/*  RouteModel(
    icon: Icons.motorcycle,
    type: "Tricycle",
    desc: "Fast Delivery for Heavy Packages",
    baseFare: 700,
    perKilo: 50,
  ),
  RouteModel(
    icon: Icons.airplanemode_active,
    type: "Jet",
    desc: "Fast Delivery for Heavy Packages",
    baseFare: 9000,
    perKilo: 200,
  ),*/
];

final commaFormat = new NumberFormat("#,##0", "en_US");

class RouteModel {
  String type;
  IconData icon;
  String desc;
  int baseFare;
  int perKilo;

  RouteModel({
    this.type,
    this.icon,
    this.desc,
    this.baseFare,
    this.perKilo,
  });
}

int toTens(num) {
  return (num / 10.0).round() * 10;
}
