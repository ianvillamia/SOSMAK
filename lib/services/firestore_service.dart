import 'package:SOSMAK/models/wanted.dart';
import 'package:SOSMAK/services/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import '../models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference courses =
      FirebaseFirestore.instance.collection('courses');
  CollectionReference wantedList =
      FirebaseFirestore.instance.collection('wantedList');
  addUserToCollection({UserModel user, String uid}) {
    user.ref = uid;
    this.users.doc(uid).set(user.toMap()).then((value) {});
  }

  Future addPoliceAccount({UserModel user}) async {
    try {
      var value;
      await this
          .users
          .limit(1)
          .where('email', isEqualTo: user.email)
          .get()
          .then((QuerySnapshot snapshot) async {
        if (snapshot.size == 0) {
          print('all good to create');
          //
          String docID = Utils.getRandomString(29);
          user.ref = docID;
          await this.users.doc(user.ref).set(user.toMap()).then((value) {
            print('police added to collection');
          });
          value = true;
        } else {
          //call here?
          print('Account Already Exists');

          value = false;
        }
      });
      return value;
    } catch (e) {
      print('never reached');
      return Future.error(e);
    }
  }

  Future uploadFile(File file) async {
    // File file = File(filePath);
    DateTime date = DateTime.now();
    String fileName = date.toString();

    return await firebase_storage.FirebaseStorage.instance
        .ref('uploads/$fileName.png')
        .putFile(file);
  }

  Future addCriminalPoster(
      {@required Wanted wanted, @required File file}) async {
    //upload first
    bool added;
    try {
      if (file != null) {
        uploadFile(file).then((value) async {
          String downUrl = await value.ref.getDownloadURL();
          wanted.imageUrl = downUrl;
          await wantedList.add(wanted.toMap()).then((value) => added = true);
        });
      } else {
        wanted.imageUrl =
            'https://firebasestorage.googleapis.com/v0/b/sosmak-82380.appspot.com/o/190640.png?alt=media&token=479813fa-4c85-46ce-a3ef-675941f0119a';
        await wantedList.add(wanted.toMap()).then((value) => added = true);
      }

      return added;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void addCoursesToUser(uid) async {
    await FirebaseFirestore.instance.collection('courses').get().then((value) {
      value.docs.forEach((element) async {
        print(element.data());
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('courses')
            .doc(element.data()['ref'])
            .set(element.data());
      });
    });
  }

  void createPoliceAccount() {}

  getUser({User user}) async {
    await users.doc(user.uid).get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        return UserModel.get(doc);
      }
      // return UserModel.get(doc);
    });
  }
}
