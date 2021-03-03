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
  bool isApproved =false;
  String idURL ='';

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
      this.isApproved = doc.data()['isApproved']??isApproved;
      this.idURL = doc.data()['idURL']??this.idURL;
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
      'imageUrl':'https://firebasestorage.googleapis.com/v0/b/sosmak-82380.appspot.com/o/icons8-user-male-256.png?alt=media&token=43904dc7-93c7-44f2-a6ad-59438f1759b5',
      'tempPassword': this.tempPassword,
      'idURL':this.idURL,
      'currentIncidentRef': '',
      'isOnline': this.isOnline,
      'isApproved':this.isApproved
    };
  }
}
