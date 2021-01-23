import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:SOSMAK/screens/admin/create_police_account/createPoliceAccount.dart';
import 'package:SOSMAK/screens/chat_screens/chatList.dart';
import 'package:SOSMAK/screens/chat_screens/chat_home.dart';
import 'package:SOSMAK/screens/emergencyMap_screens/testgoogleplace.dart';
import 'package:SOSMAK/screens/medical_report/medicalReport2.dart';
import 'package:SOSMAK/screens/medical_report/medicalreport.dart';
import 'package:SOSMAK/screens/incident_report/incidentReport.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './emergencyMap_screens/test2.dart';
import 'package:SOSMAK/screens/sos_screen/sosPage.dart';
import 'package:SOSMAK/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './wantedList_screens/wantedList.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
        ),
      ),
    );
  }

  _buildTiles() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
      child: Wrap(
        children: [
          _buildTile(
              color: Colors.white,
              text: 'Emergency SOS',
              widget: SOSPage(),
              icon: Icons.notifications),
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
          _buildTile(
              color: Colors.white,
              text: 'Officers Chat',
              icon: Icons.local_police,
              //widget: Chat()
              widget: ChatHome()),
          _buildTile(
              color: Colors.white,
              text: 'Incident Report',
              icon: Icons.warning_outlined,
              widget: IncidentReport()),
          _buildTile(
              color: Colors.white,
              text: 'Create Police Account',
              widget: CreatePoliceAccount(),
              icon: Icons.verified_user),
          _buildTile(
              color: Colors.white,
              text: 'Incident Report Admin',
              icon: Icons.bar_chart_sharp),
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
