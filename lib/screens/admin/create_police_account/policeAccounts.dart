import 'package:SOSMAK/models/police.dart';
import 'package:SOSMAK/screens/admin/create_police_account/createAccount.dart';
import 'package:SOSMAK/services/rankImages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class CreatePoliceAccount extends StatefulWidget {
  CreatePoliceAccount({Key key}) : super(key: key);

  @override
  _CreatePoliceAccountState createState() => _CreatePoliceAccountState();
}

class _CreatePoliceAccountState extends State<CreatePoliceAccount> {
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
          title: Text('Police Accounts'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateAccount()));
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
    Police police = Police.get(doc: doc);

    return InkWell(
      child: Card(
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            leading: Image.network(police.imageUrl),
            title: Text("${police.firstName}, ${police.lastName}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(police.policeRank),
                Text(police.stationAssigned),
              ],
            ),
            trailing: Image.asset(
              "${RankImage.show(police.policeRank)}",
              height: size.height * 0.06,
            ),
          )),
      onTap: () {
        showAlertDialog(police, doc);
      },
    );
  }

  showAlertDialog(Police police, DocumentSnapshot doc) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Image.network(police.imageUrl, width: 100, height: 100),
      content: Container(
        height: size.height * .4,
        width: size.width * .7,
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildInfo('Name: ', '${police.firstName}, ${police.lastName}',
                    false, doc),
                buildInfo('Email: ', police.email, false, doc),
                buildInfo(
                    'Temporary Password: ', police.tempPassword, false, doc),
                buildInfo('Age: ', police.age, false, doc),
                buildInfo('Birthday: ', police.birthDate, false, doc),
                buildInfo('BirthPlace: ', police.birthPlace, false, doc),
                buildInfo('Height: ', police.height, false, doc),
                buildInfo('Weight', police.weight, false, doc),
                buildInfo('Blood Type: ', police.bloodType, false, doc),
                buildInfo('Allergies: ', police.allergies, false, doc),
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

  buildInfo(
      String name, String medicalInfo, bool spaces, DocumentSnapshot doc) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment:
            spaces ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(medicalInfo)
        ],
      ),
    );
  }
}
