import 'package:SOSMAK/models/emergencyModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BarangayNumbers extends StatefulWidget {
  final DocumentSnapshot doc;
  BarangayNumbers({this.doc});
  @override
  _BarangayNumbersState createState() => _BarangayNumbersState();
}

class _BarangayNumbersState extends State<BarangayNumbers> {
  PageController _pageController;
  int currentIndex = 0;
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

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  nextFunction() {
    _pageController.nextPage(duration: _kDuration, curve: _kCurve);
  }

  previousFunction() {
    _pageController.previousPage(duration: _kDuration, curve: _kCurve);
  }

  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF93E9BE),
      appBar: AppBar(
        title: Text(
          'Barangay Emergency HOTLINE',
        ),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          PageView(
            onPageChanged: onChangedFunction,
            controller: _pageController,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                width: size.width,
                height: size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          child: Text(
                            'TAP TO CALL',
                            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * .01),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          child: Text(
                            'District I',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * .03),
                      Container(
                        height: size.height * 0.65,
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('emergencyNumbers')
                                .where('category', isEqualTo: 'barangay')
                                .where('district', isEqualTo: '1')
                                .orderBy('name', descending: false)
                                .snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              print("SNAPSHOT ${snapshot.data}");
                              if (snapshot.hasData) {
                                return SingleChildScrollView(
                                  child: Column(
                                      children: snapshot.data.docs
                                          .map<Widget>((doc) => buildTiles(
                                                doc: doc,
                                              ))
                                          .toList()),
                                );
                              }
                              return Center(child: CircularProgressIndicator());
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: size.width,
                height: size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          child: Text(
                            'TAP TO CALL',
                            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * .01),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          child: Text(
                            'District II',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * .03),
                      Container(
                        height: size.height * 0.65,
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('emergencyNumbers')
                                .where('category', isEqualTo: 'barangay')
                                .where('district', isEqualTo: '2')
                                .orderBy('name', descending: false)
                                .snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              print("SNAPSHOT ${snapshot.data}");
                              if (snapshot.hasData) {
                                return SingleChildScrollView(
                                  child: Column(
                                      children: snapshot.data.docs
                                          .map<Widget>((doc) => buildTiles(
                                                doc: doc,
                                              ))
                                          .toList()),
                                );
                              }
                              return Center(child: CircularProgressIndicator());
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: size.width * 0.3,
                      child: MaterialButton(
                        padding: const EdgeInsets.all(30),
                        color: Colors.green,
                        onPressed: () => previousFunction(),
                        child: Text("District 1"),
                      ),
                    ),
                    Container(
                      width: size.width * 0.3,
                      child: MaterialButton(
                        padding: const EdgeInsets.all(30),
                        color: Colors.green,
                        onPressed: () => nextFunction(),
                        child: Text("District 2"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  buildTiles({DocumentSnapshot doc}) {
    EmergencyModel emergency = EmergencyModel.get(doc);
    String mobile = emergency.mobileNo.isEmpty ? 'No mobile number' : emergency.mobileNo;
    return Container(
      padding: EdgeInsets.all(3),
      child: Column(
        children: [
          Card(
            elevation: 3,
            child: ListTile(
              title: Text(emergency.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(emergency.subtitle, style: TextStyle(fontSize: 15)),
                Text(emergency.telNo, style: TextStyle(fontSize: 15)),
                Text(mobile, style: TextStyle(fontSize: 15))
              ]),
              trailing: InkWell(
                child: Icon(
                  Icons.call,
                  color: Colors.green,
                ),
                onTap: () {
                  String nums;
                  if (emergency.mobileNo.contains('No mobile number') || emergency.mobileNo.isEmpty) {
                    nums = emergency.telNo;
                  } else {
                    nums = emergency.mobileNo;
                  }
                  _launchURL(number: nums);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _launchURL({String number}) async {
    String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Indicator extends StatelessWidget {
  final int positionIndex, currentIndex;
  const Indicator({this.currentIndex, this.positionIndex});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          color: positionIndex == currentIndex ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(100)),
    );
  }
}
