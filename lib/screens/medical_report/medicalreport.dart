import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:SOSMAK/screens/medical_report/updateMedical.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:provider/provider.dart';

class MedicalReport extends StatefulWidget {
  @override
  _MedicalReportState createState() => _MedicalReportState();
}

class RadioGroups {
  String choice;
  int index;

  RadioGroups({this.choice, this.index});
}

class _MedicalReportState extends State<MedicalReport> {
  Size size;

  UserDetailsProvider userDetailsProvider;

  List<String> _hivChoice = ["Positive", "Negative"];

  @override
  Widget build(BuildContext context) {
    userDetailsProvider =
        Provider.of<UserDetailsProvider>(context, listen: false);
    print(userDetailsProvider.currentUser.hivTest);
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Report'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateMedicalReport()),
              );
            },
          )
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        alignment: Alignment.center,
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Medical Report',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cateogry(title: 'HIV Test'),
                      cateogry(title: 'Tuberculosis Test'),
                      cateogry(title: 'Heart Disease'),
                      cateogry(title: 'High Blood'),
                      cateogry(title: 'Malaria'),
                      cateogry(title: 'Liver Function'),
                      cateogry(title: 'VDRL Test'),
                      cateogry(title: 'TPA Test'),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      result(
                          result: userDetailsProvider.currentUser.hivTest
                              .toString()),
                      result(
                          result: userDetailsProvider.currentUser.tbTest
                              .toString()),
                      result(
                          result: userDetailsProvider.currentUser.heartDisease
                              .toString()),
                      result(
                          result: userDetailsProvider.currentUser.highBlood
                              .toString()),
                      result(
                          result: userDetailsProvider.currentUser.malaria
                              .toString()),
                      result(
                          result: userDetailsProvider.currentUser.liverFunction
                              .toString()),
                      result(
                          result: userDetailsProvider.currentUser.vdrlTest
                              .toString()),
                      result(
                          result: userDetailsProvider.currentUser.tpaTest
                              .toString()),
                    ],
                  ),
                ),
                SizedBox(width: 10)
              ],
            ),
            SizedBox(height: size.height * 0.1),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: RaisedButton(
            //     onPressed: () {},
            //     child: Text('Update'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  cateogry({@required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  result({@required String result}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(result, style: TextStyle(fontSize: 18)),
    );
  }
}
