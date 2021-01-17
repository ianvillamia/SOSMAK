import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String firstName = '';
  String lastName = '';
  String email = '';
  String ref = '';
  String address = '';
  String role = '';

  UserModel.get(DocumentSnapshot doc) {
    this.firstName = doc.data()['firstName'] ?? '';
    this.lastName = doc.data()['lastName'] ?? '';
    this.email = doc.data()['email'] ?? '';
    this.ref = doc.data()['ref'] ?? '';
  }
  UserModel() {}
  toMap() {
    return {
      'firstName': this.firstName,
      'lastName': this.lastName,
      'ref': this.ref,
      'email': this.email,
      'role': this.role,
      'address': this.address
    };
  }
}
