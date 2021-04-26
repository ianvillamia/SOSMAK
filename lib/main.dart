import 'dart:io';

import 'package:SOSMAK/models/globals.dart';
import 'package:SOSMAK/provider/dashboardProvider.dart';
import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:SOSMAK/screens/auth_screens/login.dart';
import 'package:SOSMAK/screens/home.dart';
import 'package:SOSMAK/services/authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DotEnv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(create: (context) => context.read<AuthenticationService>().authStateChanges),
        ChangeNotifierProvider<UserDetailsProvider>(create: (_) => UserDetailsProvider()),
        ChangeNotifierProvider<DashboardProvider>(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp(
        theme: new ThemeData(
            // scaffoldBackgroundColor: const Color.fromRGBO(1, 60, 66, 1),
            // textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
            inputDecorationTheme: InputDecorationTheme(fillColor: Colors.white)),
        debugShowCheckedModeBanner: false,
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key key}) : super(key: key);

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> with WidgetsBindingObserver {
  String uid = '';
  User fsUser;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    // _fcm.configure(onMessage: (Map<String, dynamic> message) async {
    //   print("onMessage: $message");

    //   final snackbar = SnackBar(
    //     content: Text(message['notification']['title']),
    //     action: SnackBarAction(
    //       label: 'Go',
    //       onPressed: () => null,
    //     ),
    //   );

    //   Scaffold.of(context).showSnackBar(snackbar);

    //   showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //             content: ListTile(
    //               title: Text(message['notification']['title']),
    //               subtitle: Text(message['notification']['body']),
    //             ),
    //             actions: [
    //               FlatButton(
    //                 onPressed: () => Navigator.of(context).pop,
    //                 child: Text('Ok'),
    //               )
    //             ],
    //           ));
    // });

    // _fcm.requestNotificationPermissions(
    //     const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false));

    WidgetsBinding.instance.addObserver(this);
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (fsUser != null) {
          await AuthenticationService(FirebaseAuth.instance).clearStatus(uid: Globals.uid);
        }

        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    //set current User here

    if (firebaseUser != null) {
      fsUser = firebaseUser;
      Globals.uid = firebaseUser.uid;
      _saveDeviceToken();
      return Home();
    }

    return Login();
  }

  Future<void> _saveDeviceToken() async {
    final firebaseUser = context.watch<User>();
    String uid = firebaseUser.uid;
    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      var tokenRef = users.doc(uid).collection('tokens').doc(fcmToken);

      await tokenRef
          .set({'token': fcmToken, 'createdAt': FieldValue.serverTimestamp(), 'platform': Platform.operatingSystem});
    }
  }
}

// life cycle handler
