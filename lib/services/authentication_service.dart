import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './firestore_service.dart';
import '../models/userModel.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();
  UserService _userService = UserService();

  Future signIn({String email, String password}) async {
    var isSuccessful;
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        //get user if
        isSuccessful = true;
      });
      return isSuccessful;
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }

  static Future<DocumentSnapshot> getCurrentUser(String uid) async {
    try {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      //set current user

    } catch (e) {
      debugPrint(e);
    }
  }

  Future signUp(
      {@required String email,
      @required String password,
      @required UserModel user}) async {
    try {
      var isSuccessful;
      await _firebaseAuth
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim())
          .then((doc) async {
        isSuccessful = true;
        await _userService.addUserToCollection(user: user, uid: doc.user.uid);
      });
      return isSuccessful;
    } on FirebaseAuthException catch (e) {
      print(e);
      return e;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> passwordReset({@required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
