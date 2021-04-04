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
  String gender;
  String height, weight, age;
  String bloodType;
  String allergies;
  String policeRank;
  String stationAssigned;
  bool isOnline = false;
  String imageUrl = '';
  bool isApproved = false;
  String profileUrl = '';
  String idURL = '';
  String idType = '';
  String idNumber = '';
  String language = '';
  String religion = '';
  String contactNo = '';
  String emergencyContact = '';
  String contactPerson = '';
  String otherMedicalCondition1 = '';
  String otherMedicalCondition2 = '';
  String otherMedicalCondition3 = '';
  String otherMedicalCondition4 = '';
  String otherMedicalCondition5 = '';
  bool isArchived = false;

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
      this.gender = doc.data()['gender'] ?? '';
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
      this.isApproved = doc.data()['isApproved'] ?? isApproved;
      this.profileUrl = doc.data()['profileUrl'] ?? this.profileUrl;
      this.idURL = doc.data()['idURL'] ?? this.idURL;
      this.idType = doc.data()['idType'] ?? this.idType;
      this.idNumber = doc.data()['idNumber'] ?? this.idNumber;
      this.language = doc.data()['language'] ?? this.language;
      this.religion = doc.data()['religion'] ?? this.religion;
      this.contactNo = doc.data()['contactNo'] ?? this.contactNo;
      this.emergencyContact = doc.data()['emergencyContact'] ?? this.emergencyContact;
      this.contactPerson = doc.data()['contactPerson'] ?? this.contactPerson;
      this.otherMedicalCondition1 = doc.data()['otherMedicalCondition1'] ?? this.otherMedicalCondition1;
      this.otherMedicalCondition2 = doc.data()['otherMedicalCondition2'] ?? this.otherMedicalCondition2;
      this.otherMedicalCondition3 = doc.data()['otherMedicalCondition3'] ?? this.otherMedicalCondition3;
      this.otherMedicalCondition4 = doc.data()['otherMedicalCondition4'] ?? this.otherMedicalCondition4;
      this.otherMedicalCondition5 = doc.data()['otherMedicalCondition5'] ?? this.otherMedicalCondition5;
      this.isArchived = doc.data()['isArchived'] ?? this.isArchived;
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
      'gender': this.gender,
      'height': this.height,
      'weight': this.weight,
      'age': this.age,
      'bloodType': this.bloodType,
      'allergies': this.allergies,
      'role': this.role,
      'address': this.address,
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/sosmak-82380.appspot.com/o/icons8-user-male-256.png?alt=media&token=43904dc7-93c7-44f2-a6ad-59438f1759b5',
      'tempPassword': this.tempPassword,
      'profileUrl': this.profileUrl,
      'idURL': this.idURL,
      'idType': this.idType,
      'idNumber': this.idNumber,
      'currentIncidentRef': '',
      'isOnline': this.isOnline,
      'isApproved': this.isApproved,
      'language': this.language,
      'religion': this.religion,
      'contactNo': this.contactNo,
      'emergencyContact': this.emergencyContact,
      'contactPerson': this.contactPerson,
      'isArchived': this.isArchived
    };
  }
}
