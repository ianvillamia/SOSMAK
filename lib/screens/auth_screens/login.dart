import 'package:SOSMAK/screens/auth_screens/signup.dart';
import 'package:SOSMAK/services/authentication_service.dart';
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
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('SOSMAK LOGIN'),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: size.height * .2,
              ),
              _buildTextFormField(controller: emailController, label: 'Email'),
              _buildTextFormField(
                  controller: passwordController,
                  label: 'Password',
                  isPassword: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    elevation: 5,
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () {
                      context
                          .read<AuthenticationService>()
                          //.signIn(email: email.text.trim(), password: password.text.trim());
                          .signIn(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim());
                    },
                    child: Text('Login'),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  MaterialButton(
                    elevation: 5,
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return Signup();
                      }));
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
      {TextEditingController controller, String label, bool isPassword}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
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
