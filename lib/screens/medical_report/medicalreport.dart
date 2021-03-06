import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:SOSMAK/screens/medical_report/updateDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

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

    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Profile'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userDetailsProvider.currentUser.ref)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            print(snapshot.connectionState);

            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                //_buildMedicalReport(snapshot.data);
                print(snapshot.data);
                return _buildMedicalReport(snapshot.data);
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  _buildMedicalReport(DocumentSnapshot doc) {
    UserModel user = UserModel.get(doc);

    return Container(
      width: size.width,
      height: size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildText(
                title: 'Name: ',
                data: '${user.firstName} ${user.lastName}',
                title2: 'Birthday: ',
                data2: user.birthDate,
                doc: doc),
            _buildText(
                title: 'Age: ',
                data: user.age,
                title2: 'Birthplace: ',
                data2: user.birthPlace,
                doc: doc),
            _buildText(
                title: 'Height: ',
                data: user.height,
                title2: 'Weight: ',
                data2: user.weight,
                doc: doc),
            _buildText(
                title: 'BloodType: ',
                data: user.bloodType,
                title2: 'Allergies: ',
                data2: user.allergies,
                doc: doc),
            SizedBox(height: size.height * 0.05),
            RaisedButton(
                color: Colors.blue[400],
                child: Text('Update', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateMedical(
                                user: user,
                              )));
                })
          ],
        ),
      ),
    );
  }

  _buildText(
      {@required String title,
      title2,
      String data,
      data2,
      DocumentSnapshot doc}) {
    UserModel user = UserModel.get(doc);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text(data, style: TextStyle(fontSize: 18)),
            ],
          ),
          Container(
            width: size.width * 0.5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(title2,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Flexible(child: Text(data2, style: TextStyle(fontSize: 18))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildRow({@required String title, @required String result}) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                width: size.width * 0.5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(result, style: TextStyle(fontSize: 16)),
                    SizedBox(width: size.width * 0.05)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
