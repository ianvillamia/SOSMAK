import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyModel {
  String name;
  String subtitle;
  String mobileNo;
  String telNo;
  String category;

  EmergencyModel.get(DocumentSnapshot doc) {
    this.name = doc.data()['name'] ?? '';
    this.subtitle = doc.data()['subtitle'] ?? '';
    this.mobileNo = doc.data()['mobileNo'] ?? '';
    this.telNo = doc.data()['telNo'] ?? '';
    this.category = doc.data()['category'] ?? '';
  }
}
