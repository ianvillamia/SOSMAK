import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/screens/auth_screens/login.dart';
import 'package:SOSMAK/services/authentication_service.dart';
import 'package:SOSMAK/services/errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final _formKey = GlobalKey<FormState>();

  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      width: size.width * .35,
                      height: size.height * .25,
                      child: Image.asset(
                        'assets/sosmakLogo.png',
                        fit: BoxFit.contain,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildTextFormField(
                    controller: firstNameController, label: 'First Name'),
                _buildTextFormField(
                    controller: lastNameController, label: 'Last Name'),
                _buildTextFormField(
                    controller: addressController,
                    label: 'Address',
                    maxLines: 2),
                _buildTextFormField(
                    caps: false, controller: emailContoller, label: 'Email'),
                _buildPasswordField(
                    controller: passwordController, label: 'Password'),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 25),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return Login();
                            }));
                          },
                          child: Text(
                              'Already Got an Account? Click here to login'))),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    MaterialButton(
                      elevation: 5,
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        //set user model
                        if (_formKey.currentState.validate()) {
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
                            if (value == true) {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            } else {
                              showAlertDialog(context, value);
                            }
                          });
                        }

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
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        textCapitalization:
            caps ? TextCapitalization.words : TextCapitalization.none,
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
            alignLabelWithHint: true,
            labelText: label,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  _buildPasswordField({TextEditingController controller, String label}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Password is required';
          }
          return null;
        },
        controller: controller,
        obscureText: _isHidden,
        decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            suffixIcon: IconButton(
                onPressed: _toggleVisibility,
                icon: _isHidden
                    ? Icon(Icons.visibility_off, size: 20)
                    : Icon(Icons.visibility, size: 20))),
      ),
    );
  }

  showAlertDialog(BuildContext context, FirebaseAuthException problem) {
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
}
