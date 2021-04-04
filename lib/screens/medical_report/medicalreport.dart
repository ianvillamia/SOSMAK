import 'package:SOSMAK/models/police.dart';
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
  UserModel user;
  @override
  Widget build(BuildContext context) {
    userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);

    size = MediaQuery.of(context).size;
    return Scaffold(
      drawerScrimColor: Color(0xFF93E9BE),
      backgroundColor: Color(0xFF93E9BE),
      appBar: AppBar(
        title: Text('My Profile'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          RaisedButton(
              color: Colors.blue[400],
              child: Text('Edit', style: TextStyle(color: Colors.white)),
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
    user = UserModel.get(doc);
    Police police = Police.get(doc: doc);
    return Container(
      width: size.width,
      height: size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: (user.role == 'police')
                  ? ClipOval(
                      child: Container(
                        width: 150,
                        height: 150,
                        child: Image.network(
                          user.profileUrl,
                          fit: BoxFit.cover,
                          width: 130,
                          height: 130,
                        ),
                      ),
                    )
                  : ClipOval(
                      child: Container(
                        width: 150,
                        height: 150,
                        child: Image.network(
                          user.profileUrl,
                          fit: BoxFit.cover,
                          width: 130,
                          height: 130,
                        ),
                      ),
                    ),
            ),
            _buildNormalText(
              title: 'Name: ',
              data: '${user.firstName} ${user.lastName}',
            ),
            _buildNormalText(
              title: 'Gender: ',
              data: user.gender,
            ),
            _buildRowText(
              title: 'Birthday: ',
              data: user.birthDate,
              title2: 'Age: ',
              data2: user.age,
            ),
            _buildNormalText(
              title: 'Contact No.: ',
              data: user.contactNo,
            ),
            _buildNormalText(
              title: 'Address: ',
              data: user.address,
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
              title2: 'Allergies: ',
              data2: user.allergies,
            ),
            SizedBox(height: 10),
            _buildNormalText(
              title: 'Emergency Contact: ',
              data: '',
            ),
            _buildNormalText(
              title: 'Name: ',
              data: user.contactPerson,
            ),
            _buildNormalText(
              title: 'Contact No.: ',
              data: user.emergencyContact,
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
                : _buildMedicalText(
                    icon: Icons.keyboard_arrow_right,
                    data: user.otherMedicalCondition1,
                  ),
            (user.otherMedicalCondition2.isEmpty)
                ? Container()
                : _buildMedicalText(
                    icon: Icons.keyboard_arrow_right,
                    data: user.otherMedicalCondition2,
                  ),
            (user.otherMedicalCondition3.isEmpty)
                ? Container()
                : _buildMedicalText(
                    icon: Icons.keyboard_arrow_right,
                    data: user.otherMedicalCondition3,
                  ),
            (user.otherMedicalCondition4.isEmpty)
                ? Container()
                : _buildMedicalText(
                    icon: Icons.keyboard_arrow_right,
                    data: user.otherMedicalCondition4,
                  ),
            (user.otherMedicalCondition5.isEmpty)
                ? Container()
                : _buildMedicalText(
                    icon: Icons.keyboard_arrow_right,
                    data: user.otherMedicalCondition5,
                  ),
            SizedBox(height: size.height * 0.05),
            // RaisedButton(
            //     color: Colors.blue[400],
            //     child: Text('Update', style: TextStyle(color: Colors.white)),
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => UpdateMedical(
            //             user: user,
            //           ),
            //         ),
            //       );
            //     })
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

  _buildNormalText({@required String title, String data}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(data, style: TextStyle(fontSize: 18) ?? 'data'),
        ],
      ),
    );
  }

  _buildMedicalText({@required IconData icon, String data}) {
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
