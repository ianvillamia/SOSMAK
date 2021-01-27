import 'package:SOSMAK/models/incidentmodel.dart';
import 'package:SOSMAK/screens/incident_report/viewImages.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'updateIncident.dart';

class IncidentReportBottomSheet extends StatefulWidget {
  final DocumentSnapshot doc;
  final IncidentModel incident;
  final BuildContext context;
  IncidentReportBottomSheet(
      {@required this.doc, @required this.incident, @required this.context});

  @override
  _IncidentReportBottomSheetState createState() =>
      _IncidentReportBottomSheetState();
}

class _IncidentReportBottomSheetState extends State<IncidentReportBottomSheet> {
  PageController _pageController;
  bool showDispatch = true;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Size size;
  @override
  Widget build(BuildContext context) {
    if (widget.incident.status != 0) {
      showDispatch = false;
    }
    size = MediaQuery.of(context).size;
    return Container(
        color: Colors.grey[900],
        height: size.height * .7,
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            Column(
              children: [
                Stack(children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: size.height * .5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: size.height * 0.05),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Incident:',
                                          style: whiteText(),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        buildChip(
                                            text: widget.incident.incident),
                                      ],
                                    ),
                                    Text(
                                      'Date: ' + widget.incident.date,
                                      style: whiteText(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Location: ' + widget.incident.location,
                                  style: whiteText(),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Description: ',
                                  style: whiteText(),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 5, 5, 20),
                                  child: Text(
                                    widget.incident.desc,
                                    style: whiteText(),
                                  ),
                                ),
                                Text(
                                  'Images: ${widget.incident.imageUrls.length}',
                                  style: whiteText(),
                                ),
                                getImages(doc: widget.doc),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ]),
                MaterialButton(
                  color: Colors.white,
                  elevation: 2,
                  child: Text('Update Status'),
                  onPressed: () {
                    _pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ),
            //DIPATCH OFFICERS//
            UpdateIncidentReport(doc: widget.doc, incident: widget.incident),
          ],
        ));
  }

  whiteText() {
    return TextStyle(color: Colors.white, fontSize: 17);
  }

  buildChip({@required String text}) {
    Color color = Colors.red;
    switch (text.toLowerCase()) {
      case 'murder':
        color = Colors.red;

        break;
      default:
        color = Colors.grey;
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)), color: color),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  getImages({@required DocumentSnapshot doc}) {
    List images = doc.data()['imageUrls'];
    print(doc);
    if (images.length != 0) {
      return Container(
        width: size.width,
        height: size.height * .25,
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: images
                    ?.map<Widget>((doc) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: ('assets/loading.gif'),
                            image: doc.toString(),
                            width: 120,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ))
                    ?.toList() ??
                []),
      );
    }
  }
}
