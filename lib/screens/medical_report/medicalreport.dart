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

  @override
  Widget build(BuildContext context) {
    userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);

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
          stream: FirebaseFirestore.instance.collection('users').doc(userDetailsProvider.currentUser.ref).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            print(snapshot.connectionState);

            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
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
            _buildRowText(
              title: 'Name: ',
              data: '${user.firstName} ${user.lastName}',
              title2: 'Birthday: ',
              data2: user.birthDate,
            ),
            _buildRowText(
              title: 'Language: ',
              data: user.language,
              title2: 'Birthplace: ',
              data2: user.birthPlace,
            ),
            _buildRowText(
              title: 'Religion: ',
              data: user.religion,
              title2: 'Age: ',
              data2: user.age,
            ),
            _buildRowText(
              title: 'Height: ',
              data: user.height,
              title2: 'Weight: ',
              data2: user.weight,
            ),
            _buildRowText(
              title: 'BloodType: ',
              data: user.bloodType,
              title2: 'Gender: ',
              data2: user.gender,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        'Allergies: ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(user.allergies, style: TextStyle(fontSize: 18) ?? 'data'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        'Contact Person: ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(user.contactPerson, style: TextStyle(fontSize: 18) ?? 'data'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            (user.otherMedicalCondition1.isEmpty &&
                    user.otherMedicalCondition2.isEmpty &&
                    user.otherMedicalCondition3.isEmpty &&
                    user.otherMedicalCondition4.isEmpty &&
                    user.otherMedicalCondition5.isEmpty)
                ? Text(
                    'No Medical Conditions',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                : Text(
                    'Medical Conditions',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
            SizedBox(height: 5),
            (user.otherMedicalCondition1.isEmpty)
                ? Container()
                : _buildNormalText(
                    icon: Icons.keyboard_arrow_right,
                    data: user.otherMedicalCondition1,
                  ),
            (user.otherMedicalCondition2.isEmpty)
                ? Container()
                : _buildNormalText(
                    icon: Icons.keyboard_arrow_right,
                    data: user.otherMedicalCondition2,
                  ),
            (user.otherMedicalCondition3.isEmpty)
                ? Container()
                : _buildNormalText(
                    icon: Icons.keyboard_arrow_right,
                    data: user.otherMedicalCondition3,
                  ),
            (user.otherMedicalCondition4.isEmpty)
                ? Container()
                : _buildNormalText(
                    icon: Icons.keyboard_arrow_right,
                    data: user.otherMedicalCondition4,
                  ),
            (user.otherMedicalCondition5.isEmpty)
                ? Container()
                : _buildNormalText(
                    icon: Icons.keyboard_arrow_right,
                    data: user.otherMedicalCondition5,
                  ),
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
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  _buildRowText({@required String title, title2, String data, data2}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(data, style: TextStyle(fontSize: 18) ?? 'data'),
            ],
          ),
          Container(
            width: size.width * 0.5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title2,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Flexible(
                  child: Text(
                    data2,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildNormalText({@required IconData icon, String data}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Icon(icon),
          Text(data, style: TextStyle(fontSize: 18) ?? 'data'),
        ],
      ),
    );
  }
}
