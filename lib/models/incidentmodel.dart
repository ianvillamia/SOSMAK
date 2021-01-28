import 'package:cloud_firestore/cloud_firestore.dart';

class IncidentModel {
  String location;
  String date;
  String incident;
  String desc;
  List imageUrls = [];
  int status;

  IncidentModel.get(DocumentSnapshot doc) {
    this.location = doc.data()['location'] ?? '';
    this.date = doc.data()['date'] ?? '';
    this.incident = doc.data()['incident'] ?? '';
    this.desc = doc.data()['desc'] ?? '';
    this.imageUrls = doc.data()['imageUrls'] ?? [];
    this.status = doc.data()['status'];
  }

  IncidentModel();
  toMap() {
    return {
      'location': this.location,
      'date': this.date,
      'incident': this.incident,
      'desc': this.desc,
      'images': this.imageUrls,
      'status': 0
    };
  }
}
