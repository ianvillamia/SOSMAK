import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:SOSMAK/screens/admin/create_police_account/createPoliceAccount.dart';

import 'package:SOSMAK/screens/chat_screens/chat_home.dart';

import 'package:SOSMAK/screens/medical_report/medicalreport.dart';
import 'package:SOSMAK/screens/incident_report/incidentReport.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './emergencyMap_screens/test2.dart';
import 'package:SOSMAK/screens/sos_screen/sosPage.dart';
import 'package:SOSMAK/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './wantedList_screens/wantedList.dart';
import 'admin/incidentReportsAdmin/incidentReportsAdmin.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isPolice = false;
  bool isAdmin = false;
  bool isCitizen = false;
  Size size;
  UserDetailsProvider userDetailsProvider;

  setViews() {
    if (userDetailsProvider.currentUser.role == 'police' ?? '') {
      isPolice = true;
    } else if (userDetailsProvider.currentUser.role == 'admin' ?? '') {
      isAdmin = true;
    } else if (userDetailsProvider.currentUser.role == 'citizen' ?? '') {
      isCitizen = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final firebaseUser = context.watch<User>();
    userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: FutureBuilder<DocumentSnapshot>(
          future: AuthenticationService.getCurrentUser(firebaseUser.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                //  print(snapshot.data);
                //set thing?
                userDetailsProvider.setCurrentUser(snapshot.data);
                setViews();
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // setViews(),
                      _buildTiles(),
                      // _buildButtons();
                      Align(
                        alignment: Alignment.center,
                        child: MaterialButton(
                            color: Colors.redAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              context.read<AuthenticationService>().signOut();
                            },
                            child: Text('Logout')),
                      ),
                    ],
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  _buildTiles() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
      child: Wrap(
        children: [
          _buildTile(
              color: Colors.white,
              text: 'Emergency HOTLINE',
              widget: SOSPage(),
              icon: Icons.call),
          _buildTile(
              color: Colors.white,
              text: 'Emergency Maps',
              icon: Icons.map,
              widget: MapView()),
          _buildTile(
              color: Colors.white,
              text: 'Medical Report',
              widget: MedicalReport(),
              icon: Icons.medical_services),
          _buildTile(
              color: Colors.white,
              text: 'Wanted List',
              icon: Icons.ten_mp,
              widget: WantedList()),
          Visibility(
            visible: isPolice,
            child: _buildTile(
              color: Colors.white,
              text: 'Officers Chat',
              icon: Icons.local_police,
              //widget: Chat()
              widget: ChatHome(),
            ),
          ),
          Visibility(
            visible: isCitizen,
            child: _buildTile(
                color: Colors.white,
                text: 'Incident Report',
                icon: Icons.warning_outlined,
                widget: IncidentReport()),
          ),
          Visibility(
            visible: isAdmin,
            child: _buildTile(
                color: Colors.white,
                text: 'Create Police Account',
                widget: CreatePoliceAccount(),
                icon: Icons.verified_user),
          ),
          Visibility(
            visible: isAdmin,
            child: _buildTile(
                color: Colors.white,
                text: 'Incident Report Admin',
                widget: IncidentReportAdmin(),
                icon: Icons.bar_chart_sharp),
          )
        ],
      ),
    );
  }

  _buildTile(
      {@required Color color,
      @required String text,
      @required IconData icon,
      Widget widget}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: InkWell(
          splashColor: Colors.blue,
          onTap: () {
            if (widget != null) {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return widget; //add widget here
              }));
            }
          },
          child: Container(
            width: size.width * .4,
            height: size.height * .2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 45,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
