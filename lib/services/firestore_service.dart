import 'package:SOSMAK/services/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import '../models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference courses =
      FirebaseFirestore.instance.collection('courses');
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

  Future<void> uploadFile(File file) async {
    // File file = File(filePath);
    DateTime date = DateTime.now();
    String fileName = date.toString();
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads/$fileName.png')
          .putFile(file)
          .then((val) async {
        String downUrl = await val.ref.getDownloadURL();
        print('upload complete' + downUrl);
        //update doc? or create?
      });
    } on FirebaseException catch (e) {
      print(e);
      // e.g, e.code == 'canceled'
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
