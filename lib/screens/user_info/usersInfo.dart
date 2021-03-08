import 'package:SOSMAK/models/police.dart';
import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/screens/admin/create_police_account/createAccount.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class UsersInfo extends StatefulWidget {
  UsersInfo({Key key}) : super(key: key);

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
                    .where('role', isEqualTo: 'citizen')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.size > 0) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SingleChildScrollView(
                            child: Column(
                                children: snapshot.data.docs
                                    .map<Widget>((doc) => _userCards(doc))
                                    .toList()),
                          ),
                        ),
                      );
                    } else {
                      return Center(child: Text('No citizen registered yet'));
                    }
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                })));
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
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Image.asset('assets/citizen.png', width: 100, height: 100),
      content: Container(
        height: size.height * .5,
        width: size.width * .7,
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildInfo(
                    'Name: ', '${user.firstName}, ${user.lastName}', false),
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
        okButton,
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
      mainAxisAlignment:
          spaces ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
      children: [
        Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        Flexible(child: Text(info))
      ],
    );
  }
}
