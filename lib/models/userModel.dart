import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String firstName = '';
  String lastName = '';
  String email = '';
  String ref = '';
  String address = '';
  String role;
  String currentIncidentRef = '';
  bool isHiv,
      isHeartDisease,
      isHighBlood,
      isLiverFunction,
      isMalaria,
      isTb,
      isTpaTest,
      isVDRLTest;

  String tempPassword = '';
  UserModel.get(DocumentSnapshot doc) {
    try {
      this.firstName = doc.data()['firstName'] ?? '';
      this.lastName = doc.data()['lastName'] ?? '';
      this.email = doc.data()['email'] ?? '';
      this.ref = doc.data()['ref'] ?? '';
      this.role = doc.data()['role'] ?? 'citizen';
      this.isHiv = doc.data()['isHiv'] ?? '';
      this.isTb = doc.data()['isTb'] ?? '';
      this.isHeartDisease = doc.data()['isHeartDisease'] ?? false;
      this.isHighBlood = doc.data()['isHighBlood'] ?? false;
      this.isMalaria = doc.data()['isMalaria'] ?? false;
      this.isLiverFunction = doc.data()['isLiverFunction'] ?? false;
      this.isVDRLTest = doc.data()['isVDRL'] ?? false;
      this.isTpaTest = doc.data()['isTPA'] ?? false;
      this.currentIncidentRef = doc.data()['currentIncidentRef'] ?? '';
    } catch (e) {}
  }
  UserModel();
  toMap() {
    return {
      'firstName': this.firstName,
      'lastName': this.lastName,
      'ref': this.ref,
      'email': this.email,
      'role': this.role,
      'address': this.address,
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/sosmak-82380.appspot.com/o/police.png?alt=media&token=998171c7-a096-4442-9908-15bf9047b977',
      'isHiv': isHiv,
      'isHearDisease': isHeartDisease,
      'isHighBlood': isHighBlood,
      'isLiverFunction': isLiverFunction,
      'isMalaria': isMalaria,
      'isTb': isTb,
      'isTPA': isTpaTest,
      'isVDRL': isVDRLTest,
      'currentIncidentRef': ''
    };
  }
}

// import 'package:SOSMAK/models/medicalmodel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class UserModel {
//   String firstName = '';
//   String lastName = '';
//   String email = '';
//   String ref = '';
//   String address = '';
//   String role = '';
//   String tempPassword = '';
//   List<MedicalReportModel> medicalReport = [];

//   UserModel.getData(DocumentSnapshot doc) {
//     this.firstName = doc.data()['firstName'] ?? '';
//     this.lastName = doc.data()['lastName'] ?? '';
//     this.email = doc.data()['email'] ?? '';
//     this.address = doc.data()['addres'] ?? '';
//     this.ref = doc.data()['ref'] ?? '';
//     this.role = doc.data()['role'] ?? 'citizen';
//     for (var item in doc.data()['medicalReport']) {
//       // this.lessons.add(lesson);
//       MedicalReportModel mr = MedicalReportModel.getData(item);
//       //print(less.runtimeType);
//       medicalReport.add(mr);
//     }
//   }
//   UserModel() {}
//   static toMap({@required UserModel userModel}) {
//     List medicalReport = [];
//     userModel.medicalReport.forEach((medical) {
//       var m = MedicalReportModel().toMap(medical: medical);
//       medicalReport.add(m);
//     });

//     var user = {
//       'firstName': userModel.firstName,
//       'lastName': userModel.lastName,
//       'ref': userModel.ref,
//       'email': userModel.email,
//       'role': userModel.role,
//       'address': userModel.address,
//       'imageUrl':
//           'https://firebasestorage.googleapis.com/v0/b/sosmak-82380.appspot.com/o/police.png?alt=media&token=998171c7-a096-4442-9908-15bf9047b977',
//       'tempPassword': userModel.tempPassword,
//       'medicalReport': userModel.medicalReport
//     };

//     return user;
//   }
// }
