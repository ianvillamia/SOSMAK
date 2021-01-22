import 'package:SOSMAK/models/police.dart';
import 'package:SOSMAK/services/chatService.dart';
import 'package:SOSMAK/widgets/chatBottomNav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  ChatList({Key key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Size size;
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Start a Conversation'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', isEqualTo: 'police')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          child: Container(
                            width: size.width * .95,
                            height: size.height * .78,
                            child: Scrollbar(
                              child: Column(
                                  children: snapshot.data.docs
                                      .map<Widget>((doc) => _buildCard(doc))
                                      .toList()),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
          // Expanded(
          //   child: Container(
          //     color: Colors.red,
          //   ),
          // )
        ],
      ),
    );
  }

  _buildCard(DocumentSnapshot doc) {
    Police police = Police.getData(doc: doc);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Card(
          child: InkWell(
        onTap: () {},
        splashColor: Colors.blue,
        child: Row(
          children: [
            ClipOval(
              child: Container(
                  height: 80, width: 80, child: Image.network(police.imageUrl)),
            ),
            Text(police.firstName + " " + police.lastName)
          ],
        ),
      )),
    );
  }

  buildChatInput() {
    return Card(
      elevation: 5,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: size.width * .78,
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(50.0),
                      ),
                    )),
                  )),
              ClipOval(
                child: Material(
                  color: Colors.white,
                  child: Center(
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.lightBlue,
                        shape: CircleBorder(),
                      ),
                      child: ClipOval(
                        child: IconButton(
                          icon: Icon(Icons.send),
                          color: Colors.white,
                          onPressed: () {
                            //send message
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
