import 'package:SOSMAK/models/emergencyModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SosNumbers extends StatefulWidget {
  final DocumentSnapshot doc;
  SosNumbers({this.doc});
  @override
  _SosNumbersState createState() => _SosNumbersState();
}

Size size;

class _SosNumbersState extends State<SosNumbers> {
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Container(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('emergencyNumbers')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Scrollbar(
                      child: SingleChildScrollView(
                        child: ListView(
                            shrinkWrap: true,
                            children: snapshot.data.docs
                                .map<Widget>((doc) => buildTiles(
                                      doc: doc,
                                    ))
                                .toList()),
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                })
            //
            ),
      ),
    );
  }

  buildTiles({DocumentSnapshot doc}) {
    EmergencyModel emergency = EmergencyModel.get(doc);
    return Container(
      child: Column(
        children: [
          Card(
            child: ListTile(
              title: Text(emergency.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
