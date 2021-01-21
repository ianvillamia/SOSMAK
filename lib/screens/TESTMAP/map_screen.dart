import 'dart:async';

import 'package:SOSMAK/screens/TESTMAP/google_place_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> implements GooglePlacesListener {
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  Position _currentPosition;
  String locationAddress = "Search destination";
  GooglePlaces googlePlaces;
  double _destinationLat;
  double _destinationLng;

  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    googlePlaces = GooglePlaces(this);
    _getCurrentLocation();
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _updatePosition(_currentPosition);
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> _updatePosition(Position currentPosition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentPosition.latitude, currentPosition.longitude),
      zoom: 14.4746,
    )));
    googlePlaces.updateLocation(
        currentPosition.latitude, currentPosition.longitude);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidget = Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          polylines: Set<Polyline>.of(polylines.values),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        GestureDetector(
          onTap: () {
            googlePlaces.findPlace(context);
          },
          child: Container(
            height: 50.0,
            alignment: FractionalOffset.center,
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 1.0),
              border: Border.all(color: const Color(0x33A6A6A6)),
              borderRadius: BorderRadius.all(const Radius.circular(6.0)),
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.search),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(right: 13.0),
                    child: Text(
                      locationAddress,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFA6AFAA),
      body: screenWidget,
    );
  }

  @override
  selectedLocation(double lat, double lng, String address) {
    setState(() {
      _destinationLat = lat;
      _destinationLng = lng;
      locationAddress = address;
    });
    _getPolyline();
  }

  _addPolyLine() {
    polylines.clear();
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyCZjrzw-ltJyYGJqNLFLwuGzxuZSSX6ig8",
        PointLatLng(_currentPosition.latitude, _currentPosition.longitude),
        PointLatLng(_destinationLat, _destinationLng),
        travelMode: TravelMode.transit);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
