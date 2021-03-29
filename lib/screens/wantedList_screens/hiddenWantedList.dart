import 'package:SOSMAK/models/wantedModel.dart';
import 'package:SOSMAK/screens/wantedList_screens/wantedList.dart';
import 'package:SOSMAK/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HiddenWantedList extends StatefulWidget {
  @override
  _HiddenWantedListState createState() => _HiddenWantedListState();
}

class _HiddenWantedListState extends State<HiddenWantedList> {
  bool isHidden;
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xFF93E9BE),
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text('Hidden Most Wanted List'),
        ),
        body: Column(
          children: [
            _buildWantedStream(level: 1, title: 'HIGH PROFILE WANTED'),
            _buildWantedStream(level: 2, title: 'LOW PROFILE WANTED')
          ],
        ));
  }

  _buildWantedStream({@required int level, @required String title}) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('wantedList')
            .where('isHidden', isEqualTo: true)
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
                          child: Text("There's no hidden $title"),
                        ),
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
        Positioned(
          top: 0,
          right: 0,
          child: ClipOval(
            child: Material(
              color: Colors.green,
              child: InkWell(
                splashColor: Colors.grey[100],
                child: SizedBox(
                    width: 25,
                    height: 25,
                    child: Icon(
                      Icons.undo,
                      size: 20,
                      color: Colors.white,
                    )),
                onTap: () {
                  isHidden = false;
                  UserService().deleteWanted(doc, isHidden);
                },
              ),
            ),
          ),
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
}
