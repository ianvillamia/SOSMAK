import 'dart:ffi';

import 'package:SOSMAK/models/police.dart';
import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/services/firestore_service.dart';
import 'package:SOSMAK/services/utils.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({Key key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class PoliceRanks {
  int id;
  String name;

  PoliceRanks(this.id, this.name);

  static List<PoliceRanks> getCompanies() {
    return <PoliceRanks>[
      PoliceRanks(1, 'Director General'),
      PoliceRanks(2, 'Deputy Director General'),
      PoliceRanks(3, 'Director'),
      PoliceRanks(4, 'Chief Superintendent'),
      PoliceRanks(5, 'Senior Superintendent'),
      PoliceRanks(6, 'Superintendent'),
      PoliceRanks(7, 'Chief Inspector'),
      PoliceRanks(8, 'Senior Inspector'),
      PoliceRanks(9, 'Inspector'),
      PoliceRanks(10, 'Senior Police Officer IV'),
      PoliceRanks(11, 'Senior Police Officer III'),
      PoliceRanks(12, 'Senior Police Officer II'),
      PoliceRanks(13, 'Senior Police Officer I'),
      PoliceRanks(14, 'Police Officer III'),
      PoliceRanks(15, 'Police Officer II'),
      PoliceRanks(16, 'Police Officer I'),
    ];
  }
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController emailController = TextEditingController(),
      lastNameController = TextEditingController(),
      firstNameController = TextEditingController(),
      stationController = TextEditingController();
  Size size;
  final _formKey = GlobalKey<FormState>();

  List<PoliceRanks> _policeRanks = PoliceRanks.getCompanies();
  List<DropdownMenuItem<PoliceRanks>> _dropdownMenuItems;
  PoliceRanks _selectedIncident;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_policeRanks);
    super.initState();
  }

  List<DropdownMenuItem<PoliceRanks>> buildDropdownMenuItems(List policeRanks) {
    List<DropdownMenuItem<PoliceRanks>> items = List();
    for (PoliceRanks police in policeRanks) {
      items.add(
        DropdownMenuItem(
          value: police,
          child: Text(police.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(PoliceRanks selectedCompany) {
    setState(() {
      _selectedIncident = selectedCompany;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
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
                Container(
                  width: size.width * 0.98,
                  padding: EdgeInsets.fromLTRB(15, 12, 15, 0),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text('Please select Police Rank'),
                    value: _selectedIncident,
                    items: _dropdownMenuItems,
                    onChanged: onChangeDropdownItem,
                  ),
                ),
                _buildTextFormField(
                    controller: firstNameController,
                    label: 'First Name',
                    caps: true),
                _buildTextFormField(
                    controller: lastNameController,
                    label: 'Last Name',
                    caps: true),
                _buildTextFormField(
                    controller: emailController, label: 'Email', caps: false),
                _buildTextFormField(
                    controller: stationController,
                    label: 'Station Assigned',
                    caps: true),
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
                        police.policeRank = _selectedIncident.name;
                        police.stationAssigned = stationController.text;
                        police.tempPassword = temporaryPassword;
                        police.role = 'police';
                        UserService()
                            .addPoliceAccount(
                          police: police,
                        )
                            .then((value) {
                          if (value == false) {
                            showAlertDialog(context,
                                message: 'Account Already Exists');
                          } else {
                            showAlertDialog(context,
                                message: 'Hey',
                                widget: Container(
                                  height: size.height * .2,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Account Created',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('Email:' + emailController.text),
                                        Text('Temporary Password:' +
                                            temporaryPassword),
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
    _selectedIncident = null;
  }

  _buildTextFormField(
      {TextEditingController controller, String label, bool caps}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        textCapitalization:
            caps ? TextCapitalization.words : TextCapitalization.none,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }
}

showAlertDialog(BuildContext context,
    {@required String message, Widget widget}) {
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
