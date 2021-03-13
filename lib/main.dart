import 'package:SOSMAK/models/globals.dart';
import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:SOSMAK/screens/auth_screens/login.dart';
import 'package:SOSMAK/screens/home.dart';
import 'package:SOSMAK/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

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
          await AuthenticationService(FirebaseAuth.instance).signOut(uid: Globals.uid);
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
      return Home();
    }

    return Login();
  }
}

// life cycle handler
