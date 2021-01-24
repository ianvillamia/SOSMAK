import 'package:cloud_firestore/cloud_firestore.dart';

class IncidentModel {
  String location;
  String date;
  String incident;
  String desc;
  String imageUrl;
  int status;
  IncidentModel.get(DocumentSnapshot doc) {
    this.location = doc.data()['location'] ?? '';
    this.date = doc.data()['date'] ?? '';
    this.incident = doc.data()['incident'] ?? [];

    this.desc = doc.data()['desc'];
    this.imageUrl = doc.data()['imageUrl'];
    this.status = doc.data()['status'];
  }
  IncidentModel();
  toMap() {
    return {
      'location': this.location,
      'date': this.date,
      'incident': this.incident,
      'desc': this.desc,
      'imageUrl': this.imageUrl,
      'status':
          0 //status are 0=no action yet //1= onRoute police //2 = resolved
    };
  }
}
