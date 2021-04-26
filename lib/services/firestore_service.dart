import 'package:SOSMAK/models/dashboardModel.dart';
import 'package:SOSMAK/models/incidentmodel.dart';
import 'package:SOSMAK/models/police.dart';
import 'package:SOSMAK/models/wantedModel.dart';
import 'package:SOSMAK/services/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:io';
import '../models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference courses = FirebaseFirestore.instance.collection('courses');
  CollectionReference wantedList = FirebaseFirestore.instance.collection('wantedList');
  CollectionReference incidentReports = FirebaseFirestore.instance.collection('incidentReports');
  CollectionReference graph = FirebaseFirestore.instance.collection('graphData');
  addUserToCollection({UserModel user, String uid}) {
    user.ref = uid;
    this.users.doc(uid).set(user.toMap()).then((value) {});
  }

  Future addPoliceAccount({Police police}) async {
    try {
      var value;
      await this.users.limit(1).where('email', isEqualTo: police.email).get().then((QuerySnapshot snapshot) async {
        if (snapshot.size == 0) {
          print('all good to create');
          //
          String docID = Utils.getRandomString(29);
          police.ref = docID;
          await this.users.doc(police.ref).set(police.toMap()).then((value) {
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

  Future<void> updateMedical(DocumentSnapshot doc, String firstName, lastName, birthDate, birthPlace, bloodType,
      allergies, age, height, weight) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(doc.id)
        .update({
          'firstName': firstName,
          'lastName': lastName,
          'birthDate': birthDate,
          'birthPlace': birthPlace,
          'age': age,
          'height': height,
          'weight': weight,
          'bloodType': bloodType,
          'allergies': allergies
        })
        .then((value) => print("Lesson Updated"))
        .catchError((error) => print("Failed to update lesson: $error"));
  }

  Future addIncident(IncidentModel incident) async {
    String docRef;
    await incidentReports.add(incident.toMap()).then((value) async {
      await users.doc(incident.reporterRef).update({'currentIncidentRef': value.id});
      docRef = value.id;
    });
    return docRef;
  }

  Future uploadFile(File file) async {
    // File file = File(filePath);
    DateTime date = DateTime.now();
    String fileName = date.toString();

    return await firebase_storage.FirebaseStorage.instance.ref('uploads/wantedImages/$fileName.png').putFile(file);
  }

  Future uploadPostFile(File file) async {
    // File file = File(filePath);
    DateTime date = DateTime.now();
    String fileName = date.toString();

    return await firebase_storage.FirebaseStorage.instance.ref('uploads/postImages/$fileName.png').putFile(file);
  }

  Future addCriminalPoster({@required Wanted wanted, @required File file}) async {
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

  Future<void> deleteWanted(DocumentSnapshot doc, bool isHidden) {
    return wantedList
        .doc(doc.id)
        .update({
          'isHidden': isHidden,
        })
        .then((value) => print("Wanted Deleted"))
        .catchError((error) => print("Failed to delete wanted: $error"));
  }

  Future<DocumentSnapshot> getCurrentIncident(String docId) async {
    return await FirebaseFirestore.instance.collection('incidentReports').doc(docId).get();
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

  Future postIncident({@required IncidentModel incident, @required List<Asset> images}) async {
    var docRef;

    await incidentReports.add(incident.toMap()).then((value) async {
      docRef = value.id;
      await users.doc(incident.reporterRef).update({'currentIncidentRef': value.id});
    }).then((value) {
      //create doc
      List imageUrls = [];
      images.forEach((image) async {
        await postImage(image).then((downloadUrl) async {
          imageUrls.add(downloadUrl);
        });
        if (imageUrls.length == images.length) {
          //call firestore to
          await incidentReports.doc(docRef).update({'images': FieldValue.arrayUnion(imageUrls), 'updated': 'true'});
        }
      });
    });

    // await incidentReports.doc(docRef).update({'images': imageUrls});
    return docRef;
  }

  //single image only
  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference reference =
        firebase_storage.FirebaseStorage.instance.ref('uploads/incidentImages/$fileName');
    firebase_storage.UploadTask uploadTask = reference.putData((await imageFile.getByteData()).buffer.asUint8List());
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

  Future<void> updateIncident(
      DocumentSnapshot doc, String location, String date, String time, String incident, String desc) {
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

  Future addSpotWantedCriminal(
      {@required DocumentSnapshot doc, @required String userId, @required String name, @required String description}) {
    DateTime currentDate = DateTime.now();
    String currentTime = DateFormat('hh:mm a').format(DateTime.now());
    String spottedDate = currentDate.month.toString() +
        "/" +
        currentDate.day.toString() +
        "/" +
        currentDate.year.toString() +
        " - " +
        currentTime;
    return wantedList
        .doc(doc.id)
        .update({
          'izSpotted': true,
          "spottedUserRef": userId,
          "spottedCitizenName": name,
          "spottedDate": spottedDate,
          "spottedDescription": description,
        })
        .then((value) => print("Wanted Updated"))
        .catchError((error) => print("Failed to update wanted: $error"));
  }

  Future addGraphData({@required String id, @required int value}) async {
    await graph.doc(id).update({
      'value': value,
    });
  }
}
