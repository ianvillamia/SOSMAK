import 'package:flutter/material.dart';

class PlacesDetails extends StatefulWidget {
  final BuildContext context;
  final String name, vicinity;
  PlacesDetails({@required this.context,@required this.name,@required this.vicinity});

  @override
  _PlacesDetailsState createState() => _PlacesDetailsState();
}

class _PlacesDetailsState extends State<PlacesDetails> {
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
    var size = MediaQuery.of(context).size;
    return Container(
        height: size.height * .45,
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
                                  'Incident:' + widget.name,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Date: ' + widget.vicinity),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Location:'),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Description:',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('asdasdasd'),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: showDispatch,
                              child: MaterialButton(
                                color: Colors.blueAccent,
                                elevation: 3,
                                onPressed: () {
                                  _pageController.animateToPage(
                                    1,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Text('Dispatch Officers'),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
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
              ),
            ),
          ],
        ));
  }
}
