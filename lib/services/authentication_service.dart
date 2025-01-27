import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './firestore_service.dart';
import '../models/userModel.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();
  UserService _userService = UserService();

  Future signIn({String email, String password}) async {
    var isSuccessful;
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((cred) async {
        //get user if
        //update userstatus isOnline:true;
        await FirebaseFirestore.instance.collection('users').doc(cred.user.uid).update({'isOnline': true});
        isSuccessful = true;
      });
      return isSuccessful;
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }

  static Future<DocumentSnapshot> getCurrentUser(String uid) async {
    try {
      return await FirebaseFirestore.instance.collection('users').doc(uid).get();

      //set current user

    } catch (e) {
      debugPrint(e);
    }
  }

  Future signUp(
      {@required String email,
      @required String password,
      @required File fileID,
      @required File fileProfile,
      @required UserModel user}) async {
    try {
      var isSuccessful;

      uploadIDFile(fileID).then((idValue) async {
        String downIDUrl = await idValue.ref.getDownloadURL();
        user.idURL = downIDUrl;
        uploadProfileFile(fileProfile).then((profileValue) async {
          String downProfileUrl = await profileValue.ref.getDownloadURL();
          user.profileUrl = downProfileUrl;
          await _firebaseAuth
              .createUserWithEmailAndPassword(email: email.trim(), password: password.trim())
              .then((doc) async {
            isSuccessful = true;
            await _userService.addUserToCollection(user: user, uid: doc.user.uid);
          });
        });
      });

      return isSuccessful;
    } on FirebaseAuthException catch (e) {
      print(e);
      return e;
    }
  }

  Future uploadIDFile(File fileID) async {
    // File file = File(filePath);
    DateTime date = DateTime.now();
    String fileName = date.toString();

    return await firebase_storage.FirebaseStorage.instance.ref('uploads/ID/$fileName.png').putFile(fileID);
  }

  Future uploadProfileFile(File fileProfile) async {
    // File file = File(filePath);
    DateTime date = DateTime.now();
    String fileName = date.toString();

    return await firebase_storage.FirebaseStorage.instance
        .ref('uploads/profileImages/$fileName.png')
        .putFile(fileProfile);
  }

  Future<void> signOut({@required String uid}) async {
    await _firebaseAuth.signOut().then((value) async {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({'isOnline': false});
    });
  }

  Future<void> clearStatus({@required String uid}) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({'isOnline': false});
  }

  Future<void> passwordReset({@required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
