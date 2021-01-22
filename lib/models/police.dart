import 'package:cloud_firestore/cloud_firestore.dart';

class Police {
  String firstName;
  String lastName;
  String address;
  String email;
  String imageUrl;
  String role;
  String tempPassword;
  String ref;

  Police.getData({DocumentSnapshot doc}) {
    this.firstName = doc.data()['firstName'];
    this.lastName = doc.data()['lastName'];
    this.address = doc.data()['address'];
    this.email = doc.data()['email'];
    this.role = doc.data()['role'];
    this.tempPassword = doc.data()['tempPassword'];
    this.imageUrl = doc.data()['imageUrl'];
    this.ref = doc.data()['ref'];
  }
}
