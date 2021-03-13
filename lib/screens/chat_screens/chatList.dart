import 'package:SOSMAK/models/conversation.dart';
import 'package:SOSMAK/models/police.dart';
import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:SOSMAK/screens/chat_screens/chat.dart';
import 'package:SOSMAK/services/chatService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  ChatList({Key key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Size size;
  UserDetailsProvider _currentUser;
  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<UserDetailsProvider>(context, listen: false);
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
                stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'police').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        width: size.width,
                        height: size.height,
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            child: Column(children: snapshot.data.docs.map<Widget>((doc) => _buildCard(doc)).toList()),
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
        ],
      ),
    );
  }

  _buildCard(DocumentSnapshot doc) {
    UserModel police = UserModel.get(doc);
    bool hasNewMessage = false;

    if (_currentUser.currentUser.ref != police.ref) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Card(
            child: InkWell(
          onTap: () async {
            // debugPrint(police.ref + '* ' + _currentUser.currentUser.ref);
            await ChatService()
                .setChat(
                    user1: police.ref, user2: _currentUser.currentUser.ref, currentUser: _currentUser.currentUser.ref)
                .then((doc) {
              if (doc != null) {
                //push conversation
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chat(
                      doc: doc,
                      police: police,
                    ),
                  ),
                );
              }
            });
          },
          splashColor: Colors.blue,
          child: Row(
            children: [
              police.isOnline
                  ? ClipOval(
                      child: Container(
                        width: 20,
                        height: 20,
                        color: Colors.green,
                      ),
                    )
                  : ClipOval(
                      child: Container(
                        width: 20,
                        height: 20,
                        color: Colors.grey,
                      ),
                    ),
                    RedButton(
                police: police,
                currentUser: _currentUser,
              ),
              SizedBox(
                width: 20,
              ),
              ClipOval(
                child: Container(height: 80, width: 80, child: Image.network(police.imageUrl)),
              ),
              Text(
                police.firstName + " " + police.lastName,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
             
              
            ],
          ),
        )),
      );
    } else {
      return Container();
    }
  }

  buildChatInput() {
    return Card(
      elevation: 5,
      child: Container(
        color: Colors.white,
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
    );
  }
}

class RedButton extends StatefulWidget {
  final UserModel police;
  final UserDetailsProvider currentUser;
  RedButton({@required this.police, @required this.currentUser});

  @override
  _RedButtonState createState() => _RedButtonState();
}

class _RedButtonState extends State<RedButton> {
  bool hasRead =false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkChat(widget.police),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
       
        if (snapshot.hasData) {
          if (snapshot.data == true && hasRead == false) {
            return ClipOval(
              child: Container(
                width: 20,
                height: 20,
                child: Icon(CupertinoIcons.bell_fill,color: Colors.red,),
              ),
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Future checkChat(UserModel police) async {
    bool hasNewMessage = false;
    await ChatService().checkChat(user1: police.ref, user2: widget.currentUser.currentUser.ref).then((val) {
      if (val == true) {
        print('hotdog');
        hasNewMessage = true;
      }
    });
    return hasNewMessage;
  }
}
