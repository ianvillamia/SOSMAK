import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  static var policeCollection = FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'police')
      .snapshots();
}
