import 'package:SOSMAK/models/incidentmodel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IncidentReportAdmin extends StatefulWidget {
  IncidentReportAdmin({Key key}) : super(key: key);

  @override
  _IncidentReportAdminState createState() => _IncidentReportAdminState();
}

class _IncidentReportAdminState extends State<IncidentReportAdmin> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Incident Report Admin'),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            //pending
            _buildStream(status: 0, title: 'Pending'),
            _buildStream(status: 1, title: 'In Progress')
            //is in progress
            //closed
          ],
        ),
      ),
    );
  }

  _buildStream({@required int status, @required String title}) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('incidentReport')
            .where('status', isEqualTo: status)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length != 0) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title),
                        Container(
                          width: size.width * .95,
                          height: size.height * .2,
                          child: ListView(
                              addAutomaticKeepAlives: true,
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data.docs
                                  .map<Widget>(
                                      (doc) => _buildCard(doc, context))
                                  .toList()),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container(
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title),
                      Text('empty'),
                    ],
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

  _buildCard(DocumentSnapshot doc, BuildContext context) {
    IncidentModel incident = IncidentModel.get(doc);

    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          showBottomSheet(
              context: context,
              builder: (context) => _buildBottomSheet(context, incident));
        },
        child: Container(
          width: size.width * .5,
          height: size.height * .1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Incident:' + '\n' + doc.id),
              Text('Date:' + '\n' + incident.date),
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomSheet(BuildContext context, IncidentModel incident) {
    bool showDispatch = true;
    if (incident.status == 1) {
      showDispatch = false;
    }
    return Container(
        color: Colors.grey[900],
        height: size.height * .5,
        child: Stack(children: [
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
                            buildChip(text: incident.incident)
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Date: ' + incident.date,
                          style: whiteText(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Location:' + incident.location,
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
                            incident.desc,
                            style: whiteText(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: showDispatch,
                          child: MaterialButton(
                            color: Colors.blueAccent,
                            elevation: 3,
                            onPressed: () {},
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
        ]));
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
