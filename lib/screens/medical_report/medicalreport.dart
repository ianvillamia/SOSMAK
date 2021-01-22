import 'package:SOSMAK/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

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
  final FirebaseAuth auth = FirebaseAuth.instance;
  Size size;
  bool choice1 = false,
      choice2 = false,
      choice3 = false,
      choice4 = false,
      choice5 = false,
      choice6 = false,
      choice7 = false,
      choice8 = false;

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Test'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Test'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Medical Report'),
        leading: IconButton(
          icon: Icon(Icons.home),
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
                if (hivGroup == 'Positive') {
                  choice1 = true;
                } else {
                  choice1 = false;
                }
                if (tbGroup == 'Positive') {
                  choice2 = true;
                } else {
                  choice2 = false;
                }
                if (hdGroup == 'Positive') {
                  choice3 = true;
                } else {
                  choice3 = false;
                }
                if (hbGroup == 'Positive') {
                  choice4 = true;
                } else {
                  choice4 = false;
                }
                if (malGroup == 'Positive') {
                  choice5 = true;
                } else {
                  choice5 = false;
                }
                if (lfGroup == 'Positive') {
                  choice6 = true;
                } else {
                  choice6 = false;
                }
                if (vdrlGroup == 'Positive') {
                  choice7 = true;
                } else {
                  choice7 = false;
                }
                if (tpaGroup == 'Positive') {
                  choice8 = true;
                } else {
                  choice8 = false;
                }
                print('printing ${_hivChoice[1]}');

                User user = auth.currentUser;
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .update({
                      'isHIV': choice1,
                      'isTB': choice2,
                      'isHeartDisease': choice3,
                      'isHighBlood': choice4,
                      'isMalaria': choice5,
                      'isLiverFunction': choice6,
                      'isVDRL': choice7,
                      'isTPA': choice8,
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

  _addradioButton(
      {@required int btnValue,
      @required String title,
      @required List value,
      @required String groupValue}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: value[btnValue],
          groupValue: groupValue,
          onChanged: (value) {
            setState(() {
              print(value);
              print(groupValue);
              groupValue = value;
            });
          },
        ),
        Text(title)
      ],
    );
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
