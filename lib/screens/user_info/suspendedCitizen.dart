import 'package:SOSMAK/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SuspendedCitizen extends StatefulWidget {
  @override
  _SuspendedCitizenState createState() => _SuspendedCitizenState();
}

class _SuspendedCitizenState extends State<SuspendedCitizen> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF93E9BE),
      appBar: AppBar(
        title: Text('Suspended Citizen'),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').where('isArchived', isEqualTo: true).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.size > 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        child: Column(children: snapshot.data.docs.map<Widget>((doc) => _userCards(doc)).toList()),
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text('No suspended citizen yet'));
                }
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  _userCards(DocumentSnapshot doc) {
    UserModel user = UserModel.get(doc);
    return InkWell(
      child: Card(
          elevation: 2,
          child: ListTile(
            leading: ClipOval(
              child: Container(
                width: 60,
                height: 60,
                child: Image.network(
                  user.profileUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text("${user.firstName}, ${user.lastName}"),
            subtitle: Text(user.email),
          )),
      onTap: () {
        showAlertDialog(user, doc);
      },
    );
  }

  showAlertDialog(UserModel user, DocumentSnapshot doc) {
    UserModel userModel = UserModel.get(doc);
    AlertDialog alert = AlertDialog(
      content: Container(
        height: size.height * .5,
        width: size.width * .7,
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClipOval(
                  child: Container(
                    width: 120,
                    height: 120,
                    child: Image.network(
                      user.profileUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                buildInfo('Name: ', '${user.firstName}, ${user.lastName}', false),
                buildInfo('Email: ', user.email, false),
                buildInfo('Address: ', user.address, false),
                buildInfo('ContactNo: ', user.contactNo, false),
                buildInfo('Age: ', user.age, false),
                buildInfo('Birthdate: ', user.birthDate, false),
                buildInfo('BirthPlace: ', user.birthPlace, false),
                buildInfo('Height: ', user.height, false),
                buildInfo('Weight', user.weight, false),
                buildInfo('Blood Type: ', user.bloodType, false),
                SizedBox(height: 10),
                buildInfo('Emergency Info: ', '', false),
                buildInfo('Name: ', user.contactPerson, false),
                buildInfo('Contact No.: ', user.emergencyContact, false),
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
                SizedBox(height: size.height * 0.03),
              ],
            ),
          ),
        ),
      ),
      actions: [
        FlatButton(
          color: Colors.green,
          child: Text("Unuspend"),
          onPressed: () {
            //confirm suspend
            //
            Navigator.pop(context);
            confirmUnsuspend(context, userModel);
          },
        ),
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  buildInfo(String name, String info, bool spaces) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: spaces ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
      children: [Text(name, style: TextStyle(fontWeight: FontWeight.bold)), Flexible(child: Text(info))],
    );
  }

  confirmUnsuspend(BuildContext context, UserModel user) {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are You sure you want to Unsuspend this Citizen account?"),
      //content: Text(""),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          color: Colors.green,
          child: Text("Unsuspend"),
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.ref)
                .update({'isArchived': false}).then((value) {
              //show suspend success
              Navigator.pop(context);
              unsuspendSuccess(context);
            });
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  unsuspendSuccess(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Citizen successfully Unsuspended"),
      // content: Text("This is my message."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
