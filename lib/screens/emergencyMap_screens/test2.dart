import 'package:SOSMAK/screens/emergencyMap_screens/data/photo.dart';
import 'package:SOSMAK/screens/emergencyMap_screens/data/place_response.dart';
import 'package:SOSMAK/screens/emergencyMap_screens/data/result.dart';
import 'package:SOSMAK/screens/emergencyMap_screens/data/error.dart';
import 'package:dio/dio.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
// Stores the Google Maps API Key
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as gCoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as gPlaces;

import 'dart:math' show cos, sqrt, asin;

import 'package:search_map_place/search_map_place.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Widget _textField({
    TextEditingController controller,
    FocusNode focusNode,
    String label,
    String hint,
    double width,
    Icon prefixIcon,
    Widget suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue[300],
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

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

  gPlaces.PlaceDetails place;
  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance;

  String placeDist;
  bool showDistance = false;

  Set<Marker> markers = {};

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final double _initFabHeight = 120.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;
  int items = 0;
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
    markers.clear();
    polylines.clear();
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
            child: showDirectionsSheet(),
          );
        });
  }

  void _showPlacesPanel() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: placesDrawer(),
            );
          });

      setState(() {});
    });
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/maps_style.json');
    controller.setMapStyle(value);
  }

  void searchNearby(double latitude, double longitude) async {
    PolylineId id = PolylineId('poly');
    setState(() {
      placesMarkers.clear();
      if (polylines.isNotEmpty) polylines.clear();
      if (polylineCoordinates.isNotEmpty) polylineCoordinates.clear();
    });
    String url =
        '$baseUrl?key=$_API_KEY&location=${_currentPosition.latitude},${_currentPosition.longitude}&radius=500&keyword=$keyword';
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

  int btnCTR = 0;
  getHospitals(Position pos) async {
    setState(() {
      placesMarkers.clear();
    });

    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCZjrzw-ltJyYGJqNLFLwuGzxuZSSX6ig8', // Google Maps API Key
      PointLatLng(_currentPosition.latitude, _currentPosition.longitude),
      PointLatLng(pos.latitude, pos.longitude),
      travelMode: TravelMode.transit,
    );
    print("st ${_currentPosition.latitude}, ${_currentPosition.longitude}");
    print("des ${pos.latitude}, ${pos.longitude}");
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          zoom: 14,
        ),
      ),
    );

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  getNearbyPlacesDistance() {}

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

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<bool> _calculateDistance() async {
    try {
      // Retrieving placemarks from addresses
      List<gCoding.Location> startPlacemark =
          await gCoding.locationFromAddress(_startAddress);
      List<gCoding.Location> destinationPlacemark =
          await gCoding.locationFromAddress(_destinationAddress);

      if (startPlacemark != null && destinationPlacemark != null) {
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        Position startCoordinates = _startAddress == _currentAddress
            ? Position(
                latitude: _currentPosition.latitude,
                longitude: _currentPosition.longitude)
            : Position(
                latitude: startPlacemark[0].latitude,
                longitude: startPlacemark[0].longitude);
        Position destinationCoordinates = Position(
            latitude: destinationPlacemark[0].latitude,
            longitude: destinationPlacemark[0].longitude);

        // Start Location Marker
        Marker startMarker = Marker(
          markerId: MarkerId('$startCoordinates'),
          position: LatLng(
            startCoordinates.latitude,
            startCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: _startAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId('$destinationCoordinates'),
          position: LatLng(
            destinationCoordinates.latitude,
            destinationCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: _destinationAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Adding the markers to the list
        markers.add(startMarker);
        markers.add(destinationMarker);

        print('START COORDINATES: $startCoordinates');
        print('DESTINATION COORDINATES: $destinationCoordinates');

        Position _northeastCoordinates;
        Position _southwestCoordinates;

        // Calculating to check that the position relative
        // to the frame, and pan & zoom the camera accordingly.
        double miny =
            (startCoordinates.latitude <= destinationCoordinates.latitude)
                ? startCoordinates.latitude
                : destinationCoordinates.latitude;
        double minx =
            (startCoordinates.longitude <= destinationCoordinates.longitude)
                ? startCoordinates.longitude
                : destinationCoordinates.longitude;
        double maxy =
            (startCoordinates.latitude <= destinationCoordinates.latitude)
                ? destinationCoordinates.latitude
                : startCoordinates.latitude;
        double maxx =
            (startCoordinates.longitude <= destinationCoordinates.longitude)
                ? destinationCoordinates.longitude
                : startCoordinates.longitude;

        _southwestCoordinates = Position(latitude: miny, longitude: minx);
        _northeastCoordinates = Position(latitude: maxy, longitude: maxx);

        // Accommodate the two locations within the
        // camera view of the map
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(
                _northeastCoordinates.latitude,
                _northeastCoordinates.longitude,
              ),
              southwest: LatLng(
                _southwestCoordinates.latitude,
                _southwestCoordinates.longitude,
              ),
            ),
            100.0,
          ),
        );

        // Calculating the distance between the start and the end positions
        // with a straight path, without considering any route
        // double distanceInMeters = await Geolocator().bearingBetween(
        //   startCoordinates.latitude,
        //   startCoordinates.longitude,
        //   destinationCoordinates.latitude,
        //   destinationCoordinates.longitude,
        // );

        await _createPolylines(startCoordinates, destinationCoordinates);

        double totalDistance = 0.0;

        // Calculating the total distance by adding the distance
        // between small segments
        for (int i = 0; i < polylineCoordinates.length - 1; i++) {
          totalDistance += _coordinateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude,
          );
        }

        setState(() {
          _placeDistance = totalDistance.toStringAsFixed(2);
          print('DISTANCE: $_placeDistance km');
        });

        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Create the polylines for showing the route between two places
  _createPolylines(Position start, Position destination) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCZjrzw-ltJyYGJqNLFLwuGzxuZSSX6ig8', // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fabHeight = _initFabHeight;
  }

  @override
  void dispose() {
    super.dispose();
    // TODO: implement dispose
    _getCurrentLocation();
  }

  Size size;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    size = MediaQuery.of(context).size;

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
                setState(() {
                  showDistance = !showDistance;
                });
                placesMarkers.clear();
                polylines.clear();

                startAddressController.text = '';
                destinationAddressController.text = '';
                _placeDistance = '0.0';
              },
              child: Icon(Icons.directions),
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            // Map View
            GoogleMap(
              markers: markers != null ? Set<Marker>.of(placesMarkers) : null,
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
                          onPressed: () async {
                            keyword = 'Emergency Hospital';
                            searchNearby(_currentPosition.latitude,
                                _currentPosition.longitude);
                            btnCTR = 0;
                            _showPlacesPanel();
                          },
                        ),
                        RaisedButton(
                          color: Colors.white,
                          child: Text('Police Station'),
                          onPressed: () {
                            keyword = 'Police Station';
                            searchNearby(_currentPosition.latitude,
                                _currentPosition.longitude);

                            btnCTR = 0;
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

                            btnCTR = 0;
                            _showPlacesPanel();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            showDirectionsSheet()
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

  _panel(ScrollController sc) {
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
                    setState(() {
                      btnCTR++;
                    });
                    if (btnCTR <= 1) {
                      String hospital = places[index].name;
                      //geocoding reverse
                      var addresses =
                          await Geocoder.local.findAddressesFromQuery(hospital);
                      var first = addresses.first;
                      debugPrint("${first.featureName} : ${first.coordinates}");
                      Position posit = Position(
                          latitude: first.coordinates.latitude,
                          longitude: first.coordinates.longitude);

                      await getHospitals(posit);
                      getHospitals(posit);

                      Navigator.pop(context);
                    } else {}
                  },
                  child: Card(
                    child: ListTile(
                      title: Text('${places[index].name}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${places[index].vicinity}'),
                          Text(
                              'User Ratings: ${places[index].userRatingsTotal}'),
                          Text('General Rating: ${places[index].rating}'),
                          // Text('${places[index].photos[}')
                        ],
                      ),
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

  showDirectionsSheet() {
    return Visibility(
      visible: showDistance,
      child: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              width: size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Places',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 10),
                    _textField(
                        label: 'Start',
                        hint: 'Choose starting point',
                        prefixIcon: Icon(Icons.looks_one),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.my_location),
                          onPressed: () {
                            startAddressController.text = _currentAddress;
                            _startAddress = _currentAddress;
                          },
                        ),
                        controller: startAddressController,
                        focusNode: startAddressFocusNode,
                        width: size.width,
                        locationCallback: (String value) {
                          setState(() {
                            _startAddress = value;
                          });
                        }),
                    SizedBox(height: 10),
                    _textField(
                        label: 'Destination',
                        hint: 'Choose destination',
                        prefixIcon: Icon(Icons.looks_two),
                        controller: destinationAddressController,
                        focusNode: desrinationAddressFocusNode,
                        width: size.width,
                        locationCallback: (String value) {
                          setState(() {
                            _destinationAddress = value;
                          });
                        }),
                    SizedBox(height: 10),
                    Visibility(
                      visible: _placeDistance == null ? false : true,
                      child: Text(
                        'DISTANCE: $_placeDistance km',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    RaisedButton(
                      onPressed: (_startAddress != '' &&
                              _destinationAddress != '')
                          ? () async {
                              startAddressFocusNode.unfocus();
                              desrinationAddressFocusNode.unfocus();
                              setState(() {
                                if (markers.isNotEmpty) markers.clear();
                                if (polylines.isNotEmpty) polylines.clear();
                                if (polylineCoordinates.isNotEmpty)
                                  polylineCoordinates.clear();
                                _placeDistance = null;
                              });

                              _calculateDistance().then((isCalculated) {
                                if (isCalculated) {
                                  _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Distance Calculated Sucessfully'),
                                    ),
                                  );
                                } else {
                                  _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Error Calculating Distance'),
                                    ),
                                  );
                                }
                              });
                            }
                          : null,
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Show Route'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
