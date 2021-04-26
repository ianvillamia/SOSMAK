import 'dart:io';

import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:SOSMAK/screens/admin/approve_account/approveAccount.dart';
import 'package:SOSMAK/screens/admin/create_police_account/policeAccounts.dart';
import 'package:SOSMAK/screens/admin/dashboard/dashboard.dart';
import 'package:SOSMAK/screens/chat_screens/chat_home.dart';
import 'package:SOSMAK/screens/incident_report/incidentReportv2.dart';
import 'package:SOSMAK/screens/user_profile/userProfile.dart';
import 'package:SOSMAK/screens/profile/profile.dart';
import 'package:SOSMAK/screens/user_info/usersInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import './emergencyMap_screens/test2.dart';
import 'package:SOSMAK/screens/sos_screen/sosPage.dart';
import 'package:SOSMAK/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './wantedList_screens/wantedList.dart';
import 'admin/incidentReportsAdmin/incidentReportsAdmin.dart';
import 'package:SOSMAK/screens/user_info/testSMS.dart';

import 'package:location/location.dart' as loc;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isPolice = false;
  bool isAdmin = false;
  bool isCitizen = false;
  bool enableAdditionalCard = false;
  Size size;
  String currentIncident;
  String number;
  UserDetailsProvider userDetailsProvider;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final users = FirebaseFirestore.instance.collection('users');
  TextEditingController locationController = TextEditingController();
  loc.Location location = loc.Location();
  bool _serviceEnabled;
  loc.LocationData _locationData;

  TwilioFlutter twilioFlutter;

  String accountSid = DotEnv.env['ACCOUNT_SID'];
  String authToken = DotEnv.env['AUTH_TOKEN'];
  String twilioNumber = DotEnv.env['TWILIO_NUMBER'];

  setViews() {
    if (userDetailsProvider.currentUser.role == 'police' ?? '') {
      isPolice = true;
      enableAdditionalCard = true;
    } else if (userDetailsProvider.currentUser.role == 'admin' ?? '') {
      isAdmin = true;
    } else if (userDetailsProvider.currentUser.role == 'citizen' ?? '') {
      isCitizen = true;
      number = userDetailsProvider.currentUser.emergencyContactNo;
    }
    if (userDetailsProvider.currentUser.policeRank == 'Director General' ||
        userDetailsProvider.currentUser.policeRank == 'Deputy Director General' ||
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

  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;
  String _location;
  String _addressLine;
  bool done = false;

  Future<void> _getLocation(Position position) async {
    debugPrint('location: ${position.latitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    Address first = addresses.first;
    _location = "${first.featureName}";
    _addressLine = " ${first.addressLine}";
    setState(() {
      done = true;
    });
  }

  void _getCurrentLocation() {
    _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) {
      _getLocation(position);
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentLocation();

    checkerGPS();
    twilioFlutter = TwilioFlutter(
      accountSid: '$accountSid',
      authToken: '$authToken',
      twilioNumber: '$twilioNumber',
    );
    // if (Platform.isIOS) {
    //   _fcm.requestNotificationPermissions(IosNotificationSettings());
    // }

    // _fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     _serialiseAndNavigate(message);
    //     print("onMessage: $message");
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     _serialiseAndNavigate(message);
    //     print("onLaunch: $message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     _serialiseAndNavigate(message);
    //     print("onResume: $message");
    //   },
    // );

    // _fcm.requestNotificationPermissions(
    //     const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false));
    // _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });

    // _fcm.getToken().then((String token) {
    //   assert(token != null);
    //   setState(() {
    //     print("Push Messaging token: $token");
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final firebaseUser = context.watch<User>();
    userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);
    locationController =
        TextEditingController(text: done == false ? "Click the icon to get My Current Location" : "$_addressLine");
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
            Container(width: 30, height: 30, child: Image.asset('assets/notif.png'))
          ],
        )),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        //color: Color.fromRGBO(1, 60, 66,1),
        child: StreamBuilder<DocumentSnapshot>(
          // future: AuthenticationService.getCurrentUser(firebaseUser.uid),
          stream: FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                UserModel user = UserModel.get(snapshot.data);

                currentIncident = snapshot.data.data()['currentIncidentRef'] ?? '';

                userDetailsProvider.setCurrentUser(snapshot.data);
                setViews();
                if (user.isApproved == false && user.isTerminate == false) {
                  print('not yet approved');
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * .2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not yet approved, wait for the admin to verify your account',
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
                              context.read<AuthenticationService>().signOut(uid: firebaseUser.uid);
                            },
                            child: Text('Logout')),
                      ],
                    ),
                  );
                } else if (user.isArchived) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * .2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'This Account has been Disabled please contact the admin',
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
                              context.read<AuthenticationService>().signOut(uid: firebaseUser.uid);
                            },
                            child: Text('Logout')),
                      ],
                    ),
                  );
                } else if (user.isTerminate) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * .2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'This Account has been DISAPPROVED, please contact the admin',
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
                              context.read<AuthenticationService>().signOut(uid: firebaseUser.uid);
                            },
                            child: Text('Logout')),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    color: Color(0xFF93E9BE),
                    child: SingleChildScrollView(
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
                                  context.read<AuthenticationService>().signOut(uid: firebaseUser.uid);
                                },
                                child: Text('Logout')),
                          ),
                        ],
                      ),
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
                text: 'User Profile',
                widget: UserProfile(),
                isImageIcon: true,
                image: 'assets/icon-user-profile.png'),
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
            visible: isCitizen,
            child: _buildSOSButton(emergencyContact: number, context: context),
          ),
          Visibility(
            visible: isAdmin,
            child: _buildTile(
              color: Colors.white,
              text: 'Manage Police Account',
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
              widget: UsersInfo(
                userType: 'citizen',
              ),
              isImageIcon: true,
              image: 'assets/citizenInfo.png',
            ),
          ),
          Visibility(
            visible: enableAdditionalCard,
            child: _buildTile(
              color: Colors.white,
              text: 'Incident Report (Processing and Monitoring)',
              widget: IncidentReportAdmin(),
              isImageIcon: true,
              image: 'assets/incidentIcon.png',
            ),
          ),
          Visibility(
            visible: isAdmin,
            child: _buildTile(
              color: Colors.white,
              text: 'Incident Report (Processing and Monitoring)',
              widget: IncidentReportAdmin(),
              isImageIcon: true,
              image: 'assets/incidentIcon.png',
            ),
          ),
          Visibility(
            visible: isAdmin,
            child: _buildTile(
              color: Colors.white,
              text: 'Dashboard',
              widget: DashBoard(),
              isImageIcon: true,
              image: 'assets/sosmakLogo.png',
            ),
          ),
        ],
      ),
    );
  }

  _buildTile(
      {@required Color color, @required String text, IconData icon, Widget widget, bool isImageIcon, String image}) {
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
            height: size.height * .24,
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

  void sendSms() async {
    if (locationController.text == "Click the icon to get My Current Location") {
      showNoLocation();
    } else {
      twilioFlutter.sendSMS(
        toNumber: '+639562354758',
        messageBody: "MY LOCATION: \n${locationController.text}\n\nHELP ME! I'M IN TROUBLE, SEND SOME AUTHORITIES",
      );
      locationController.text = '';
      Navigator.pop(context);
    }
  }

  _buildSOSButton({@required String emergencyContact, BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: size.width * .4,
        height: size.height * .22,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                //sendSms
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Send your Location!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Container(
                            child: TextFormField(
                              controller: locationController,
                              decoration: InputDecoration(
                                labelText: 'Location',
                                suffixIcon: IconButton(
                                    onPressed: () async {
                                      _serviceEnabled = await location.serviceEnabled();
                                      if (!_serviceEnabled) {
                                        _serviceEnabled = await location.requestService();
                                      }

                                      Navigator.pop(context);
                                      _getCurrentLocation();
                                    },
                                    icon: Icon(Icons.location_on_outlined)),
                              ),
                            ),
                          );
                        },
                      ),
                      actions: [
                        FlatButton(
                          child: Text("Send"),
                          onPressed: sendSms,
                        ),
                      ],
                    );
                  },
                );
              },
              child: ClipOval(
                child: Container(
                  width: 150,
                  height: 150,
                  child: Image.asset(
                    'assets/sosmakLogo.png',
                    fit: BoxFit.cover,
                    width: 130,
                    height: 130,
                  ),
                ),
              ),
            ),
          ],
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
          content: Text('Please open your GPS/Location to use our Map Feature.'),
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

  void _serialiseAndNavigate(Map<String, dynamic> message) {
    var notificationData = message['data'];
    var view = notificationData['view'];

    if (view != null) {
      if (view == 'user_profile') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfile()),
        );
      }
    }
  }

  showNoLocation() {
    AlertDialog alert = AlertDialog(
      title: Text(
        "Error",
        style: TextStyle(
          fontWeight: FontWeight.w800,
        ),
      ),
      content: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w300,
            color: Colors.black,
            height: 1.5,
          ),
          children: [
            TextSpan(
              text: 'No location found. \n',
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            TextSpan(
              text: 'Click the',
            ),
            WidgetSpan(
              child: Icon(Icons.location_on_outlined),
            ),
            TextSpan(
              text: 'to get My Current Location',
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Future<void> _saveDeviceToken() async {
  //   final firebaseUser = context.watch<User>();
  //   String uid = firebaseUser.uid;
  //   String fcmToken = await _fcm.getToken();

  //   if (fcmToken != null) {
  //     var tokenRef = users.doc(uid).collection('tokens').doc(fcmToken);

  //     await tokenRef
  //         .set({'token': fcmToken, 'createdAt': FieldValue.serverTimestamp(), 'platform': Platform.operatingSystem});
  //   }
  // }
}
