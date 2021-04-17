import 'package:cloud_firestore/cloud_firestore.dart';

class CriminalInfoModel {
  String userRef;
  String citizenName;
  String date = DateTime.now().toString();
  String description;

  CriminalInfoModel.getData(data) {
    this.userRef = data['userRef'];
    this.citizenName = data['citizenName'];
    this.date = data['date'];
    this.description = data['description'];
  }
  CriminalInfoModel() {}
}
