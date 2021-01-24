import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

class UpdateMedicalReport extends StatefulWidget {
  @override
  _UpdateMedicalReportState createState() => _UpdateMedicalReportState();
}

class _UpdateMedicalReportState extends State<UpdateMedicalReport> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Size size;

  String hivGroup = "Negative";
  String tbGroup = "Negative";
  String hdGroup = "Negative";
  String hbGroup = "Negative";
  String malGroup = "Negative";
  String lfGroup = "Negative";
  String vdrlGroup = "Negative";
  String tpaGroup = "Negative";

  List<String> _hivChoice = ["Positive", "Negative"];
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Report'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
            _medicalCat(
              title: 'HIV Test',
              group: hivGroup,
              onChanged: (value) => setState(() {
                hivGroup = value;
                print(hivGroup);
              }),
            ),
            _medicalCat(
                title: 'Tuberculosis Test',
                group: tbGroup,
                onChanged: (value) => setState(() {
                      tbGroup = value;
                      print(tbGroup);
                    })),
            _medicalCat(
                title: 'Heart Disease',
                group: hdGroup,
                onChanged: (value) => setState(() {
                      hdGroup = value;
                      print(hdGroup);
                    })),
            _medicalCat(
                title: 'High Blood',
                group: hbGroup,
                onChanged: (value) => setState(() {
                      hbGroup = value;
                      print(hbGroup);
                    })),
            _medicalCat(
                title: 'Malaria',
                group: malGroup,
                onChanged: (value) => setState(() {
                      malGroup = value;
                      print(malGroup);
                    })),
            _medicalCat(
                title: 'Liver Function',
                group: lfGroup,
                onChanged: (value) => setState(() {
                      lfGroup = value;
                      print(lfGroup);
                    })),
            _medicalCat(
                title: 'VDRL Test',
                group: vdrlGroup,
                onChanged: (value) => setState(() {
                      vdrlGroup = value;
                      print(vdrlGroup);
                    })),
            _medicalCat(
                title: 'TPA Test',
                group: tpaGroup,
                onChanged: (value) => setState(() {
                      tpaGroup = value;
                      print(tpaGroup);
                    })),
            RaisedButton(
              onPressed: () {
                print('printing ${_hivChoice[1]}');

                User user = auth.currentUser;
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .update({
                      'hivTest': toBool(hivGroup),
                      'tbTest': toBool(tbGroup),
                      'heartDisease': toBool(hdGroup),
                      'highBlood': toBool(hbGroup),
                      'malaria': toBool(malGroup),
                      'liverFunction': toBool(lfGroup),
                      'vdrlTest': toBool(vdrlGroup),
                      'tpaTest': toBool(tpaGroup),
                    })
                    .then((value) => print("Added"))
                    .catchError((error) => print("Failed to add quiz: $error"));
                //UserService().addMedicalReport();
              },
              child: Text('SAVE'),
            )
          ],
        ),
      ),
    );
  }

  toBool(String value) {
    if (value == 'Positive')
      return true;
    else
      return false;
  }

  _medicalCat({@required String title, @required onChanged, @required group}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        RadioGroup<String>.builder(
          direction: Axis.horizontal,
          groupValue: group,
          onChanged: onChanged,
          items: _hivChoice,
          itemBuilder: (item) => RadioButtonBuilder(
            item,
          ),
        ),
      ],
    );
  }
}
