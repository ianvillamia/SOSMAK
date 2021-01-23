import 'package:SOSMAK/models/chatModel.dart';
import 'package:SOSMAK/models/police.dart';
import 'package:SOSMAK/services/chatService.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Chat extends StatefulWidget {
  final DocumentSnapshot doc;
  final Police police;
  Chat({@required this.doc, @required this.police});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Size size;
  File _image;
  final picker = ImagePicker();
  User firebaseUser;
  List images;
  ScrollController _scrollController = ScrollController();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        debugPrint('hey');
        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  //image?;
  TextEditingController message = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    firebaseUser = context.watch<User>();
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.police.firstName + ' ' + widget.police.lastName),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.start,
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('conversation')
                      .doc(widget.doc.id)
                      .collection('chats')
                      .orderBy('date')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        width: size.width,
                        height: size.height * .77,
                        color: Colors.grey,
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Column(
                                  children: snapshot.data.docs
                                      .map<Widget>((doc) => _buildMessage(doc))
                                      .toList()),
                            ),
                          ),
                        ),
                      );
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),

              //textformfield
              images != null
                  ? Container(
                      color: Colors.amber,
                      width: size.width * .2,
                      height: size.height * .2,
                      child: Image.asset(images[0]),
                    )
                  : Container(
                      color: Colors.amber,
                    ),
              Container(
                  width: size.width,
                  child: Column(
                    children: [
                      _imagePreview(),
                      _buildTextFormField(controller: message),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  _buildImages(img) {
    return GestureDetector(
      onTap: () {
        showImage(context, img);
      },
      child: Container(
        width: size.width * .5,
        height: size.height * .2,
        child: Image.network(
          img,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  _imagePreview() {
    if (_image != null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          color: Colors.red,
          width: size.width * .15,
          child: Image.file(_image),
        ),
      );
    } else {
      return Container();
    }
  }

  _buildMessage(DocumentSnapshot doc) {
    // print(doc.data()['imageUrl']);
    ChatModel chat = ChatModel.get(doc);
    if (chat.imageUrl != null) {
      if (chat.senderRef == firebaseUser.uid) {
        return Align(
          alignment: Alignment.centerRight,
          child: Card(
            elevation: 5,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(chat.message),
                  ),
                  chat.imageUrl != null
                      ? _buildImages(chat.imageUrl.toString())
                      : Container(),
                ],
              ),
            ),
          ),
        );
      } else {
        return Align(
          alignment: Alignment.centerLeft,
          child: Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(chat.message),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      if (chat.senderRef == firebaseUser.uid) {
        return Align(
          alignment: Alignment.centerRight,
          child: Card(
            elevation: 5,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(chat.message),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return Align(
          alignment: Alignment.centerLeft,
          child: Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(chat.message),
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  showImage(BuildContext context, src) {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: Image.network(src),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _buildTextFormField(
      {TextEditingController controller, String label, bool isPassword}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ?? false,
      decoration: InputDecoration(
          suffix: IconButton(
            icon: Icon(
              Icons.photo,
              color: Colors.blue,
            ),
            //onPressed: () {},
            onPressed: () => getImage(),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              //
              //   print(images[0]);
              if (message.text != '') {
                print(message.text);
                ChatModel chat = ChatModel();
                chat.date = DateTime.now();
                chat.message = message.text;
                chat.senderRef = firebaseUser.uid;
                ChatService()
                    .sendMessage(
                        chatModel: chat, chatID: widget.doc.id, image: _image)
                    .then((value) {
                  _image = null;
                  message.clear();
                  _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease);
                  FocusScope.of(context).requestFocus(new FocusNode());
                });

                //create
              }
            },
          ),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }
}
