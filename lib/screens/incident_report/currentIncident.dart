import 'package:SOSMAK/models/incidentmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CurrentIncident extends StatefulWidget {
  final String documentId;

  CurrentIncident({@required this.documentId});

  @override
  _CurrentIncidentState createState() => _CurrentIncidentState();
}

class _CurrentIncidentState extends State<CurrentIncident> {
  @override
  void initState() {
    super.initState();
    print(widget.documentId);
  }

  Size size;
  @override
  Widget build(BuildContext context) {
    print(widget.documentId);
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF93E9BE),
      body: Container(
        color: Color(0xFF93E9BE),
        width: size.width,
        height: size.height,
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('incidentReports').doc(widget.documentId).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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

              return Center(
                child: CircularProgressIndicator(),
              );
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
        status = 'Reported please wait for authorities to arrive to your location ';
        break;
      case 1:
        color = Colors.orange;
        status = 'Authorities are on the way';
        break;
      case 2:
        color = Colors.green;
        status = 'Solved';
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Card(
              elevation: 5,
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(status,
                    textAlign: TextAlign.center,
                    style: _buildtextStyle(fontWeight: FontWeight.bold, fontsize: 20, color: Colors.white)),
              ),
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
            'Image/s: ',
            style: _buildtextStyle(fontsize: 15),
          ),
          getImages(doc: doc)
        ],
      ),
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
