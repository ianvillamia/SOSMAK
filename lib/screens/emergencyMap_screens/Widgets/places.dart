import 'package:SOSMAK/screens/emergencyMap_screens/data/place_response.dart';
import 'package:SOSMAK/screens/emergencyMap_screens/data/result.dart';
import 'package:SOSMAK/screens/emergencyMap_screens/test2.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PlacesBottomSheet extends StatefulWidget {
  final String keyword;
  PlacesBottomSheet({this.keyword});
  @override
  _PlacesBottomSheetState createState() => _PlacesBottomSheetState();
}

class _PlacesBottomSheetState extends State<PlacesBottomSheet> {
  final double _initFabHeight = 120.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;
  List<Result> places;
  List<Marker> placesMarkers = <Marker>[];
  int items = 0;
  String keyword;
  // void resultPlaces(data) {
  //   setState(() {
  //     rPlaces = PlaceResponse.parseResults(data['results']);
  //     for (int i = 0; i < rPlaces.length; i++) {
  //       items = rPlaces.length;
  //       placesMarkers.add(
  //         Marker(
  //           markerId: MarkerId(rPlaces[i].placeId),
  //           position: LatLng(rPlaces[i].geometry.location.lat,
  //               rPlaces[i].geometry.location.long),
  //           infoWindow: InfoWindow(
  //               title: rPlaces[i].name, snippet: rPlaces[i].vicinity),
  //           onTap: () {},
  //         ),
  //       );
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;

    return SlidingUpPanel(
      maxHeight: _panelHeightOpen,
      minHeight: _panelHeightClosed,
      panelBuilder: (sc) => _panel(sc),
      onPanelSlide: (double pos) => setState(() {
        _fabHeight =
            pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
      }),
    );
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
                "Nearby ${widget.keyword}",
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
