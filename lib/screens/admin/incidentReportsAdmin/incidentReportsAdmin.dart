import 'package:SOSMAK/models/incidentmodel.dart';
import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:SOSMAK/screens/admin/incidentReportsAdmin/bottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class IncidentReportAdmin extends StatefulWidget {
  IncidentReportAdmin({Key key}) : super(key: key);

  @override
  _IncidentReportAdminState createState() => _IncidentReportAdminState();
}

class _IncidentReportAdminState extends State<IncidentReportAdmin> {
  Size size;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isPolice, isAdmin, isBoth;
  UserDetailsProvider userDetailsProvider;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);
    if (userDetailsProvider.currentUser.role == 'police') {
      isPolice = true;
      isAdmin = false;
      isBoth = true;
    } else if (userDetailsProvider.currentUser.role == 'admin') {
      isPolice = false;
      isAdmin = true;
      isBoth = true;
    }
    return Scaffold(
      backgroundColor: Color(0xFF93E9BE),
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Incident Report Admin'),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            //pending
            Visibility(
              visible: isPolice,
              child: _buildStream(status: 0, title: 'Pending', userDetailsProvider: userDetailsProvider),
            ),
            //is in progress
            Visibility(
              visible: isBoth,
              child: _buildStream(status: 1, title: 'In Progress', userDetailsProvider: userDetailsProvider),
            ),
            //closed
            Visibility(
                visible: isAdmin,
                child: _buildStream(status: 2, title: 'Solved', userDetailsProvider: userDetailsProvider)),
          ],
        ),
      ),
    );
  }

  _buildStream({@required UserDetailsProvider userDetailsProvider, @required int status, @required String title}) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('incidentReports').where('status', isEqualTo: status).snapshots(),
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
                              children: snapshot.data.docs
                                  .map<Widget>((doc) => _buildCard(userDetailsProvider, doc, context))
                                  .toList()),
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

  _buildCard(UserDetailsProvider userDetailsProvider, DocumentSnapshot doc, BuildContext context) {
    IncidentModel incident = IncidentModel.get(doc);
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => Container(
                  height: MediaQuery.of(context).size.height * 0.95,
                  child: _buildBottomSheet(userDetailsProvider, doc, context, incident)));
        },
        child: Container(
          padding: EdgeInsets.all(8),
          width: size.width * .5,
          height: size.height * .1,
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

  _buildBottomSheet(
      UserDetailsProvider userDetailsProvider, DocumentSnapshot doc, BuildContext context, IncidentModel incident) {
    return IncidentReportBottomSheet(
      userDetailsProvider: userDetailsProvider,
      doc: doc,
      incident: incident,
      context: context,
    );
  }

  whiteText() {
    return TextStyle(color: Colors.white, fontSize: 17);
  }
}
