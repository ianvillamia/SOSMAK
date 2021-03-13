import 'package:flutter/material.dart';
import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Size size;
  UserDetailsProvider userDetailsProvider;
  @override
  Widget build(BuildContext context) {
    userDetailsProvider = Provider.of<UserDetailsProvider>(context, listen: false);
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
                child: Container(
              width: 150,
              height: 150,
              child: FadeInImage(
                  placeholder: AssetImage('assets/user.png'),
                  image: NetworkImage(userDetailsProvider.currentUser.imageUrl)),
            ))
          ],
        ),
      ),
    );
  }
}
