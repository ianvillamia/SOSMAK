import 'package:SOSMAK/models/incidentmodel.dart';
import 'package:SOSMAK/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CurrentIncident extends StatefulWidget {
  final String documentId;
  CurrentIncident({this.documentId});

  @override
  _CurrentIncidentState createState() => _CurrentIncidentState();
}

class _CurrentIncidentState extends State<CurrentIncident> {
  Size size;
  @override
  Widget build(BuildContext context) {
    print(widget.documentId);
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('incidentReports')
                .doc(widget.documentId)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              print(snapshot.connectionState);

              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  //_buildMedicalReport(snapshot.data);
                  print(snapshot.data);
                  return _buildCurrentIncident(snapshot.data, snapshot.data.id);
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  _buildCurrentIncident(DocumentSnapshot doc, String id) {
    IncidentModel incident = IncidentModel.get(doc);
    String status;
    Color color;
    switch (incident.status) {
      case 0:
        color = Colors.amber;
        status =
            'Reported please wait for authorities to arrive to your location ';
        break;
      case 1:
        color = Colors.orange;
        status = 'Authorities are on the way';
        break;
      case 2:
        color = Colors.green;
        status = 'Completed';
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            elevation: 5,
            color: color,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(status,
                  textAlign: TextAlign.center,
                  style: _buildtextStyle(
                      fontWeight: FontWeight.bold,
                      fontsize: 20,
                      color: Colors.white)),
            ),
          ),
          SizedBox(
            height: 25,
          ),
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
            'Reference number:\n$id',
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
            'Location:\n' + incident.location,
            style: _buildtextStyle(fontsize: 15),
          ),
          //RHOWEL ADD IMAGES HERE
        ],
      ),
    );
  }

  _buildtextStyle({double fontsize, FontWeight fontWeight, Color color}) {
    return TextStyle(
        color: color ?? Colors.black,
        fontSize: fontsize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal);
  }
}
