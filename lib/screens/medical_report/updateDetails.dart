import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:SOSMAK/services/authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateMedical extends StatefulWidget {
  UpdateMedical({Key key}) : super(key: key);

  @override
  _UpdateMedicalState createState() => _UpdateMedicalState();
}

class _UpdateMedicalState extends State<UpdateMedical> {
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
    isHiv = user.isHiv;
    isTb = user.isTb;
    isHeartDisease = user.isHeartDisease;
    isHighBlood = user.isHighBlood;
    isMalaria = user.isMalaria;
    isLiverFunction = user.isLiverFunction;
    isVDRLTest = user.isVDRLTest;
    isTpaTest = user.isTpaTest;
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
      body: Container(
        width: size.width,
        height: size.height,
        child: FutureBuilder<DocumentSnapshot>(
            future: AuthenticationService.getCurrentUser(firebaseUser.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (counter == 0) {
                  setData(snapshot.data);
                  counter++;
                }
                // setData(snapshot.data);
                return Column(
                  children: [
                    SizedBox(
                      height: size.height * .1,
                    ),
                    _buildHead(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * .1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('HIV TEST'),
                          Row(
                            children: [
                              Radio(
                                  value: true,
                                  groupValue: isHiv,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isHiv = value;
                                    });
                                  }),
                              SizedBox(width: 25),
                              Radio(
                                  value: false,
                                  groupValue: isHiv,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isHiv = value;
                                    });
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * .1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tubercolosis TEST'),
                          Row(
                            children: [
                              Radio(
                                  value: true,
                                  groupValue: isTb,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isTb = value;
                                    });
                                  }),
                              SizedBox(width: 25),
                              Radio(
                                  value: false,
                                  groupValue: isTb,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isTb = value;
                                    });
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                    //
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * .1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Heart Disease'),
                          Row(
                            children: [
                              Radio(
                                  value: true,
                                  groupValue: isHeartDisease,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isHeartDisease = value;
                                    });
                                  }),
                              SizedBox(width: 25),
                              Radio(
                                  value: false,
                                  groupValue: isHeartDisease,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isHeartDisease = value;
                                    });
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                    //

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * .1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('High Blood'),
                          Row(
                            children: [
                              Radio(
                                  value: true,
                                  groupValue: isHighBlood,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isHighBlood = value;
                                    });
                                  }),
                              SizedBox(width: 25),
                              Radio(
                                  value: false,
                                  groupValue: isHighBlood,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isHighBlood = value;
                                    });
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                    //

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * .1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Malaria'),
                          Row(
                            children: [
                              Radio(
                                  value: true,
                                  groupValue: isMalaria,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isMalaria = value;
                                    });
                                  }),
                              SizedBox(width: 25),
                              Radio(
                                  value: false,
                                  groupValue: isMalaria,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isMalaria = value;
                                    });
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                    //

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * .1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Liver Function'),
                          Row(
                            children: [
                              Radio(
                                  value: true,
                                  groupValue: isLiverFunction,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isLiverFunction = value;
                                    });
                                  }),
                              SizedBox(width: 25),
                              Radio(
                                  value: false,
                                  groupValue: isLiverFunction,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isLiverFunction = value;
                                    });
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                    //

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * .1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('VDRL TEST'),
                          Row(
                            children: [
                              Radio(
                                  value: true,
                                  groupValue: isVDRLTest,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isVDRLTest = value;
                                    });
                                  }),
                              SizedBox(width: 25),
                              Radio(
                                  value: false,
                                  groupValue: isVDRLTest,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isVDRLTest = value;
                                    });
                                  })
                            ],
                          )
                        ],
                      ),
                    ),

                    //

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * .1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('TPA TEST'),
                          Row(
                            children: [
                              Radio(
                                  value: true,
                                  groupValue: isTpaTest,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isTpaTest = value;
                                    });
                                  }),
                              SizedBox(width: 25),
                              Radio(
                                  value: false,
                                  groupValue: isTpaTest,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isTpaTest = value;
                                    });
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      color: Colors.blue,
                      onPressed: () async {
                        //update here
                        // print(_user.currentUser.ref);

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(firebaseUser.uid)
                            .update({
                          'isHiv': isHiv,
                          'isHeartDisease': isHeartDisease,
                          'isHighBlood': isHighBlood,
                          'isLiverFunction': isLiverFunction,
                          'isMalaria': isMalaria,
                          'isTb': isTb,
                          'isTPA': isTpaTest,
                          'isVDRL': isVDRLTest
                        }).then((value) => Navigator.pop(context));
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
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
      padding: EdgeInsets.symmetric(horizontal: size.width * .1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Positive'),
          SizedBox(
            width: 22,
          ),
          Text('Negative'),
        ],
      ),
    );
  }

  //update
}
