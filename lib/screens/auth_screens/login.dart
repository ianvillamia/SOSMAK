import 'package:SOSMAK/screens/auth_screens/signup.dart';
import 'package:SOSMAK/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: size.height * .2,
                ),
                Container(
                    width: size.width * .4,
                    height: size.height * .3,
                    child: Image.asset(
                      'assets/sos-mak.png',
                      fit: BoxFit.cover,
                    )),
                SizedBox(
                  height: size.height * .05,
                ),
                _buildTextFormField(
                    controller: emailController, label: 'Email'),
                _buildTextFormField(
                    controller: passwordController,
                    label: 'Password',
                    isPassword: true),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding: EdgeInsets.only(right: 25),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return Signup();
                            }));
                          },
                          child: Text('No account? Click here to Register'))),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      elevation: 5,
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          context
                              .read<AuthenticationService>()
                              //.signIn(email: email.text.trim(), password: password.text.trim());
                              .signIn(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim())
                              .then((value) {
                            if (value == true) {
                              //print loggin true;
                              print('object');
                            } else {
                              showAlertDialog(context, value, value.toString());
                            }
                          });
                        }
                      },
                      child: Text('Login'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
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
      padding: const EdgeInsets.all(8.0),
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

  showAlertDialog(
      BuildContext context, FirebaseAuthException problem, String message) {
    print(problem.message);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Something went wrong"),
          content: Text(problem.message.toString()),
        );
      },
    );
  }
}
