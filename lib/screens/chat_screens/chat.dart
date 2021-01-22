import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final DocumentSnapshot doc;
  Chat({@required this.doc});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('hey'),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('conversation')
                      .doc('jSpFfl33LGIre8OQ7Drq')
                      .collection('chats')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        width: size.width,
                        height: size.height * .75,
                        color: Colors.red,
                        child: ListView(
                            children: snapshot.data.docs
                                .map<Widget>((doc) => Text(doc.id))
                                .toList()),
                      );
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),

              //textformfield
              Container(
                width: size.width,
                height: size.height * .1,
                child: Container(
                  width: size.width,
                  child: _buildTextFormField(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildTextFormField(
      {TextEditingController controller, String label, bool isPassword}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ?? false,
        decoration: InputDecoration(
            suffix: IconButton(
              icon: Icon(
                Icons.photo,
                color: Colors.blue,
              ),
              onPressed: () {},
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {},
            ),
            // suffixIcon: Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     IconButton(icon: Icon(Icons.photo), onPressed: () {}),
            //     IconButton(
            //       icon: Icon(Icons.send),
            //       onPressed: () {},
            //     ),
            //   ],
            // ),
            labelText: label,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }
}
