import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'dart:math';

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
                        String temporaryPassword = getRandomString(7);
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
                            .then((value) {});
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

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

showAlertDialog(BuildContext context, {@required String message}) {
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(message),
      );
    },
  );
}
