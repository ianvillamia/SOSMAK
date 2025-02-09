import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/screens/admin/approve_account/disapprovedAccounts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ApproveAccount extends StatefulWidget {
  ApproveAccount({Key key}) : super(key: key);

  @override
  _ApproveAccountState createState() => _ApproveAccountState();
}

class _ApproveAccountState extends State<ApproveAccount> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF93E9BE),
      appBar: AppBar(
        title: Text('Admin Approval'),
        actions: [
          IconButton(
            icon: Icon(Icons.do_disturb_alt_outlined),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisapprovedAccounts(),
                )),
          ),
        ],
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
                .where('isTerminate', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.size > 0) {
                  return Column(
                      children: snapshot.data.docs.map<Widget>((doc) {
                    return _buildUserCard(doc);
                  }).toList());
                } else {
                  return Center(
                    child: Text('No users to approve yet.'),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MaterialButton(
                          elevation: 5,
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.ref)
                                .update({'isApproved': true}).then((value) {
                              Navigator.of(context, rootNavigator: true).pop('dialog');
                            });
                          },
                          child: Text(
                            'APPROVE',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blueAccent,
                        ),
                        MaterialButton(
                          elevation: 5,
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.ref)
                                .update({'isTerminate': true}).then((value) {
                              Navigator.of(context, rootNavigator: true).pop('dialog');
                            });
                          },
                          child: Text(
                            'DISAPPROVE',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.red,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
