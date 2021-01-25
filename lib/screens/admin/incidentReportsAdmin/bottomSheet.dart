import 'package:SOSMAK/models/incidentmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    if (widget.incident.status != 0) {
      showDispatch = false;
    }
    var size = MediaQuery.of(context).size;
    return Container(
        color: Colors.grey[900],
        height: size.height * .7,
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            Stack(children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: size.height * .7,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: size.height * 0.05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    buildChip(text: widget.incident.incident),
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
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                widget.incident.desc,
                                style: whiteText(),
                              ),
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Visibility(
                            //   visible: showDispatch,
                            //   child: MaterialButton(
                            //     color: Colors.blueAccent,
                            //     elevation: 3,
                            //     onPressed: () {
                            //       _pageController.animateToPage(
                            //         1,
                            //         duration: const Duration(milliseconds: 400),
                            //         curve: Curves.easeInOut,
                            //       );
                            //     },
                            //     child: Text('Dispatch Officers'),
                            //   ),
                            // ),
                            Image.network(widget.incident.imageUrl ?? '',
                                width: 80, height: 80),
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
}
