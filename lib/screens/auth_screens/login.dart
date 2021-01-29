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

  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

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
                _buildEmailField(controller: emailController, label: 'Email'),
                _buildPasswordField(
                    controller: passwordController, label: 'Password'),
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

  _buildEmailField({TextEditingController controller, String label}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Email is required';
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        ),
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
