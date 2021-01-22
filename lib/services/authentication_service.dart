import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './firestore_service.dart';
import '../models/userModel.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();
  UserService _userService = UserService();

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        //get user if
      });
      return 'Signed in';
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message);
    }
  }

  static getCurrentUser(String uid, BuildContext context) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      //set current user
      final userDetailsProvider =
          Provider.of<UserDetailsProvider>(context, listen: false);
      userDetailsProvider.setCurrentUser(userDoc);
    } catch (e) {
      debugPrint(e);
    }
  }

  Future<String> signUp(
      {@required String email,
      @required String password,
      @required UserModel user}) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim())
          .then((doc) async {
        await _userService.addUserToCollection(user: user, uid: doc.user.uid);
      });

      return 'Signed Up';
    } on FirebaseAuthException catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> passwordReset({@required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
