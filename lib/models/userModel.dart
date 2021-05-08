import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserModel {
  String firstName;
  String lastName;
  String email;
  String ref;
  String address;
  String role;
  String civilStatus;
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
  String schoolName = '';
  String idNumber = '';
  String language = '';
  String religion = '';
  String contactNo = '';
  String emergencycontactPerson1 = '';
  String emergencyRelation1 = '';
  String emergencyContactNo1 = '';
  String emergencycontactPerson2 = '';
  String emergencyRelation2 = '';
  String emergencyContactNo2 = '';
  String emergencycontactPerson3 = '';
  String emergencyRelation3 = '';
  String emergencyContactNo3 = '';
  bool isArchived = false;
  bool isTerminate = false;

  String tempPassword;
  final DateTime now = DateTime.now();
  UserModel.get(DocumentSnapshot doc) {
    try {
      this.firstName = doc.data()['firstName'];
      this.lastName = doc.data()['lastName'];
      this.email = doc.data()['email'];
      this.address = doc.data()['address'] ?? '';
      this.civilStatus = doc.data()['civilStatus'] ?? '';
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
      this.schoolName = doc.data()['schoolName'] ?? this.schoolName;
      this.idType = doc.data()['idType'] ?? this.idType;
      this.idNumber = doc.data()['idNumber'] ?? this.idNumber;
      this.language = doc.data()['language'] ?? this.language;
      this.religion = doc.data()['religion'] ?? this.religion;
      this.contactNo = doc.data()['contactNo'] ?? this.contactNo;
      this.emergencycontactPerson1 = doc.data()['emergencycontactPerson1'] ?? this.emergencycontactPerson1;
      this.emergencyRelation1 = doc.data()['emergencyRelation1'] ?? this.emergencyRelation1;
      this.emergencyContactNo1 = doc.data()['emergencyContactNo1'] ?? this.emergencyContactNo1;

      this.emergencycontactPerson2 = doc.data()['emergencycontactPerson2'] ?? this.emergencycontactPerson2;
      this.emergencyRelation2 = doc.data()['emergencyRelation2'] ?? this.emergencyRelation2;
      this.emergencyContactNo2 = doc.data()['emergencyContactNo2'] ?? this.emergencyContactNo2;

      this.emergencycontactPerson3 = doc.data()['emergencycontactPerson3'] ?? this.emergencycontactPerson3;
      this.emergencyRelation3 = doc.data()['emergencyRelation3'] ?? this.emergencyRelation3;
      this.emergencyContactNo3 = doc.data()['emergencyContactNo3'] ?? this.emergencyContactNo3;
      this.isArchived = doc.data()['isArchived'] ?? this.isArchived;
      this.isTerminate = doc.data()['isTerminate'] ?? this.isTerminate;
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
      'civilStatus': this.civilStatus,
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
      'schoolName': this.schoolName,
      'currentIncidentRef': '',
      'isOnline': this.isOnline,
      'isApproved': this.isApproved,
      'language': this.language,
      'religion': this.religion,
      'contactNo': this.contactNo,
      'emergencyContactNo1': this.emergencyContactNo1,
      'emergencycontactPerson1': this.emergencycontactPerson1,
      'emergencyRelation1': this.emergencyRelation1,
      'emergencyContactNo2': this.emergencyContactNo2,
      'emergencycontactPerson2': this.emergencycontactPerson2,
      'emergencyRelation2': this.emergencyRelation2,
      'emergencyContactNo3': this.emergencyContactNo3,
      'emergencycontactPerson3': this.emergencycontactPerson3,
      'emergencyRelation3': this.emergencyRelation3,
      'isArchived': this.isArchived,
      'isTerminate': this.isArchived
    };
  }
}
