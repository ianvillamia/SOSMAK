import 'package:SOSMAK/models/incidentmodel.dart';
import 'package:SOSMAK/models/wantedModel.dart';
import 'package:SOSMAK/services/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:multi_image_picker/src/asset.dart';
import '../models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference courses =
      FirebaseFirestore.instance.collection('courses');
  CollectionReference wantedList =
      FirebaseFirestore.instance.collection('wantedList');
  CollectionReference incidentReports =
      FirebaseFirestore.instance.collection('incidentReports');

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

  Future addIncident(IncidentModel incident) async {
    String docRef;
    await incidentReports.add(incident.toMap()).then((value) async {
      await users
          .doc(incident.reporterRef)
          .update({'currentIncidentRef': value.id});
      docRef = value.id;
    });
    return docRef;
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

  Future<DocumentSnapshot> getCurrentIncident(String docId) async {
    return await FirebaseFirestore.instance
        .collection('incidentReports')
        .doc(docId)
        .get();
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

  Future<List> getImageUrls(List<Asset> images) {
    List<String> imageUrls = [];
    images.map((image) async {
      String url = await postImage(image);
      print(url);
      imageUrls.add(url);
    });
    return Future.value(imageUrls);
  }

  Future postIncident(
      {@required IncidentModel incident, @required List<Asset> images}) async {
    List imageUrls = [];
    String docRef;

    images.forEach((image) async {
      await postImage(image).then((downloadUrl) async {
        //add to list
        imageUrls.add(downloadUrl);
        if (imageUrls.length == images.length) {
          // create docu?
          incident.imageUrls = imageUrls;
          await incidentReports.add(incident.toMap()).then((value) async {
            docRef = value.id;
            await users
                .doc(incident.reporterRef)
                .update({'currentIncidentRef': value.id});
          });
        }
      });
    });

    return docRef;
  }

  //single image only
  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference reference = firebase_storage
        .FirebaseStorage.instance
        .ref('uploads/incidentImages/$fileName');
    firebase_storage.UploadTask uploadTask =
        reference.putData((await imageFile.getByteData()).buffer.asUint8List());
    //TaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    print(imageUrl);
    return imageUrl;
  }

  void createPoliceAccount() {}

  getUser({User user}) async {
    await users.doc(user.uid).get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        return UserModel.get(doc);
      }
    });
  }

  Future<void> updateIncident(DocumentSnapshot doc, String location,
      String date, String time, String incident, String desc) {
    return incidentReports
        .doc(doc.id)
        .update({
          'location': location,
          'date': '$date, $time',
          'incident': incident,
          'desc': desc,
        })
        .then((value) => print("Incident Updated"))
        .catchError((error) => print("Failed to update incident: $error"));
  }
}
