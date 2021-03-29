import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:SOSMAK/screens/wantedList_screens/hiddenWantedList.dart';
import 'package:SOSMAK/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/wantedModel.dart';
import '../wantedList_screens/createWanted.dart';

class WantedList extends StatefulWidget {
  final bool isAdmin;

  WantedList({@required this.isAdmin});
  @override
  _WantedListState createState() => _WantedListState();
}

class _WantedListState extends State<WantedList> {
  Size size;
  UserDetailsProvider currentUser;
  bool isAdmin = false;
  bool isHidden = false;
  @override
  void initState() {
    // TODO: implement initState
    currentUser = Provider.of<UserDetailsProvider>(context, listen: false);
    if (currentUser.currentUser.role == 'admin') {
      setState(() {
        isAdmin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    print(currentUser.currentUser.role);
    return Scaffold(
        backgroundColor: Color(0xFF93E9BE),
        floatingActionButton: Visibility(
          visible: isAdmin,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.red,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateWanted()),
              );
            },
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text('Most Wanted List'),
          leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            widget.isAdmin
                ? IconButton(
                    icon: Icon(Icons.visibility_off_outlined, size: 30),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HiddenWantedList()),
                    ),
                  )
                : IconButton(
                    icon: Icon(Icons.info, size: 30),
                    onPressed: () => showReminderDialog(),
                  ),
          ],
        ),
        body: Column(
          children: [
            _buildWantedStream(level: 1, title: 'HIGH PROFILE WANTED'),
            _buildWantedStream(level: 2, title: 'LOW PROFILE WANTED')
            // StreamBuilder<QuerySnapshot>(
            //     stream:
            //         FirebaseFirestore.instance.collection('wantedList').where('isHidden', isEqualTo: false).snapshots(),
            //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //       if (snapshot.hasData) {
            //         return Padding(
            //           padding: EdgeInsets.symmetric(vertical: 25),
            //           child: Align(
            //             alignment: Alignment.topCenter,
            //             child: ListView(
            //               addAutomaticKeepAlives: true,
            //               scrollDirection: Axis.horizontal,
            //               children: snapshot.data.docs.map<Widget>((doc) => _wantedCard(doc)).toList(),
            //             ),
            //           ),
            //         );
            //       }

            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }),
          ],
        ));
  }

  _buildWantedStream({@required int level, @required String title}) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('wantedList')
            .where('isHidden', isEqualTo: false)
            .where('crimeLevel', isEqualTo: level)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length != 0) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: size.width * .95,
                          height: size.height * .2,
                          child: ListView(
                              addAutomaticKeepAlives: true,
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data.docs.map<Widget>((doc) => _wantedCard(doc)).toList()),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Container(
                            width: size.width * .95,
                            height: size.height * .2,
                            child: Text("There's no $title Incident")),
                      ],
                    ),
                  ),
                ),
              );
            }
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  _wantedCard(doc) {
    Wanted wanted = Wanted.getData(doc: doc);
    return Stack(
      children: [
        Card(
          elevation: 5,
          child: InkWell(
            onTap: () {
              //SHOW POPUP
              if (wanted.imageUrl != null) {
                showAlertDialog(context, wanted: wanted);
              }
            },
            child: Container(
              width: size.width * .4,
              height: size.height * .35,
              child: WantedPoster(
                isMini: true,
                wanted: wanted,
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.isAdmin,
          child: Positioned(
              top: 0,
              right: 0,
              child: ClipOval(
                child: Material(
                  color: Colors.red,
                  child: InkWell(
                    splashColor: Colors.grey[100],
                    child: SizedBox(
                        width: 25,
                        height: 25,
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.white,
                        )),
                    onTap: () {
                      isHidden = true;
                      UserService().deleteWanted(doc, isHidden);
                    },
                  ),
                ),
              )),
        )
      ],
    );
  }

  showAlertDialog(BuildContext context, {@required Wanted wanted}) {
    AlertDialog alert = AlertDialog(
        contentPadding: EdgeInsets.all(12),
        content: Container(
          width: size.width * .7,
          height: size.height * .8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WantedPoster(
                isMini: false,
                wanted: wanted,
              ),
              MaterialButton(
                color: Colors.redAccent,
                onPressed: () => _launchURL(wanted.contactHotline),
                child: Text(
                  'Contact Hotline',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ));

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _launchURL(String number) async {
    String url = 'tel:' + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  showReminderDialog() {
    AlertDialog alert = AlertDialog(
        contentPadding: EdgeInsets.all(12),
        title: Text('Note', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        content: Container(
          width: size.width,
          height: size.height * .6,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text('High Level Crimes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                      '•	Rape\n•	Murder\n•	Terrorism\n•	Robbery\n•	Any Crime Abuse\n•	Cyber Crime\n•	High Class – Drug Lord\n•	Sexual Harassment\n•	Fraud\n•	Kidnapping'),
                ),
                SizedBox(height: 20),
                Text('Low Level Crimes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                      '•	Snatching\n•	Brawl\n•	Assault\n•	Low Class-Drug Users and Sellers\n•	Shoplifting\n•	Violent Crime\n•	Burglary'),
                ),
              ],
            ),
          ),
        ));

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class WantedPoster extends StatefulWidget {
  final Wanted wanted;
  final bool isMini;
  WantedPoster({@required this.wanted, @required this.isMini});

  @override
  _WantedPosterState createState() => _WantedPosterState();
}

class _WantedPosterState extends State<WantedPoster> {
  @override
  Widget build(BuildContext context) {
    if (widget.isMini) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(
            //   'WANTED',
            //   style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
            // ),
            Container(
              height: 150,
              padding: const EdgeInsets.all(10),
              child: Image.network(widget.wanted.imageUrl),
            ),
            // Text(
            //   'Reward:' + widget.wanted.reward,
            //   style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(3.0),
            //   child: Text(
            //     widget.wanted.name,
            //     textAlign: TextAlign.center,
            //     overflow: TextOverflow.ellipsis,
            //   ),
            // )
          ],
        ),
      );
    } else {
      return Container(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Republic of the Philippines',
                    style: customTextStyle(12.0),
                  ),
                  Text(
                    'National Police Commission',
                    style: customTextStyle(15.0),
                  ),
                  Text(
                    'Philippine National Police',
                    style: customTextStyle(12.0),
                  ),
                  Text(
                    'WANTED',
                    style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Image.network(
                    widget.wanted.imageUrl,
                    fit: BoxFit.contain,
                    height: 220,
                  ),
                  Text(
                    'DEAD OR ALIVE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Name',
                    style: customTextStyle(10.0),
                  ),
                  Text(
                    widget.wanted.name,
                    style: customTextStyle(17.0),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'AKA: ' + '"' + widget.wanted.alias + '"',
                    style: customTextStyle(17.0),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Criminal Case Number',
                    style: customTextStyle(10.0),
                  ),
                  Text(
                    widget.wanted.criminalCaseNumber,
                    textAlign: TextAlign.center,
                    style: customTextStyle(15.0),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Last Known Address',
                    style: customTextStyle(10.0),
                  ),
                  Text(
                    widget.wanted.lastKnownAddress,
                    textAlign: TextAlign.center,
                    style: customTextStyle(15.0),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Reward ",
                    style: customTextStyle(10.0),
                  ),
                  Text(
                    widget.wanted.reward,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: -15,
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                    width: 70,
                    height: 70,
                    child: Image.asset(
                      'assets/pnp-logo.png',
                      fit: BoxFit.contain,
                    )),
              ),
            ),
          ],
        ),
      );
    }
  }

  customTextStyle(size) {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: size);
  }
}
