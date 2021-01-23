import 'package:cloud_firestore/cloud_firestore.dart';

class Wanted {
  String name;
  String alias;
  String reward;
  String criminalCaseNumber;
  String lastKnownAddress;
  String contactHotline;
  String imageUrl;
  Wanted.getData({DocumentSnapshot doc}) {
    this.name = doc.data()['name'];
    this.alias = doc.data()['alias'];
    this.reward = doc.data()['reward'];
    this.criminalCaseNumber = doc.data()['criminalCaseNumber'];
    this.lastKnownAddress = doc.data()['lastKnownAddress'];
    this.contactHotline = doc.data()['contactHotline'];
    this.imageUrl = doc.data()['imageUrl'];
  }
  Wanted();
  toMap() {
    return {
      'name': this.name,
      'alias': this.alias,
      'reward': this.reward,
      'criminalCaseNumber': this.criminalCaseNumber,
      'lastKnownAddress': this.lastKnownAddress,
      'contactHotline': this.contactHotline,
      'imageUrl': this.imageUrl
    };
  }
}
