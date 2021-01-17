import 'package:SOSMAK/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController email = TextEditingController(),
      password = TextEditingController();
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('SOSMAK LOGIN'),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: email,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: password,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ),
            MaterialButton(
              onPressed: () {
                print('hello');
                context
                    .read<AuthenticationService>()
                    // .signIn(email: email.text.trim(), password: password.text.trim());
                    .signIn(email: 'testing@gmail.com', password: 'password');
              },
              child: Text('Login'),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return Signup();
                }));
              },
              child: Text('Sign Up'),
            )
          ],
        ),
      ),
    );
  }
}
