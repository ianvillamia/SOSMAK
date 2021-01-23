import 'package:SOSMAK/models/chatModel.dart';
import 'package:SOSMAK/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class ChatService {
  CollectionReference conversationCollection =
      FirebaseFirestore.instance.collection('conversation');
  Future setChat({String user1, String user2}) async {
    List users = [user2, user1];
    var haveConversation;
    users.sort();
    DocumentSnapshot conversation;
    await this
        .conversationCollection
        .limit(1)
        .where('users', isEqualTo: users)
        .get()
        .then((QuerySnapshot snapshot) async {
      if (snapshot.size == 0) {
        //create conversation
        print('no doc with that');
        await conversationCollection.add({'users': users}).then((doc) async {
          conversation = await conversationCollection.doc(doc.id).get();
        });
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

  Future sendMessage(
      {@required ChatModel chatModel,
      @required String chatID,
      @required File image}) async {
    bool isSent;
    try {
      if (image != null) {
        await UserService().uploadFile(image).then((value) async {
          String downUrl = await value.ref.getDownloadURL();
          chatModel.imageUrl = downUrl;
          await conversationCollection
              .doc(chatID)
              .collection('chats')
              .add(chatModel.toMap())
              .then((value) {
            isSent = true;
          });
        });
      } else {
        await conversationCollection
            .doc(chatID)
            .collection('chats')
            .add(chatModel.toMap())
            .then((value) {
          isSent = true;
        });
      }

      return isSent;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
