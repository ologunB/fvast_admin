import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class ActiveTripMap extends StatefulWidget {
  final List<LatLng> stops;

  ActiveTripMap({@required this.stops});

  @override
  _ActiveTripMapState createState() => _ActiveTripMapState();
}

class _ActiveTripMapState extends State<ActiveTripMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  LatLng center;

  Uint8List firstStopIcon, midStopIcon, lastStopIcon;

  @override
  void initState() {
    doMarker();
    center = LatLng(4.8156, 7.0498);
    super.initState();
  }

  doMarker() async {
    firstStopIcon = await getBytesFromAsset('images/green_point.png', 60);
    midStopIcon = await getBytesFromAsset('images/active_ripple.png', 60);
    lastStopIcon = await getBytesFromAsset('images/red_point.png', 60);
  }

  void _setBoundsOnMap(GoogleMapController controller) async {
    // the bounds you want to set
    LatLngBounds bounds = boundsFromLatLngList(widget.stops);

    await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 30));
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    controller.setMapStyle(await rootBundle.loadString('assets/map_style.txt'));

    await pinMarkersOnMap();

    _setBoundsOnMap(controller);
  }

  Future<void> pinMarkersOnMap() async {
    print("Pining Markers");
    _markers = fetchStopsMarkers(widget.stops).toSet();
  }

  List<Marker> fetchStopsMarkers(List<LatLng> points) {
    List<Marker> markers = [];
    for (LatLng point in points) {
      markers.add(Marker(
          markerId: MarkerId(point.latitude.toString()),
          position: point,
          infoWindow: InfoWindow(title: "Here"),
          icon: BitmapDescriptor.defaultMarkerWithHue(point == points.first
              ? 0
              : point == points.last
                  ? 100
                  : 210)));
    }
    return markers;
  }

  void onCameraIdle() async {
    final GoogleMapController controller = await _controller.future;

    Future.delayed(Duration(milliseconds: 1500), () {
      _setBoundsOnMap(controller);
    });
  }

  void updateDriverLocationOnMap() async {
    print("Update new marker");
    final GoogleMapController controller = await _controller.future;

    setState(() {
      _markers = fetchStopsMarkers(widget.stops).toSet();
    });

    _setBoundsOnMap(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onCameraIdle: onCameraIdle,
        tiltGesturesEnabled: false,
        rotateGesturesEnabled: false,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        compassEnabled: false,
        onMapCreated: _onMapCreated,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: center, zoom: 10.0),
        markers: _markers,
      ),
    );
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }
}
