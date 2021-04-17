import 'package:SOSMAK/models/criminalModel.dart';
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
  List<CriminalInfoModel> spotCriminalInfo = [];
  String spottedUserRef;
  String spottedCitizenName;
  String spottedDescription;
  String spottedDate;
  bool izSpotted = false;
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
    this.izSpotted = doc.data()['izSpotted'] ?? izSpotted;
    this.spotCriminalInfo = doc.data()['spotCriminalInfo'];
    this.spottedUserRef = doc.data()['spottedUserRef'];
    this.spottedCitizenName = doc.data()['spottedCitizenName'];
    this.spottedDescription = doc.data()['spottedDescription'];
    this.spottedDate = doc.data()['spottedDate'];
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
      'isHidden': this.isHidden,
      'izSpotted': this.izSpotted,
      'spotCriminalInfo': this.spotCriminalInfo,
      'spottedUserRef': this.spottedUserRef,
      'spottedCitizenName': this.spottedCitizenName,
      'spottedDescription': this.spottedDescription,
      'spottedDate': this.spottedDate
    };
  }
}
