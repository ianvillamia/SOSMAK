import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Police {
  String firstName = '';
  String lastName = '';
  String email = '';
  String imageUrl;
  String profileUrl;
  String gender = '';
  String address = '';
  String role = '';
  String birthDate = '';
  String birthPlace = '';
  String height = '', weight = '', age = '';
  String bloodType = '';
  String allergies = '';
  String policeRank = '';
  String badgeNumber = '';
  String stationAssigned = '';
  String tempPassword = '';
  String ref;
  bool isApproved = true;
  bool isArchived = false;

  final DateTime now = DateTime.now();

  Police.get({DocumentSnapshot doc}) {
    this.firstName = doc.data()['firstName'] ?? '';
    this.lastName = doc.data()['lastName'] ?? '';
    this.email = doc.data()['email'] ?? '';
    this.gender = doc.data()['gender'] ?? '';
    this.address = doc.data()['address'] ?? '';
    this.role = doc.data()['role'] ?? 'police';
    this.birthDate = doc.data()['birthDate'] ?? '';
    this.birthPlace = doc.data()['birthPlace'] ?? '';
    this.height = doc.data()['height'] ?? '';
    this.weight = doc.data()['weight'] ?? '';
    this.age = doc.data()['age'] ?? '';
    this.bloodType = doc.data()['bloodType'] ?? '';
    this.allergies = doc.data()['allergies'] ?? '';
    this.policeRank = doc.data()['policeRank'] ?? '';
    this.badgeNumber = doc.data()['badgeNumber'] ?? '';
    this.stationAssigned = doc.data()['stationAssigned'] ?? '';
    this.tempPassword = doc.data()['tempPassword'] ?? '';
    this.profileUrl = doc.data()['profileUrl'] ?? '';
    this.imageUrl = doc.data()['imageUrl'] ?? '';
    this.ref = doc.data()['ref'] ?? '';
    this.isApproved = doc.data()['isApproved'] ?? isApproved;
    this.isArchived = doc.data()['isArchived'] ?? isArchived;
  }
  Police();
  toMap() {
    String formatted = DateFormat.yMMMd().format(now);
    return {
      'firstName': this.firstName,
      'lastName': this.lastName,
      'ref': this.ref,
      'email': this.email,
      'role': this.role,
      'gender': this.gender,
      'address': this.address,
      'birthDate': formatted,
      'birthPlace': this.birthPlace,
      'height': this.height,
      'weight': this.weight,
      'age': this.age,
      'bloodType': this.bloodType,
      'allergies': this.allergies,
      'tempPassword': this.tempPassword,
      'profileUrl':
          'https://firebasestorage.googleapis.com/v0/b/sosmak-82380.appspot.com/o/police.png?alt=media&token=998171c7-a096-4442-9908-15bf9047b977',
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/sosmak-82380.appspot.com/o/police.png?alt=media&token=998171c7-a096-4442-9908-15bf9047b977',
      'policeRank': this.policeRank,
      'badgeNumber': this.badgeNumber,
      'stationAssigned': this.stationAssigned,
      'isApproved': this.isApproved,
      'isArchived': this.isArchived
    };
  }
}
