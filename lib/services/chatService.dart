import 'package:SOSMAK/models/chatModel.dart';
import 'package:SOSMAK/models/conversation.dart';

import 'package:SOSMAK/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class ChatService {
  CollectionReference conversationCollection = FirebaseFirestore.instance.collection('conversation');
  Future setChat({String user1, String user2, String currentUser}) async {
    List users = [user2, user1];
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
        await conversationCollection
            .add({'users': users, 'user2HasNewMessage': false, 'user1HasNewMessage': false}).then((doc) async {
          conversation = await conversationCollection.doc(doc.id).get();
        });
      } else {
        //call here?
        //fetch conversation
        conversation = snapshot.docs[0];
        if (currentUser == conversation.data()['users'][0]) {
          await conversationCollection.doc(conversation.id).update({'user1HasNewMessage': false});
        } else {
          await conversationCollection.doc(conversation.id).update({'user2HasNewMessage': false});
        }

        print('Conversation Already Exists');
      }
    });

    return conversation;
  }

  Future checkChat({String user1, String user2, @required String currentUser}) async {
    List users = [user2, user1];
    users.sort();
    bool hasNewMessage;

    DocumentSnapshot conversation;
    await this
        .conversationCollection
        .limit(1)
        .where('users', isEqualTo: users)
        .get()
        .then((QuerySnapshot snapshot) async {
      if (snapshot.size == 0) {
        //create conversation

        hasNewMessage = false;
        // await conversationCollection
        //     .add({'users': users, 'user2HasNewMessage': false, 'user1HasNewMessage': false}).then((doc) async {
        //   conversation = await conversationCollection.doc(doc.id).get();
        // });
      } else {
        //call here?
        //fetch conversation
        conversation = snapshot.docs[0];
        Conversation c = Conversation.get(conversation);
        if (currentUser == conversation.data()['users'][0]) {
          if (c.user1HasNewMessage) {
            hasNewMessage = true;
          }
        } else {
          if (c.user2HasNewMessage) {
            hasNewMessage = true;
          }
        }
      }
    });

    return hasNewMessage;
  }

  Future sendMessage(
      {@required ChatModel chatModel, @required String chatID, @required bool isUser1, @required File image}) async {
    bool isSent;
    try {
      if (isUser1) {
        await conversationCollection.doc(chatID).update({'user2HasNewMessage': true});
      } else {
        await conversationCollection.doc(chatID).update({'user1HasNewMessage': true});
      }
      if (image != null) {
        await UserService().uploadFile(image).then((value) async {
          String downUrl = await value.ref.getDownloadURL();
          chatModel.imageUrl = downUrl;

          //    await conversationCollection.doc(chatID).update({'user2HasNewMessage': true});
          await conversationCollection.doc(chatID).collection('chats').add(chatModel.toMap()).then((value) {
            isSent = true;
          });
        });
      } else {
        await conversationCollection.doc(chatID).collection('chats').add(chatModel.toMap()).then((value) {
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
