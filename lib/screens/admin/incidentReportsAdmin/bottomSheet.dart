import 'package:SOSMAK/models/incidentmodel.dart';
import 'package:flutter/material.dart';

class IncidentReportBottomSheet extends StatefulWidget {
  final IncidentModel incident;
  final BuildContext context;
  IncidentReportBottomSheet({@required this.incident, @required this.context});

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
        height: size.height * .5,
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            Stack(children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: size.height * .45,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                buildChip(text: widget.incident.incident)
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Date: ' + widget.incident.date,
                              style: whiteText(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Location:' + widget.incident.location,
                              style: whiteText(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Description:',
                              style: whiteText(),
                            ),
                            SizedBox(
                              height: 10,
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
                            MaterialButton(
                              color: Colors.white,
                              elevation: 2,
                              onPressed: () {},
                              child: Text('Update Status'),
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
            Container(
              child: Text(
                'Dispatch',
                style: whiteText(),
              ),
            ),
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
