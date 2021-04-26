import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardModel {
  String valColor;
  int value;
  String valDescrition;

  DashboardModel.get(DocumentSnapshot doc) {
    this.valColor = doc.data()['valColor'] ?? '';
    this.value = doc.data()['value'] ?? '';
    this.valDescrition = doc.data()['valDescrition'] ?? '';
  }

  DashboardModel();
  toMap() {
    return {
      'valColor': this.valColor,
      'value': this.value,
      'valDescrition': this.valDescrition,
    };
  }
}
