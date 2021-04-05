import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/services/authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class UpdateMedical2 extends StatefulWidget {
  final UserModel user;
  UpdateMedical2({@required this.user, Key key}) : super(key: key);

  @override
  _UpdateMedical2State createState() => _UpdateMedical2State();
}

class _UpdateMedical2State extends State<UpdateMedical2> {
  Size size;
  bool isHiv;
  bool isTb;
  bool isHeartDisease;
  bool isHighBlood;
  bool isMalaria;
  bool isLiverFunction;
  bool isVDRLTest;
  bool isTpaTest;
  User firebaseUser;
  int counter = 0;
  setData(DocumentSnapshot doc) {
    UserModel user = UserModel.get(doc);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(counter);
  }

  @override
  Widget build(BuildContext context) {
    firebaseUser = context.watch<User>();

    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Medical Record'),
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
        child: FutureBuilder<DocumentSnapshot>(
            future: AuthenticationService.getCurrentUser(firebaseUser.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (counter == 0) {
                  setData(snapshot.data);
                  counter++;
                }
                // setData(snapshot.data);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .05),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * .03,
                        ),
                        _buildHead(),
                        _buildRadio(
                            title: 'HIV Test',
                            groupValue: isHiv,
                            onChanged: (bool value) {
                              setState(() {
                                isHiv = value;
                              });
                            }),
                        _buildRadio(
                            title: 'Tuberculosis Test',
                            groupValue: isTb,
                            onChanged: (bool value) {
                              setState(() {
                                isTb = value;
                              });
                            }),
                        _buildRadio(
                            title: 'Heart Disease',
                            groupValue: isHeartDisease,
                            onChanged: (bool value) {
                              setState(() {
                                isHeartDisease = value;
                              });
                            }),
                        _buildRadio(
                            title: 'High Blood',
                            groupValue: isHighBlood,
                            onChanged: (bool value) {
                              setState(() {
                                isHighBlood = value;
                              });
                            }),
                        _buildRadio(
                            title: 'Malaria',
                            groupValue: isMalaria,
                            onChanged: (bool value) {
                              setState(() {
                                isMalaria = value;
                              });
                            }),
                        _buildRadio(
                            title: 'Liver Function',
                            groupValue: isLiverFunction,
                            onChanged: (bool value) {
                              setState(() {
                                isLiverFunction = value;
                              });
                            }),
                        _buildRadio(
                            title: 'VDRL Test',
                            groupValue: isVDRLTest,
                            onChanged: (bool value) {
                              setState(() {
                                isVDRLTest = value;
                              });
                            }),
                        _buildRadio(
                            title: 'TPA Test',
                            groupValue: isTpaTest,
                            onChanged: (bool value) {
                              setState(() {
                                isTpaTest = value;
                              });
                            }),
                        SizedBox(height: 50),
                        MaterialButton(
                          color: Colors.blue,
                          onPressed: () async {
                            //update here
                            // print(_user.currentUser.ref);

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(firebaseUser.uid)
                                .update({
                              // 'firstName': widget.user.firstName,
                              // 'lastName': widget.user.lastName,
                              'birthDate': widget.user.birthDate,
                              'birthPlace': widget.user.birthPlace,
                              'age': widget.user.age,
                              'height': widget.user.height,
                              'weight': widget.user.weight,
                              'bloodType': widget.user.bloodType,
                            }).then((value) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  _buildHead() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * .03),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Positive', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(
            width: 22,
          ),
          Text('Negative', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  _buildRadio(
      {@required String title,
      @required bool groupValue,
      @required onChanged}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        Row(
          children: [
            Radio(value: true, groupValue: groupValue, onChanged: onChanged),
            SizedBox(width: 25),
            Radio(value: false, groupValue: groupValue, onChanged: onChanged)
          ],
        )
      ],
    );
  }

  //update
}
