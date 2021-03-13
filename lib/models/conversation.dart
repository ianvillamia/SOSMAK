import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  List users = [];
  bool user1HasNewMessage = false;
  bool user2HasNewMessage = false;
  Conversation.get(DocumentSnapshot doc) {
    users = doc.data()['users'] ?? [];
    user1HasNewMessage = doc.data()['user1HasNewMessage'] ?? false;
    user2HasNewMessage = doc.data()['user2HasNewMessage'] ?? false;
  }
}
