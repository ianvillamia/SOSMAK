import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:SOSMAK/screens/admin/approve_account/approveAccount.dart';
import 'package:SOSMAK/screens/admin/create_police_account/policeAccounts.dart';
import 'package:SOSMAK/screens/chat_screens/chat_home.dart';
import 'package:SOSMAK/screens/incident_report/incidentReportv2.dart';
import 'package:SOSMAK/screens/medical_report/medicalreport.dart';
import 'package:SOSMAK/screens/profile/profile.dart';
import 'package:SOSMAK/screens/user_info/usersInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './emergencyMap_screens/test2.dart';
import 'package:SOSMAK/screens/sos_screen/sosPage.dart';
import 'package:SOSMAK/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './wantedList_screens/wantedList.dart';
import 'admin/incidentReportsAdmin/incidentReportsAdmin.dart';

import 'package:location/location.dart' as loc;

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
  String currentIncident;
  UserDetailsProvider userDetailsProvider;

  loc.Location location = loc.Location();
  bool _serviceEnabled;
  loc.LocationData _locationData;

  setViews() {
    if (userDetailsProvider.currentUser.role == 'police' ?? '') {
      isPolice = true;
    } else if (userDetailsProvider.currentUser.role == 'admin' ?? '') {
      isAdmin = true;
    } else if (userDetailsProvider.currentUser.role == 'citizen' ?? '') {
      isCitizen = true;
    }
    if (userDetailsProvider.currentUser.policeRank == 'Director General' ||
        userDetailsProvider.currentUser.policeRank ==
            'Deputy Director General' ||
        userDetailsProvider.currentUser.policeRank == 'Director') {
      isAdmin = true;
    }
  }

  checkerGPS() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      return showGPSAlertDialog();
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    checkerGPS();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final firebaseUser = context.watch<User>();
    userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'S.O.S MAK',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
                width: 30, height: 30, child: Image.asset('assets/notif.png'))
          ],
        )),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        //color: Color.fromRGBO(1, 60, 66,1),
        child: StreamBuilder<DocumentSnapshot>(
          // future: AuthenticationService.getCurrentUser(firebaseUser.uid),
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                UserModel user = UserModel.get(snapshot.data);

                currentIncident = snapshot.data.data()['currentIncidentRef'];

                userDetailsProvider.setCurrentUser(snapshot.data);
                setViews();
                if (user.isApproved == false) {
                  print('not yet approved');
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * .2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not yet approved wait for admin to verify your account',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: size.height * .03,
                        ),
                        MaterialButton(
                            color: Colors.redAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              context
                                  .read<AuthenticationService>()
                                  .signOut(uid: firebaseUser.uid);
                            },
                            child: Text('Logout')),
                      ],
                    ),
                  );
                } else {
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
                                context
                                    .read<AuthenticationService>()
                                    .signOut(uid: firebaseUser.uid);
                              },
                              child: Text('Logout')),
                        ),
                      ],
                    ),
                  );
                }
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
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
            isImageIcon: true,
            image: 'assets/hotline.png',
          ),
          _buildTile(
              color: Colors.white,
              text: 'Emergency Maps',
              image: 'assets/map.png',
              isImageIcon: true,
              widget: MapView()),
          Visibility(
            visible: isAdmin == true ? false : true,
            child: _buildTile(
                color: Colors.white,
                text: 'Profile',
                widget: MedicalReport(),
                isImageIcon: true,
                image: 'assets/user1.png'),
          ),
          _buildTile(
              color: Colors.white,
              text: 'Wanted List',
              isImageIcon: true,
              image: 'assets/wanted.png',
              widget: WantedList(
                isAdmin: isAdmin,
              )),
          Visibility(
            visible: isPolice,
            child: _buildTile(
              color: Colors.white,
              text: 'Officers Chat',
              //   icon: Icons.local_police,
              isImageIcon: true,
              image: 'assets/chat.jpg',
              //widget: Chat()
              widget: ChatHome(),
            ),
          ),
          Visibility(
            visible: isCitizen,
            child: _buildTile(
                color: Colors.white,
                text: 'Incident Report',
                isImageIcon: false,
                icon: Icons.warning_outlined,
                widget: IncidentReportV2(
                  userRef: userDetailsProvider.currentUser.ref,
                  currentIncidentDoc: this.currentIncident,
                )),
          ),
          Visibility(
            visible: isAdmin,
            child: _buildTile(
              color: Colors.white,
              text: 'Create Police Account',
              widget: CreatePoliceAccount(),
              isImageIcon: true,
              image: 'assets/adduser.png',
            ),
          ),
          Visibility(
            visible: isAdmin,
            child: _buildTile(
                color: Colors.white,
                text: 'Approve account',
                widget: ApproveAccount(),
                isImageIcon: true,
                image: 'assets/approve.jpg'),
          ),
          Visibility(
            visible: isAdmin,
            child: _buildTile(
              color: Colors.white,
              text: "Citizen's Info",
              widget: UsersInfo(),
              isImageIcon: true,
              image: 'assets/citizenInfo.png',
            ),
          ),
          Visibility(
            visible: isAdmin,
            child: _buildTile(
              color: Colors.white,
              text: 'Incident Report Admin',
              widget: IncidentReportAdmin(),
              isImageIcon: true,
              image: 'assets/incidentIcon.png',
            ),
          ),
        ],
      ),
    );
  }

  _buildTile(
      {@required Color color,
      @required String text,
      IconData icon,
      Widget widget,
      bool isImageIcon,
      String image}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: InkWell(
          splashColor: Colors.blue,
          onTap: () {
            if (widget != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return widget; //add widget here
                }),
              );
            }
          },
          child: Container(
            width: size.width * .4,
            height: size.height * .2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isImageIcon
                    ? Image.asset(
                        image,
                        width: 60,
                        height: 70,
                      )
                    : Icon(
                        icon,
                        size: 50,
                      ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    text,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showGPSAlertDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Reminder!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content:
              Text('Please open your GPS/Location to use our Map Feature.'),
          actions: [
            FlatButton(
              child: Text("Click to turn on"),
              onPressed: () async {
                Navigator.pop(context);
                _serviceEnabled = await location.serviceEnabled();
                if (!_serviceEnabled) {
                  _serviceEnabled = await location.requestService();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
