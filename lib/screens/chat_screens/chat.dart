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
        child: Stack(
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
                      height: _image == null
                          ? size.height * .785
                          : size.height * .66,
                      padding: EdgeInsets.all(5),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: size.width,
                height: _image == null ? size.height * .09 : size.height * .22,
                color: Colors.white,
                child: Column(
                  children: [
                    _imagePreview(),
                    _buildTextFormField(controller: message),
                  ],
                ),
              ),
            )
          ],
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
          width: size.width * .25,
          padding: EdgeInsets.all(5),
          child: Image.file(
            _image,
            fit: BoxFit.cover,
            width: 75,
            height: 70,
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  _buildMessageBox(
      {@required Alignment alignment,
      @required ChatModel chat,
      @required bool withImage}) {
    if (withImage) {
      return Align(
        alignment: alignment,
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
        alignment: alignment,
        child: Card(
          elevation: 5,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    chat.message,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  _buildMessage(DocumentSnapshot doc) {
    // print(doc.data()['imageUrl']);
    ChatModel chat = ChatModel.get(doc);
    //if (chat.imageUrl != null) {
    if (chat.senderRef == firebaseUser.uid) {
      //ako nag send
      if (chat.imageUrl != null) {
        return _buildMessageBox(
            alignment: Alignment.centerRight, chat: chat, withImage: true);
      } else {
        return _buildMessageBox(
            alignment: Alignment.centerRight, chat: chat, withImage: false);
      }
    }
    //other sender
    else {
      if (chat.imageUrl != null) {
        return _buildMessageBox(
            alignment: Alignment.centerLeft, chat: chat, withImage: true);
      } else {
        return _buildMessageBox(
            alignment: Alignment.centerLeft, chat: chat, withImage: false);
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
      onTap: () {
        Future.delayed(Duration(milliseconds: 200), () {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 500),
              curve: Curves.ease);
        });
      },
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      obscureText: isPassword ?? false,
      decoration: InputDecoration(
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.photo,
                  color: Colors.blue,
                ),
                //onPressed: () {},
                onPressed: () => getImage(),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Colors.lightBlue),
                onPressed: () {
                  if (message.text != '') {
                    print(message.text);
                    ChatModel chat = ChatModel();
                    chat.date = DateTime.now();
                    chat.message = message.text;
                    chat.senderRef = firebaseUser.uid;
                    ChatService()
                        .sendMessage(
                            chatModel: chat,
                            chatID: widget.doc.id,
                            image: _image)
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
            ],
          ),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }
}
