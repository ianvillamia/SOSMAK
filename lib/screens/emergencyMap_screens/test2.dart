import 'package:SOSMAK/screens/emergencyMap_screens/data/place_response.dart';
import 'package:SOSMAK/screens/emergencyMap_screens/data/result.dart';
import 'package:SOSMAK/screens/emergencyMap_screens/data/error.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:SOSMAK/screens/emergencyMap_screens/Widgets/places.dart';
import 'package:flutter/material.dart';
// Stores the Google Maps API Key
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as gPlaces;
import 'package:geocoding/geocoding.dart' as gcoding;

import 'dart:math' show cos, sqrt, asin;

import 'package:search_map_place/search_map_place.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'Widgets/directions.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;

  Position _currentPosition;
  String _currentAddress;
  final Geolocator _geolocator = Geolocator();
  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  gPlaces.GoogleMapsPlaces _places = gPlaces.GoogleMapsPlaces(
      apiKey: 'AIzaSyCZjrzw-ltJyYGJqNLFLwuGzxuZSSX6ig8');
  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance;

  Set<Marker> markers = {};

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final double _initFabHeight = 120.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;

  static const String _API_KEY = 'AIzaSyCZjrzw-ltJyYGJqNLFLwuGzxuZSSX6ig8';

  static double latitude = 40.7484405;
  static double longitude = -73.9878531;
  static const String baseUrl =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json";

  List<Marker> placesMarkers = <Marker>[];
  List<gPlaces.PlacesSearchResult> placeSearch = [];
  Error error;
  List<Result> places;
  bool searching = true;
  String keyword;
  Completer<GoogleMapController> _controller = Completer();

  void _showDirectionsPanel() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
            child: DirectionsBottomSheet(),
          );
        });
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/maps_style.json');
    controller.setMapStyle(value);
  }

  void searchNearby(double latitude, double longitude) async {
    setState(() {
      placesMarkers.clear();
    });
    String url =
        '$baseUrl?key=$_API_KEY&location=${_currentPosition.latitude},${_currentPosition.longitude}&radius=3000&keyword=$keyword';
    print(url);
    final response = await http.get(url);

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
      zoom: 12.5,
    )));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _handleResponse(data);
    } else {
      throw Exception('An error occurred getting places nearby');
    }

    // make sure to hide searching
    setState(() {
      searching = false;
    });
  }

  int items = 0;
  void _handleResponse(data) {
    // bad api key or otherwise
    if (data['status'] == "REQUEST_DENIED") {
      setState(() {
        error = Error.fromJson(data);
      });
      // success
    } else if (data['status'] == "OK") {
      setState(() {
        places = PlaceResponse.parseResults(data['results']);
        for (int i = 0; i < places.length; i++) {
          items = places.length;
          placesMarkers.add(
            Marker(
              markerId: MarkerId(places[i].placeId),
              position: LatLng(places[i].geometry.location.lat,
                  places[i].geometry.location.long),
              infoWindow: InfoWindow(
                  title: places[i].name, snippet: places[i].vicinity),
              onTap: () {},
            ),
          );
        }
      });
    } else {
      print(data);
    }
  }

  void getHospitals() async {
    setState(() {
      placesMarkers.clear();
    });
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;

        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await _geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  // Method for calculating the distance between two places

  // Create the polylines for showing the route between two places

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    void _showPlacesPanel() {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: placesDrawer(),
            );
          });
    }

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // etto yung my location
            FloatingActionButton(
              heroTag: "mylocation",
              onPressed: () {
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(
                        _currentPosition.latitude,
                        _currentPosition.longitude,
                      ),
                      zoom: 18.0,
                    ),
                  ),
                );
              },
              child: Icon(Icons.my_location),
            ),
            SizedBox(
              height: 10,
            ),
            //dito yung may directions
            FloatingActionButton(
              heroTag: "mydirections",
              onPressed: () {
                _showDirectionsPanel();
              },
              child: Icon(Icons.directions),
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            // Map View
            GoogleMap(
              markers: markers != null ? Set<Marker>.from(placesMarkers) : null,
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                _setStyle(controller);
                _controller.complete(controller);
                mapController = controller;
              },
            ),
            // Show zoom buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Show the place input fields & button for
            // showing the route
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    SearchMapPlaceWidget(
                      hasClearButton: true,
                      placeType: PlaceType.address,
                      placeholder: 'Enter the location',
                      apiKey: 'AIzaSyCZjrzw-ltJyYGJqNLFLwuGzxuZSSX6ig8',
                      onSelected: (Place place) async {
                        Geolocation geolocation = await place.geolocation;
                        mapController.animateCamera(
                            CameraUpdate.newLatLng(geolocation.coordinates));
                        mapController.animateCamera(
                            CameraUpdate.newLatLngBounds(
                                geolocation.bounds, 0));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedButton(
                          color: Colors.white,
                          child: Text('Hospital'),
                          onPressed: () {
                            keyword = 'Hospital';
                            searchNearby(_currentPosition.latitude,
                                _currentPosition.longitude);
                            _showPlacesPanel();
                          },
                        ),
                        RaisedButton(
                          color: Colors.white,
                          child: Text('Police Station'),
                          onPressed: () {
                            keyword = 'Police-Station';
                            searchNearby(_currentPosition.latitude,
                                _currentPosition.longitude);
                            _showPlacesPanel();
                          },
                        ),
                        RaisedButton(
                          color: Colors.white,
                          child: Text('Fire Station'),
                          onPressed: () {
                            keyword = 'Fire-Station';
                            searchNearby(_currentPosition.latitude,
                                _currentPosition.longitude);
                            _showPlacesPanel();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  placesDrawer() {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;

    return SlidingUpPanel(
        maxHeight: _panelHeightOpen,
        minHeight: _panelHeightClosed,
        panelBuilder: (sc) => _panel(sc),
        onPanelSlide: (double pos) => setState(() {
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
            }));
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        controller: sc,
        children: <Widget>[
          SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
              ),
            ],
          ),
          SizedBox(
            height: 18.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Nearby $keyword",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            width: 250,
            height: 450,
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
              itemCount: items,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    //
                    String hospital = places[index].name;
                    //geocoding reverse
                    var addresses =
                        await Geocoder.local.findAddressesFromQuery(hospital);
                    var first = addresses.first;
                    print("${first.featureName} : ${first.coordinates}");
                  },
                  child: Card(
                    child: ListTile(
                      title: Text('${places[index].name}'),
                      subtitle: Text('${places[index].vicinity}'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
