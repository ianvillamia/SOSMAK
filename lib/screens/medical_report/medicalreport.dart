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
    String result1,
        result2,
        result3,
        result4,
        result5,
        result6,
        result7,
        result8;
    if (user.isHiv == true) {
      result1 = 'Positive';
    } else {
      result1 = 'Negative';
    }
    if (user.isTb == true) {
      result2 = 'Positive';
    } else {
      result2 = 'Negative';
    }
    if (user.isHeartDisease == true) {
      result3 = 'Positive';
    } else {
      result3 = 'Negative';
    }
    if (user.isHighBlood == true) {
      result4 = 'Positive';
    } else {
      result4 = 'Negative';
    }
    if (user.isMalaria == true) {
      result5 = 'Positive';
    } else {
      result5 = 'Negative';
    }
    if (user.isLiverFunction == true) {
      result6 = 'Positive';
    } else {
      result6 = 'Negative';
    }
    if (user.isVDRLTest == true) {
      result7 = 'Positive';
    } else {
      result7 = 'Negative';
    }
    if (user.isTpaTest == true) {
      result8 = 'Positive';
    } else {
      result8 = 'Negative';
    }
    return Container(
      width: size.width,
      height: size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildRow(title: 'HIV TEST', result: result1),
          _buildRow(title: 'Tuberculosis TEST', result: result2),
          _buildRow(title: 'Heart Disease', result: result3),
          _buildRow(title: 'High Blood', result: result4),
          _buildRow(title: 'Malaria', result: result5),
          _buildRow(title: 'Liver Function', result: result6),
          _buildRow(title: 'VRDL TEST', result: result7),
          _buildRow(title: 'TPA TEST', result: result8),
        ],
      ),
    );
  }

  _buildRow({@required String title, @required String result}) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              Text(result, style: TextStyle(fontSize: 22))
            ],
          ),
        ),
      ),
    );
  }
}
