import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserModel {
  String firstName;
  String lastName;
  String email;
  String ref;
  String address;
  String role;
  String currentIncidentRef;
  String birthDate;
  String birthPlace;
  String height, weight, age;
  String bloodType;
  String allergies;
  String policeRank;
  String stationAssigned;
  bool isOnline = false;
  String imageUrl = '';

  String tempPassword;
  final DateTime now = DateTime.now();
  UserModel.get(DocumentSnapshot doc) {
    try {
      this.firstName = doc.data()['firstName'];
      this.lastName = doc.data()['lastName'];
      this.email = doc.data()['email'];
      this.address = doc.data()['address'] ?? '';
      this.birthDate = doc.data()['birthDate'];
      this.birthPlace = doc.data()['birthPlace'] ?? '';
      this.height = doc.data()['height'] ?? '';
      this.weight = doc.data()['weight'] ?? '';
      this.age = doc.data()['age'] ?? '';
      this.bloodType = doc.data()['bloodType'] ?? '';
      this.allergies = doc.data()['allergies'] ?? '';
      this.ref = doc.data()['ref'] ?? '';
      this.role = doc.data()['role'] ?? 'citizen';
      this.currentIncidentRef = doc.data()['currentIncidentRef'];
      this.policeRank = doc.data()['policeRank'];
      this.stationAssigned = doc.data()['stationAssigned'];
      this.isOnline = doc.data()['isOnline'] ?? isOnline;
      this.imageUrl = doc.data()['imageUrl'] ?? imageUrl;
    } catch (e) {}
  }
  UserModel();
  toMap() {
    String formatted = DateFormat.yMMMd().format(now);
    return {
      'firstName': this.firstName,
      'lastName': this.lastName,
      'ref': this.ref,
      'email': this.email,
      'birthDate': formatted,
      'birthPlace': this.birthPlace,
      'height': this.height,
      'weight': this.weight,
      'age': this.age,
      'bloodType': this.bloodType,
      'allergies': this.allergies,
      'role': this.role,
      'address': this.address,
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/sosmak-82380.appspot.com/o/police.png?alt=media&token=998171c7-a096-4442-9908-15bf9047b977',
      'tempPassword': this.tempPassword,
      'currentIncidentRef': '',
      'isOnline': isOnline
    };
  }
}
