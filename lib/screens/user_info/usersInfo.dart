import 'package:SOSMAK/models/police.dart';
import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/screens/admin/create_police_account/createAccount.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class UsersInfo extends StatefulWidget {
  UsersInfo({@required this.userType});
  final String userType;

  @override
  _UsersInfoState createState() => _UsersInfoState();
}

class _UsersInfoState extends State<UsersInfo> {
  bool isAdmin;
  @override
  void initState() {
    super.initState();
  }

  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF93E9BE),
      appBar: AppBar(
        title: Text('Citizen Accounts'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => CreateAccount()));
      //   },
      //   child: Icon(Icons.add),
      // ),
      body: Container(
        width: size.width,
        height: size.height,
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('role', isEqualTo: widget.userType)
                .where('isArchived', isEqualTo: false)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.size > 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        child: Column(children: snapshot.data.docs.map<Widget>((doc) => _userCards(doc)).toList()),
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text('No citizen ' + widget.userType + ' yet'));
                }
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  _userCards(DocumentSnapshot doc) {
    UserModel user = UserModel.get(doc);
    return InkWell(
      child: Card(
          elevation: 2,
          child: ListTile(
            leading: Image.asset('assets/citizen.png'),
            title: Text("${user.firstName}, ${user.lastName}"),
            subtitle: Text(user.email),
          )),
      onTap: () {
        showAlertDialog(user, doc);
      },
    );
  }

  showAlertDialog(UserModel user, DocumentSnapshot doc) {
    UserModel userModel = UserModel.get(doc);
    AlertDialog alert = AlertDialog(
      title: Image.asset('assets/citizen.png', width: 100, height: 100),
      content: Container(
        height: size.height * .5,
        width: size.width * .7,
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildInfo('Name: ', '${user.firstName}, ${user.lastName}', false),
                buildInfo('Email: ', user.email, false),
                buildInfo('Address: ', user.address, false),
                buildInfo('Age: ', user.age, false),
                buildInfo('Birthdate: ', user.birthDate, false),
                buildInfo('BirthPlace: ', user.birthPlace, false),
                buildInfo('Height: ', user.height, false),
                buildInfo('Weight', user.weight, false),
                buildInfo('Blood Type: ', user.bloodType, false),
                SizedBox(height: size.height * 0.03),
              ],
            ),
          ),
        ),
      ),
      actions: [
        FlatButton(
          color: Colors.red,
          child: Text("Delete"),
          onPressed: () {
            //confirm delete
            confirmDelete(context, userModel);
          },
        ),
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  buildInfo(String name, String info, bool spaces) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: spaces ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
      children: [Text(name, style: TextStyle(fontWeight: FontWeight.bold)), Flexible(child: Text(info))],
    );
  }

  confirmDelete(BuildContext context, UserModel user) {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are You sure you want to delete this Police account?"),
      //content: Text(""),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          color: Colors.red,
          child: Text("Delete"),
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.ref)
                .update({'isArchived': true}).then((value) {
              //show delete success
              Navigator.pop(context);
              Navigator.pop(context);
              deleteSuccess(context);
            });
          },
        ),
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

  deleteSuccess(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Police successfully deleted"),
      // content: Text("This is my message."),
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
