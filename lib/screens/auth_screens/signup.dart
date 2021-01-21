import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailContoller = TextEditingController(),
      passwordController = TextEditingController(),
      firstNameController = TextEditingController(),
      addressController = TextEditingController(),
      lastNameController = TextEditingController();
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('SOSMAK SIGN UP'),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildTextFormField(
                  controller: firstNameController, label: 'First Name'),
              _buildTextFormField(
                  controller: lastNameController, label: 'Last Name'),
              _buildTextFormField(
                  controller: addressController, label: 'Address', maxLines: 3),
              _buildTextFormField(controller: emailContoller, label: 'Email'),
              _buildTextFormField(
                  controller: passwordController,
                  label: 'Password',
                  isPassword: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // MaterialButton(
                  //   elevation: 5,
                  //   color: Colors.blueAccent,
                  //   textColor: Colors.white,
                  //   onPressed: () {
                  //     context
                  //         .read<AuthenticationService>()
                  //         //.signIn(email: email.text.trim(), password: password.text.trim());
                  //         .signIn(
                  //             email: 'testing@gmail.com', password: 'password');
                  //   },
                  //   child: Text('Login'),
                  // ),
                  SizedBox(
                    width: 15,
                  ),
                  MaterialButton(
                    elevation: 5,
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () {
                      //set user model
                      UserModel user = UserModel();
                      user.firstName = firstNameController.text;
                      user.lastName = lastNameController.text;
                      user.email = emailContoller.text;
                      user.address = addressController.text;
                      user.role = 'citizen';
                      context
                          .read<AuthenticationService>()
                          .signUp(
                              email: emailContoller.text.trim(),
                              password: passwordController.text.trim(),
                              user: user)
                          .then((value) {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      });
                      //.signIn(email: email.text.trim(), password: password.text.trim());
                    },
                    child: Text('Sign Up'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildTextFormField(
      {TextEditingController controller,
      String label,
      bool isPassword,
      int maxLines}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines ?? 1,
        obscureText: isPassword ?? false,
        decoration: InputDecoration(
            labelText: label,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }
}
