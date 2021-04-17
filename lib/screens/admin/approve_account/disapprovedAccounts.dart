import 'package:SOSMAK/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisapprovedAccounts extends StatefulWidget {
  @override
  _DisapprovedAccountsState createState() => _DisapprovedAccountsState();
}

class _DisapprovedAccountsState extends State<DisapprovedAccounts> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF93E9BE),
      appBar: AppBar(
        title: Text('Disapproved Accounts'),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * .05, vertical: size.height * .03),
          child: StreamBuilder<QuerySnapshot>(
            // future: AuthenticationService.getCurrentUser(firebaseUser.uid),
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('isApproved', isEqualTo: false)
                .where('isTerminate', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.size > 0) {
                  return Column(
                    children: [
                      Column(
                          children: snapshot.data.docs.map<Widget>((doc) {
                        return _buildUserCard(doc);
                      }).toList()),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: MaterialButton(
                          elevation: 5,
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .where('isTerminate', isEqualTo: true)
                                .get()
                                .then((value) async {
                              for (var data in value.docs) {
                                await FirebaseFirestore.instance.collection('users').doc(data.id).delete();
                              }
                            });
                            Navigator.of(context, rootNavigator: true).pop('dialog');
                          },
                          child: Text(
                            'Terminate All Accounts',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.red,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Text('No users to terminate yet.'),
                  );
                }
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  _buildUserCard(DocumentSnapshot doc) {
    UserModel user = UserModel.get(doc);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 2,
          child: InkWell(
            onTap: () {
              showAlertDialog(context, user);
            },
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text("${user.firstName} ${user.lastName}"),
              subtitle: Text(user.email),
            ),
          ),
        ),
      ],
    );
  }

  showAlertDialog(BuildContext context, UserModel user) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10),
          content: Container(
            height: size.height * .6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: FadeInImage(
                              fit: BoxFit.contain,
                              placeholder: AssetImage('assets/id.jpg'),
                              image: NetworkImage(user.idURL),
                            ),
                          );
                        });
                  },
                  child: Container(
                    height: size.height * .3,
                    width: size.width,
                    child: FadeInImage(
                      fit: BoxFit.contain,
                      placeholder: AssetImage('assets/id.jpg'),
                      image: NetworkImage(user.idURL),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Name: ' + user.firstName + " " + user.lastName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                SizedBox(height: 10),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email: ' + user.email,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                SizedBox(height: 10),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ID Type: ' + user.idType,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                SizedBox(height: 10),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ID Number: ' + user.idNumber,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: MaterialButton(
                    elevation: 5,
                    onPressed: () async {
                      await FirebaseFirestore.instance.collection('users').doc(user.ref).delete().then((value) {
                        Navigator.of(context, rootNavigator: true).pop('dialog');
                      });
                    },
                    child: Text(
                      'Terminate Account',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
