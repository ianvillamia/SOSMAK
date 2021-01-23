import 'package:SOSMAK/models/userModel.dart';
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
      firstNameController = TextEditingController();
  Size size;
  final _formKey = GlobalKey<FormState>();
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
                _buildTextFormField(
                    controller: emailController, label: 'Email'),
                _buildTextFormField(
                    controller: lastNameController, label: 'Last Name'),
                _buildTextFormField(
                    controller: firstNameController, label: 'First Name'),
                MaterialButton(
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        //generate account
                        String temporaryPassword = Utils.getRandomString(7);
                        UserModel user = UserModel();
                        user.firstName = firstNameController.text;
                        user.lastName = lastNameController.text;
                        user.email = emailController.text;
                        user.tempPassword = temporaryPassword;
                        user.role = 'police';
                        UserService()
                            .addPoliceAccount(
                          user: user,
                        )
                            .then((value) {
                          if (value == false) {
                            showAlertDialog(context,
                                message: 'Account Already Exists');
                          } else {
                            showAlertDialog(context,
                                message: 'hey',
                                widget: Container(
                                  height: size.height * .2,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text('Account Created'),
                                        Text('Email:' + emailController.text),
                                        Text('Temporary Password:' +
                                            temporaryPassword),
                                      ],
                                    ),
                                  ),
                                ));
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

  _buildTextFormField(
      {TextEditingController controller, String label, bool isPassword}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        controller: controller,
        obscureText: isPassword ?? false,
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
