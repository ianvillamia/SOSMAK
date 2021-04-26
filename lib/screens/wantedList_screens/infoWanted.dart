import 'package:SOSMAK/models/wantedModel.dart';
import 'package:SOSMAK/screens/wantedList_screens/wantedList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotAlert extends StatefulWidget {
  SpotAlert({Key key}) : super(key: key);

  @override
  _SpotAlertState createState() => _SpotAlertState();
}

class _SpotAlertState extends State<SpotAlert> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF93E9BE),
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Spot Alert'),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('wantedList').where('izSpotted', isEqualTo: true).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.size > 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Wrap(
                              children: snapshot.data.docs.map<Widget>((doc) => _buildWantedCard(doc)).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text('No History of Incident Report yet'));
                }
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  _buildWantedCard(DocumentSnapshot doc) {
    Wanted wanted = Wanted.getData(doc: doc);

    return InkWell(
      onTap: () {
        showNotifyDialog(context, doc, wanted: wanted);
      },
      child: Card(
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(wanted.name),
              Text(wanted.spottedDate),
            ],
          ),
        ),
      ),
    );
  }

  showNotifyDialog(BuildContext context, DocumentSnapshot doc, {@required Wanted wanted}) {
    AlertDialog alert = AlertDialog(
        contentPadding: EdgeInsets.all(12),
        content: Container(
          width: size.width * .7,
          height: size.height * .8,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WantedPoster(
                  isMini: false,
                  wanted: wanted,
                ),
                SizedBox(height: 10),
                Text(
                  'Description:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(wanted.spottedDescription),
                SizedBox(height: 10),
                Text(
                  'Spotted By:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Citizen Name: ${wanted.spottedCitizenName}'),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        color: Colors.redAccent,
                        child: Text(
                          'Call a Officer',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      MaterialButton(
                        color: Colors.redAccent,
                        child: Text(
                          'Remove from List',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          CollectionReference wanted = FirebaseFirestore.instance.collection('wantedList');

                          wanted.doc(doc.id).update({'izSpotted': false}).then((value) => Navigator.pop(context));
                        },
                      ),
                    ],
                  ),
                )
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
