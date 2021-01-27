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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UpdateMedical()));
            },
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc('sZ3QWKrGWfUumTb7zMbp1d5sxm52')
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildRow(title: 'HIV TEST', value: user.isHiv),
          _buildRow(title: 'Tuberculosis TEST', value: user.isTb),
          _buildRow(title: 'Heart Disease', value: user.isHeartDisease),
          _buildRow(title: 'High Blood', value: user.isHighBlood),
          _buildRow(title: 'Malaria', value: user.isMalaria),
          _buildRow(title: 'Liver Function', value: user.isLiverFunction),
          _buildRow(title: 'VRDL TEST', value: user.isVDRLTest),
          _buildRow(title: 'TPA TEST', value: user.isTpaTest),
        ],
      ),
    );
  }

  _buildRow({@required String title, @required bool value}) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              Text(value.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22))
            ],
          ),
        ),
      ),
    );
  }
}
