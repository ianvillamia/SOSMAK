import 'package:SOSMAK/models/police.dart';

import 'package:SOSMAK/services/firestore_service.dart';
import 'package:SOSMAK/services/utils.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({Key key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController emailController = TextEditingController(),
      lastNameController = TextEditingController(),
      firstNameController = TextEditingController(),
      addressController = TextEditingController(),
      badgeNumberController = TextEditingController(),
      stationController = TextEditingController();
  Size size;
  final _formKey = GlobalKey<FormState>();

  List<String> ranks = [
    'Director General',
    'Deputy Director General',
    'Director',
    'Chief Superintendent',
    'Senior Superintendent',
    'Superintendent',
    'Chief Inspector',
    'Senior Inspector',
    'Inspector',
    'Senior Police Officer IV',
    'Senior Police Officer III',
    'Senior Police Officer II',
    'Senior Police Officer I',
    'Police Officer III',
    'Police Officer II',
    'Police Officer I'
  ];
  String selectedRanks;
  List<String> gender = ['Male', 'Female'];
  String selectedGender;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF93E9BE),
      appBar: AppBar(
        title: Text('Create Police Account'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildDropDownButton(
                  value: selectedRanks,
                  hintText: 'Police Rank',
                  items: ranks
                      .map(
                        (rankValue) => DropdownMenuItem(
                          value: rankValue,
                          child: Text("$rankValue"),
                        ),
                      )
                      .toList(),
                  onChanged: (String rValue) {
                    setState(() {
                      selectedRanks = rValue;
                    });
                  },
                ),
                _buildTextFormField(controller: firstNameController, label: 'First Name', caps: true),
                _buildTextFormField(controller: lastNameController, label: 'Last Name', caps: true),
                _buildTextFormField(controller: emailController, label: 'Email', caps: false),
                _buildDropDownButton(
                  value: selectedGender,
                  hintText: 'Gender',
                  items: gender
                      .map(
                        (genderValue) => DropdownMenuItem(
                          value: genderValue,
                          child: Text("$genderValue"),
                        ),
                      )
                      .toList(),
                  onChanged: (String gValue) {
                    setState(() {
                      selectedGender = gValue;
                    });
                  },
                ),
                _buildTextFormField(controller: addressController, label: 'Address', caps: true),
                _buildTextFormField(controller: badgeNumberController, label: 'Badge Number', caps: true),
                _buildTextFormField(controller: stationController, label: 'Station Assigned', caps: true),
                MaterialButton(
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        //generate account
                        String temporaryPassword = Utils.getRandomString(7);
                        Police police = Police();

                        police.firstName = firstNameController.text;
                        police.lastName = lastNameController.text;
                        police.email = emailController.text;
                        police.gender = selectedGender;
                        police.address = addressController.text;
                        police.badgeNumber = badgeNumberController.text;
                        police.policeRank = selectedRanks;
                        police.stationAssigned = stationController.text;
                        police.tempPassword = temporaryPassword;
                        police.role = 'police';
                        UserService()
                            .addPoliceAccount(
                          police: police,
                        )
                            .then((value) {
                          if (value == false) {
                            showAlertDialog(context, message: 'Account Already Exists');
                          } else {
                            showAlertDialog(context,
                                message: 'Hey',
                                widget: Container(
                                  height: size.height * .2,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Account Created',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text('Email:' + emailController.text),
                                        Text('Temporary Password:' + temporaryPassword),
                                      ],
                                    ),
                                  ),
                                ));
                            _reset();
                          }
                        });
                      }
                    },
                    child: Text('Generate Account'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _reset() {
    firstNameController.text = '';
    lastNameController.text = '';
    emailController.text = '';
    stationController.text = '';
    badgeNumberController.text = '';
    addressController.text = '';
    selectedRanks = null;
    selectedGender = null;
  }

  _buildTextFormField({TextEditingController controller, String label, bool caps}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        textCapitalization: caps ? TextCapitalization.words : TextCapitalization.none,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(25.0),
              ),
            )),
      ),
    );
  }

  _buildDropDownButton({
    @required String value,
    @required String hintText,
    @required onChanged,
    @required items,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Container(
        width: size.width,
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(25.0),
              ),
            ),
            hintText: hintText,
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please choose a $hintText';
            }
            return null;
          },
          value: value,
          onChanged: onChanged,
          items: items,
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context, {@required String message, Widget widget}) {
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: widget == null ? Text(message) : widget,
      );
    },
  );
}
