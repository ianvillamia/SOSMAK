import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Police {
  String firstName = '';
  String lastName = '';
  String email = '';
  String imageUrl;
  String role = '';
  String birthDate = '';
  String birthPlace = '';
  String height = '', weight = '', age = '';
  String bloodType = '';
  String allergies = '';
  String policeRank = '';
  String stationAssigned = '';
  String tempPassword = '';
  String ref;
  bool isHiv,
      isHeartDisease,
      isHighBlood,
      isLiverFunction,
      isMalaria,
      isTb,
      isTpaTest,
      isVDRLTest;

  final DateTime now = DateTime.now();

  Police.get({DocumentSnapshot doc}) {
    this.firstName = doc.data()['firstName'] ?? '';
    this.lastName = doc.data()['lastName'] ?? '';
    this.email = doc.data()['email'] ?? '';
    this.role = doc.data()['role'] ?? 'police';
    this.birthDate = doc.data()['birthDate'] ?? '';
    this.birthPlace = doc.data()['birthPlace'] ?? '';
    this.height = doc.data()['height'] ?? '';
    this.weight = doc.data()['weight'] ?? '';
    this.age = doc.data()['age'] ?? '';
    this.bloodType = doc.data()['bloodType'] ?? '';
    this.allergies = doc.data()['allergies'] ?? '';
    this.policeRank = doc.data()['policeRank'] ?? '';
    this.stationAssigned = doc.data()['stationAssigned'] ?? '';
    this.tempPassword = doc.data()['tempPassword'] ?? '';
    this.imageUrl = doc.data()['imageUrl'] ?? '';
    this.ref = doc.data()['ref'] ?? '';

    this.isHiv = doc.data()['isHiv'] ?? false;
    this.isTb = doc.data()['isTb'] ?? false;
    this.isHeartDisease = doc.data()['isHeartDisease'] ?? false;
    this.isHighBlood = doc.data()['isHighBlood'] ?? false;
    this.isMalaria = doc.data()['isMalaria'] ?? false;
    this.isLiverFunction = doc.data()['isLiverFunction'] ?? false;
    this.isVDRLTest = doc.data()['isVDRL'] ?? false;
    this.isTpaTest = doc.data()['isTPA'] ?? false;
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
      'birthDate': formatted,
      'birthPlace': this.birthPlace,
      'height': this.height,
      'weight': this.weight,
      'age': this.age,
      'bloodType': this.bloodType,
      'allergies': this.allergies,
      'tempPassword': this.tempPassword,
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/sosmak-82380.appspot.com/o/police.png?alt=media&token=998171c7-a096-4442-9908-15bf9047b977',
      'policeRank': this.policeRank,
      'stationAssigned': this.stationAssigned,
      'isHiv': isHiv,
      'isHeartDisease': isHeartDisease,
      'isHighBlood': isHighBlood,
      'isLiverFunction': isLiverFunction,
      'isMalaria': isMalaria,
      'isTb': isTb,
      'isTPA': isTpaTest,
      'isVDRL': isVDRLTest,
    };
  }
}
