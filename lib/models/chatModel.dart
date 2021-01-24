import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  DateTime date;
  String message;
  String senderRef;
  String imageUrl;
  List images;
  ChatModel.get(DocumentSnapshot doc) {
    //  this.date = doc.data()['date'] ?? '';
    this.message = doc.data()['message'] ?? '';
    this.senderRef = doc.data()['senderRef'] ?? '';
    this.images = doc.data()['images'] ?? [];

    this.imageUrl = doc.data()['imageUrl'];
  }
  ChatModel();
  toMap() {
    return {
      'date': this.date,
      'message': this.message,
      'senderRef': this.senderRef,
      'images': this.images,
      'imageUrl': this.imageUrl
    };
  }
}