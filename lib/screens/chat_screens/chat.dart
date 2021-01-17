import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  Chat({Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Size size;
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Kristaps Elsins'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   width: size.width,
            //   color: Colors.red,
            //   height: size.height * .9,
            // ),
            Container(
              width: size.width,
              height: size.height * .78,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('sampleChat')
                      .doc('2DP8dgwlqb9kz0Y4oU8m')
                      .collection('chats')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 35),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SingleChildScrollView(
                            child: Container(
                              width: size.width * .95,
                              height: size.height * .78,
                              child: Scrollbar(
                                child: Column(
                                    children: snapshot.data.docs
                                        .map<Widget>(
                                            (doc) => _buildMessage(doc))
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
            Card(
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
            )
          ],
        ),
      ),
    );
  }

  _buildMessage(DocumentSnapshot doc) {
    var id = doc.id;
    return Card(
      child: Text(doc.id),
    );
  }
}
