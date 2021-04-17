import 'package:SOSMAK/models/wantedModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SpotAlert extends StatefulWidget {
  SpotAlert({Key key}) : super(key: key);

  @override
  _SpotAlertState createState() => _SpotAlertState();
}

class _SpotAlertState extends State<SpotAlert> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF93E9BE),
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Spot Alert'),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('wantedList').where('izSpotted', isEqualTo: true).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.size > 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        child: Wrap(
                          children: snapshot.data.docs.map<Widget>((doc) => _buildWantedCard(doc)).toList(),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text('No History of Incident Report yet'));
                }
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  _buildWantedCard(DocumentSnapshot doc) {
    Wanted wanted = Wanted.getData(doc: doc);
    return InkWell(
      onTap: () {
        showNotifyDialog(context, wanted: wanted);
      },
      child: Card(
        elevation: 5,
        child: Container(
          width: 150,
          height: 150,
          padding: const EdgeInsets.all(10),
          child: Image.network(
            wanted.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  showNotifyDialog(BuildContext context, {@required Wanted wanted}) {
    AlertDialog alert = AlertDialog(
        contentPadding: EdgeInsets.all(12),
        content: Container(
          width: size.width * .7,
          height: size.height * .3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date Reported: ${wanted.spottedDate}'),
              SizedBox(height: 10),
              Text('Description:'),
              Text(wanted.spottedDescription),
              SizedBox(height: 20),
              Text('Spotted By:'),
              Text('Citizen Name: ${wanted.spottedCitizenName}'),
              SizedBox(height: 40),
              Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  color: Colors.redAccent,
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            ],
          ),
        ));

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
