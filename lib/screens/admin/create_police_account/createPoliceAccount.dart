import 'package:SOSMAK/screens/admin/create_police_account/createAccount.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class CreatePoliceAccount extends StatefulWidget {
  CreatePoliceAccount({Key key}) : super(key: key);

  @override
  _CreatePoliceAccountState createState() => _CreatePoliceAccountState();
}

class _CreatePoliceAccountState extends State<CreatePoliceAccount> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Police Accounts'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateAccount()));
            // router.navigateTo(context, Routes.createAccount,
            //     transition: TransitionType.cupertino);
          },
          child: Icon(Icons.add),
        ),
        body: Container(
            width: size.width,
            height: size.height,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', isEqualTo: 'police')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.size > 0) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SingleChildScrollView(
                            child: Wrap(
                                children: snapshot.data.docs
                                    .map<Widget>((doc) => _userCards(doc))
                                    .toList()),
                          ),
                        ),
                      );
                    } else {
                      return Center(child: Text('No Police Registered yet'));
                    }
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                })));
  }

  _userCards(DocumentSnapshot doc) {
    return Card(
      child: Text(doc.id),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: Text("This is my message."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
