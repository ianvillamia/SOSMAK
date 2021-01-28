import 'package:cloud_firestore/cloud_firestore.dart';

class IncidentModel {
  String location;
  String date;
  String incident;
  String desc;
  List imageUrls = [];
  int status;
  String reporterRef;

  IncidentModel.get(DocumentSnapshot doc) {
    this.location = doc.data()['location'] ?? '';
    this.date = doc.data()['date'] ?? '';
    this.incident = doc.data()['incident'] ?? '';
    this.desc = doc.data()['desc'] ?? '';
    this.imageUrls = doc.data()['imageUrls'] ?? [];
    this.status = doc.data()['status'];
    this.reporterRef = doc.data()['reporterRef'] ?? '';
  }

  IncidentModel();
  toMap() {
    return {
      'reporterRef': this.reporterRef,
      'location': this.location,
      'date': this.date,
      'incident': this.incident,
      'desc': this.desc,
      'images': this.imageUrls,
      'status': 0 //0 1 2
    };
  }
}
