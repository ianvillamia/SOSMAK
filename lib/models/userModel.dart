import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String firstName = '';
  String lastName = '';
  String email = '';
  String ref = '';
  String address = '';
  String role = '';

  String tempPassword = '';
  UserModel.get(DocumentSnapshot doc) {
    this.firstName = doc.data()['firstName'] ?? '';
    this.lastName = doc.data()['lastName'] ?? '';
    this.email = doc.data()['email'] ?? '';
    this.ref = doc.data()['ref'] ?? '';

    this.role = doc.data()['role'] ?? 'citizen';
  }
  UserModel();
  toMap() {
    return {
      'firstName': this.firstName,
      'lastName': this.lastName,
      'ref': this.ref,
      'email': this.email,
      'role': this.role,
      'address': this.address,
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/sosmak-82380.appspot.com/o/police.png?alt=media&token=998171c7-a096-4442-9908-15bf9047b977',
      'tempPassword': this.tempPassword,
    };
  }
}
