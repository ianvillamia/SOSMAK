import 'package:SOSMAK/models/incidentmodel.dart';
import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncidentReportHistory extends StatefulWidget {
  @override
  _IncidentReportHistoryState createState() => _IncidentReportHistoryState();
}

class _IncidentReportHistoryState extends State<IncidentReportHistory> {
  UserDetailsProvider userDetailsProvider;
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final firebaseUser = context.watch<User>();
    userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Color(0xFF93E9BE),
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('incidentReports')
                .where('reporterRef', isEqualTo: userDetailsProvider.currentUser.ref)
                .where('status', isEqualTo: 2)
                .orderBy('date', descending: false)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.size > 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        child: Wrap(
                          children: snapshot.data.docs.map<Widget>((doc) => _buildHistoryCard(doc)).toList(),
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

  _buildHistoryCard(DocumentSnapshot doc) {
    IncidentModel incident = IncidentModel.get(doc);
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () => showDetails(doc),
        child: Container(
          padding: EdgeInsets.all(8),
          width: size.width * .43,
          height: size.height * .2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Incident:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(incident.incident),
              SizedBox(height: size.height * 0.04),
              Text('Date:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(incident.date),
            ],
          ),
        ),
      ),
    );
  }

  showDetails(DocumentSnapshot doc) {
    IncidentModel incident = IncidentModel.get(doc);
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(10),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
          height: size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Report Details',
                style: _buildtextStyle(fontsize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Date:\n' + incident.date,
                style: _buildtextStyle(fontsize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Reference number:\n${doc.id}',
                style: _buildtextStyle(fontsize: 15),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Incident:\n' + incident.incident,
                style: _buildtextStyle(fontsize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Description:\n' + incident.desc,
                style: _buildtextStyle(fontsize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Location:\n' + incident.location,
                style: _buildtextStyle(fontsize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Image/s: ',
                style: _buildtextStyle(fontsize: 15),
              ),
              getImages(doc: doc)
            ],
          ),
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _buildtextStyle({double fontsize, FontWeight fontWeight, Color color}) {
    return TextStyle(
        color: color ?? Colors.black, fontSize: fontsize ?? 14, fontWeight: fontWeight ?? FontWeight.normal);
  }

  getImages({@required DocumentSnapshot doc}) {
    List images = doc.data()['images'];
    print(doc);
    if (images.length != 0) {
      return Container(
        width: size.width,
        height: size.height * .25,
        child: Scrollbar(
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: images
                      ?.map<Widget>((doc) => InkWell(
                            onTap: () {
                              //showImageDialog(doc.toString());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: FadeInImage.assetNetwork(
                                placeholder: ('assets/loading.gif'),
                                image: doc.toString(),
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ))
                      ?.toList() ??
                  []),
        ),
      );
    }
  }
}
