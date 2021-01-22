import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ChatService {
  CollectionReference chats =
      FirebaseFirestore.instance.collection('conversation');
  Future setChat({String user1, String user2}) async {
    List users = [user2, user1];
    var haveConversation;
    users.sort();
    var conversation;
    await this
        .chats
        .limit(1)
        .where('users', isEqualTo: users)
        .get()
        .then((QuerySnapshot snapshot) async {
      if (snapshot.size == 0) {
        //create conversation
        print('no doc with that');
        conversation = null;
      } else {
        //call here?
        //fetch conversation
        conversation = snapshot.docs[0];

        print('Conversation Already Exists');
        haveConversation = true;
      }
    });
    return conversation;
  }
}
