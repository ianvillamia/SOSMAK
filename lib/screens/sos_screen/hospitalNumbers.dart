import 'package:SOSMAK/models/emergencyModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalNumbers extends StatefulWidget {
  final DocumentSnapshot doc;
  HospitalNumbers({this.doc});
  @override
  _HospitalNumbersState createState() => _HospitalNumbersState();
}

Size size;

class _HospitalNumbersState extends State<HospitalNumbers> {
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF93E9BE),
      appBar: AppBar(
        title: Text(
          'Hospital Emergency HOTLINE',
        ),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Container(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    child: Text(
                      'TAP TO CALL',
                      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: size.height * .03),
                Container(
                  height: size.height * 0.8,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('emergencyNumbers')
                          .where('category', isEqualTo: 'hospital')
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return SingleChildScrollView(
                            child: Column(
                                children: snapshot.data.docs
                                    .map<Widget>((doc) => buildTiles(
                                          doc: doc,
                                        ))
                                    .toList()),
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildTiles({DocumentSnapshot doc}) {
    EmergencyModel emergency = EmergencyModel.get(doc);
    return Container(
      padding: EdgeInsets.all(3),
      child: Column(
        children: [
          Card(
            elevation: 3,
            child: ListTile(
              title: Text(emergency.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(emergency.subtitle, style: TextStyle(fontSize: 15)),
                Text(emergency.telNo, style: TextStyle(fontSize: 15)),
                Text(emergency.mobileNo, style: TextStyle(fontSize: 15))
              ]),
              trailing: InkWell(
                child: Icon(
                  Icons.call,
                  color: Colors.green,
                ),
                onTap: () {
                  String nums;
                  if (emergency.mobileNo.contains('No mobile number')) {
                    nums = emergency.telNo;
                  } else {
                    nums = emergency.mobileNo;
                  }
                  _launchURL(number: nums);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _launchURL({String number}) async {
    String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
