import 'package:SOSMAK/models/police.dart';
import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:SOSMAK/screens/admin/create_police_account/createAccount.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePoliceAccount extends StatefulWidget {
  CreatePoliceAccount({Key key}) : super(key: key);

  @override
  _CreatePoliceAccountState createState() => _CreatePoliceAccountState();
}

class _CreatePoliceAccountState extends State<CreatePoliceAccount> {
  bool isAdmin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
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
                      return Center(child: Text('No Police Registered yet'));
                    }
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                })));
  }

  _userCards(DocumentSnapshot doc) {
    Police police = Police.getData(doc: doc);
    return InkWell(
      child: Card(
          elevation: 2,
          child: ListTile(
            leading: Image.network(police.imageUrl),
            title: Text("${police.firstName}, ${police.lastName}"),
            subtitle: Text(police.email),
          )),
      onTap: () {
        showAlertDialog(police, doc);
      },
    );
  }

  showAlertDialog(Police police, DocumentSnapshot doc) {
    String result1,
        result2,
        result3,
        result4,
        result5,
        result6,
        result7,
        result8;
    if (doc.data()['isHiv'] == true) {
      result1 = 'Positive';
    } else {
      result1 = 'Negative';
    }
    if (doc.data()['isTb'] == true) {
      result2 = 'Positive';
    } else {
      result2 = 'Negative';
    }
    if (doc.data()['isHeartDisease'] == true) {
      result3 = 'Positive';
    } else {
      result3 = 'Negative';
    }
    if (doc.data()['isHighBlood'] == true) {
      result4 = 'Positive';
    } else {
      result4 = 'Negative';
    }
    if (doc.data()['isMalaria'] == true) {
      result5 = 'Positive';
    } else {
      result5 = 'Negative';
    }
    if (doc.data()['isLiverFunction'] == true) {
      result6 = 'Positive';
    } else {
      result6 = 'Negative';
    }
    if (doc.data()['isVDRL'] == true) {
      result7 = 'Positive';
    } else {
      result7 = 'Negative';
    }
    if (doc.data()['isTPA'] == true) {
      result8 = 'Positive';
    } else {
      result8 = 'Negative';
    }
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {},
    );
    AlertDialog alert = AlertDialog(
      title: Image.network(police.imageUrl, width: 100, height: 100),
      content: Container(
        height: size.height * .45,
        child: Column(
          children: [
            buildInfo('Name: ', '${police.firstName}, ${police.lastName}',
                false, doc),
            buildInfo('Email: ', police.email, false, doc),
            buildInfo('Temporary Password: ', police.tempPassword, false, doc),
            SizedBox(height: size.height * 0.03),
            Text('Medical Status',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: size.height * 0.03),
            buildInfo('HIV Test: ', result1, true, doc),
            SizedBox(height: size.height * 0.01),
            buildInfo('Tuberculosis Test: ', result2, true, doc),
            SizedBox(height: size.height * 0.01),
            buildInfo('Heart Disease: ', result3, true, doc),
            SizedBox(height: size.height * 0.01),
            buildInfo('High Blood: ', result4, true, doc),
            SizedBox(height: size.height * 0.01),
            buildInfo('Malaria: ', result5, true, doc),
            SizedBox(height: size.height * 0.01),
            buildInfo('Liver Function: ', result6, true, doc),
            SizedBox(height: size.height * 0.01),
            buildInfo('VDRL Test: ', result7, true, doc),
            SizedBox(height: size.height * 0.01),
            buildInfo('TPA Test: ', result8, true, doc),
          ],
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

  buildInfo(String name, String info, bool spaces, DocumentSnapshot doc) {
    return Row(
      mainAxisAlignment:
          spaces ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
      children: [
        Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(info)
      ],
    );
  }
}
