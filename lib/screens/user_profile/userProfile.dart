import 'package:SOSMAK/models/police.dart';
import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:SOSMAK/screens/user_profile/updateUserProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class RadioGroups {
  String choice;
  int index;

  RadioGroups({this.choice, this.index});
}

class _UserProfileState extends State<UserProfile> {
  Size size;

  UserDetailsProvider userDetailsProvider;
  UserModel user;

  TwilioFlutter twilioFlutter;

  String accountSid = DotEnv.env['ACCOUNT_SID'];
  String authToken = DotEnv.env['AUTH_TOKEN'];
  String twilioNumber = DotEnv.env['TWILIO_NUMBER'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    twilioFlutter = TwilioFlutter(
      accountSid: '$accountSid',
      authToken: '$authToken',
      twilioNumber: '$twilioNumber',
    );
  }

  void sendSms() async {
    twilioFlutter.sendSMS(toNumber: '+639562354758', messageBody: "HELP ME! I'M IN TROUBLE, SEND SOME AUTHORITIES");
  }

  @override
  Widget build(BuildContext context) {
    userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);

    size = MediaQuery.of(context).size;
    return Scaffold(
      drawerScrimColor: Color(0xFF93E9BE),
      backgroundColor: Color(0xFF93E9BE),
      appBar: AppBar(
        title: Text('User Profile'),
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
            _buildRowText(
              title: 'Contact No.: ',
              data: user.contactNo,
              title2: 'Gender: ',
              data2: user.gender,
            ),
            _buildRowText(
              title: 'Birthday: ',
              data: user.birthDate,
              title2: 'Age: ',
              data2: user.age,
            ),
            _buildNormalText(
              title: 'Address: ',
              data: user.address,
            ),
            _buildRowText(
              title: 'BirthPlace: ',
              data: user.birthPlace,
              title2: 'Civil Status: ',
              data2: user.civilStatus,
            ),
            _buildRowText(
              title: 'Language: ',
              data: user.language,
              title2: 'Religion: ',
              data2: user.religion,
            ),
            _buildRowText(
              title: 'Height: ',
              data: user.height,
              title2: 'Weight: ',
              data2: user.weight,
            ),
            _buildRowText(
              title: 'Allergies: ',
              data: user.allergies,
              title2: 'BloodType: ',
              data2: user.bloodType,
            ),
            SizedBox(height: 10),
            _buildEmergencyContact(
              ePerson1: user.emergencycontactPerson1,
              eRelation1: user.emergencyRelation1,
              eNumber1: user.emergencyContactNo1,
              ePerson2: user.emergencycontactPerson2,
              eRelation2: user.emergencyRelation2,
              eNumber2: user.emergencyContactNo2,
              ePerson3: user.emergencycontactPerson3,
              eRelation3: user.emergencyRelation3,
              eNumber3: user.emergencyContactNo3,
            ),
            SizedBox(height: size.height * 0.05),
            RaisedButton(
                color: Colors.blue[400],
                child: Text('Edit', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateUserProfile(
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
        children: [
          Container(
            width: size.width * 0.5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Flexible(child: Text(data, style: TextStyle(fontSize: 16) ?? 'data')),
              ],
            ),
          ),
          Container(
            width: size.width * 0.4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title2,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Flexible(
                  child: Text(
                    data2,
                    style: TextStyle(fontSize: 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Flexible(child: Text(data, style: TextStyle(fontSize: 16) ?? 'data')),
        ],
      ),
    );
  }

  _buildEmergencyContact({
    @required String ePerson1,
    @required String eRelation1,
    @required String eNumber1,
    @required String ePerson2,
    @required String eRelation2,
    @required String eNumber2,
    @required String ePerson3,
    @required String eRelation3,
    @required String eNumber3,
  }) {
    return Column(
      children: [
        (user.emergencyContactNo3.isNotEmpty || user.emergencyContactNo1 != '')
            ? Text(
                'Emergency Contacts',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )
            : Text(
                'Please update your Emergency Contacts',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
        //
        //Emergency Contact 1
        //
        (user.emergencyContactNo3.isNotEmpty || user.emergencyContactNo1 != '')
            ? _buildRowText(
                title: 'Name: ',
                data: ePerson1,
                title2: 'Relation: ',
                data2: eRelation1,
              )
            : Container(),
        (user.emergencyContactNo3.isNotEmpty || user.emergencyContactNo1 != '')
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: _buildContactNumber(eNumber1),
              )
            : Container(),
        //
        //Emergency Contact 2
        //
        (user.emergencyContactNo2.isNotEmpty || user.emergencyContactNo2 != '')
            ? _buildRowText(
                title: 'Name: ',
                data: ePerson2,
                title2: 'Relation: ',
                data2: eRelation2,
              )
            : Container(),
        (user.emergencyContactNo2.isNotEmpty || user.emergencyContactNo2 != '')
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: _buildContactNumber(eNumber2),
              )
            : Container(),
        //
        //Emergency Contact 3
        //
        (user.emergencyContactNo3.isNotEmpty || user.emergencyContactNo3 != '')
            ? _buildRowText(
                title: 'Name: ',
                data: ePerson3,
                title2: 'Relation: ',
                data2: eRelation3,
              )
            : Container(),
        (user.emergencyContactNo3.isNotEmpty || user.emergencyContactNo3 != '')
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: _buildContactNumber(eNumber3),
              )
            : Container(),
      ],
    );
  }

  _buildContactNumber(String number) {
    return Row(
      children: [
        Text(
          'Contact No.: ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Row(
          children: [
            Text(
              number,
              style: TextStyle(fontSize: 16),
            ),
            InkWell(
              onTap: () async {
                await _launchURL(number: number);
              },
              child: Icon(
                Icons.call,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _launchURL({String number}) async {
    String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
