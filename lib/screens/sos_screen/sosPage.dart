import 'package:SOSMAK/models/emergencyModel.dart';
import 'package:SOSMAK/screens/sos_screen/sosNumbers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SOSPage extends StatefulWidget {
  SOSPage({Key key}) : super(key: key);

  @override
  _SOSPageState createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'TAP TO CALL',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            _buildTiles(),
            SizedBox(
              height: size.height * .05,
            ),
            MaterialButton(
              color: Colors.redAccent,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildTiles() {
    return Wrap(
      spacing: 5,
      children: [
        _buildTile(
          color: Colors.white,
          text: 'Police',
          image: 'assets/police-car.png',
          onTap: () => _launchURL(number: '12345'),
        ),
        _buildTile(
          color: Colors.white,
          text: 'Ambulance',
          image: 'assets/ambulance.png',
          onTap: () => _launchURL(number: '12345'),
        ),
        _buildTile(
          color: Colors.white,
          text: 'Fire Station',
          image: 'assets/fire-station.png',
          onTap: () => _launchURL(number: '12345'),
        ),
        _buildTile(
          color: Colors.white,
          text: 'Others',
          image: 'assets/more.png',
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SosNumbers())),
        ),
      ],
    );
  }

  _buildTile(
      {@required Color color,
      @required String text,
      @required String image,
      @required onTap}) {
    //     DocumentSnapshot doc,
    // EmergencyModel emergency = EmergencyModel.get(doc);
    // return StreamBuilder(
    //     stream: FirebaseFirestore.instance.collection('emergencyNumbers').snapshots(),
    //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(
    //           child: SizedBox(),
    //         );
    //       } else {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: InkWell(
          splashColor: Colors.blue,
          onTap: onTap,
          child: Container(
            width: size.width * .3,
            height: size.height * .2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(image),
                SizedBox(
                  height: 10,
                ),
                Text(
                  text,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
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
