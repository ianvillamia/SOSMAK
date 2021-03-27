import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:SOSMAK/services/errors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';

class SignUpMedical extends StatefulWidget {
  SignUpMedical({
    @required this.fNameController,
    @required this.lNameController,
    @required this.emailContoller,
    @required this.addressController,
    @required this.passwordController,
    @required this.bdayController,
    @required this.ageController,
    @required this.gender,
    @required this.imageProfile,
  });
  final TextEditingController fNameController,
      lNameController,
      emailContoller,
      addressController,
      bdayController,
      ageController,
      passwordController;
  final String gender;
  final File imageProfile;
  @override
  _SignUpMedicalState createState() => _SignUpMedicalState();
}

class _SignUpMedicalState extends State<SignUpMedical> {
  TextEditingController idTypeController = TextEditingController(), idNumberController = TextEditingController();

  File _imageID;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  List<String> idType = ['TIN ID', 'PhilHealth', 'Passport', 'Voters ID', 'UMID', 'Postal ID', 'Student ID'];
  String selectedID;
  bool isChecked = false;
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Text(
                  'Register',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                _dropDownButton(),
                _buildTextFormField(controller: idNumberController, label: 'ID Number'),
                SizedBox(height: 10),
                Center(
                  child: DottedBorder(
                    dashPattern: [9, 5],
                    child: Container(
                      height: size.height * .2,
                      width: size.width * .8,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                      child: _imageID == null
                          ? Center(
                              child: MaterialButton(
                                onPressed: () {
                                  getIDImage();
                                },
                                child: Text('Upload Valid ID'),
                              ),
                            )
                          : Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  height: size.height * .2,
                                  width: size.width * .8,
                                  child: Image.file(
                                    _imageID,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                MaterialButton(
                                  color: Color.fromRGBO(197, 213, 240, 0.5),
                                  onPressed: () {
                                    getIDImage();
                                  },
                                  child: Text('Upload Valid ID'),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Checkbox(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          value: isChecked,
                          checkColor: Colors.green,
                          activeColor: Colors.grey[300],
                          onChanged: (bool value) {
                            setState(() {
                              isChecked = value;
                            });
                          },
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: 'I agree to the ',
                              ),
                              TextSpan(
                                  text: 'Terms and conditions',
                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print('Terms of Service"');
                                    }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _showButtons(
                      text: 'Back',
                      onPressed: () => Navigator.pop(context),
                    ),
                    _showButtons(
                      text: 'Sign Up',
                      onPressed: isChecked
                          ? () {
                              // set user model
                              if (_formKey.currentState.validate()) {
                                UserModel user = UserModel();
                                user.firstName = widget.fNameController.text;
                                user.lastName = widget.lNameController.text;
                                user.email = widget.emailContoller.text;
                                user.address = widget.addressController.text;
                                user.birthDate = widget.bdayController.text;
                                user.age = widget.ageController.text;
                                user.gender = widget.gender;
                                user.idType = selectedID;
                                user.idNumber = idNumberController.text;
                                user.role = 'citizen';

                                context
                                    .read<AuthenticationService>()
                                    .signUp(
                                        fileID: _imageID,
                                        fileProfile: widget.imageProfile,
                                        email: widget.emailContoller.text.trim(),
                                        password: widget.passwordController.text.trim(),
                                        user: user)
                                    .then((value) {
                                  showNotApproveAlertDialog();
                                  if (value == true) {
                                    Navigator.of(context).popUntil((r) => r.isFirst);
                                  } else {
                                    showAlertDialog(value);
                                  }
                                });
                              }
                            }
                          : null,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _dropDownButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Container(
        width: size.width,
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(30.0),
              ),
            ),
            hintText: "ID Type",
          ),
          value: selectedID,
          onChanged: (String idValue) {
            setState(() {
              selectedID = idValue;
            });
          },
          items: idType
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text("$value"),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  _buildTextFormField({
    TextEditingController controller,
    String label,
    bool isPassword,
    int maxLines,
    bool caps = true,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: TextFormField(
        textCapitalization: caps ? TextCapitalization.words : TextCapitalization.none,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter a value';
          }
          return null;
        },
        controller: controller,
        maxLines: maxLines ?? 1,
        obscureText: isPassword ?? false,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            alignLabelWithHint: true,
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  _showButtons({@required String text, @required onPressed}) {
    return MaterialButton(
      child: Text(text),
      elevation: 5,
      color: Colors.blueAccent,
      textColor: Colors.white,
      onPressed: onPressed,
    );
  }

  Future getIDImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageID = File(pickedFile.path);

        debugPrint('hey');
        print(_imageID);
      } else {
        print('No image selected.');
      }
    });
  }

  showAlertDialog(FirebaseAuthException problem) {
    print(problem.message);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Something went wrong"),
          content: Text("${Errors.show(problem.code)}"),
        );
      },
    );
  }

  showNotApproveAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Successfully Created an Account!"),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).popUntil((r) => r.isFirst);
              },
            ),
          ],
        );
      },
    );
  }
}
