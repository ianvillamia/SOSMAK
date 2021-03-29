import 'package:cloud_firestore/cloud_firestore.dart';

class Wanted {
  String name;
  String alias;
  String reward;
  String criminalCaseNumber;
  String description;
  String lastKnownAddress;
  String contactHotline;
  int crimeLevel;
  String imageUrl;
  bool isHidden = false;
  Wanted.getData({DocumentSnapshot doc}) {
    this.name = doc.data()['name'];
    this.alias = doc.data()['alias'];
    this.reward = doc.data()['reward'];
    this.criminalCaseNumber = doc.data()['criminalCaseNumber'];
    this.description = doc.data()['description'];
    this.lastKnownAddress = doc.data()['lastKnownAddress'];
    this.contactHotline = doc.data()['contactHotline'];
    this.crimeLevel = doc.data()['crimeLevel'];
    this.imageUrl = doc.data()['imageUrl'];
    this.isHidden = doc.data()['isHidden'] ?? isHidden;
  }
  Wanted();
  toMap() {
    return {
      'name': this.name,
      'alias': this.alias,
      'reward': this.reward,
      'criminalCaseNumber': this.criminalCaseNumber,
      'description': this.description,
      'lastKnownAddress': this.lastKnownAddress,
      'contactHotline': this.contactHotline,
      'crimeLevel': this.crimeLevel,
      'imageUrl': this.imageUrl,
      'isHidden': this.isHidden
    };
  }
}
