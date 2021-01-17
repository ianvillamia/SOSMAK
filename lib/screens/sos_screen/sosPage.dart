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
      children: [
        _buildTile(
            color: Colors.white,
            text: 'Police',
            image: 'assets/police-car.png'),
        _buildTile(
            color: Colors.white,
            text: 'Ambulance',
            image: 'assets/ambulance.png'),
        _buildTile(
            color: Colors.white,
            text: 'Fire Station',
            image: 'assets/fire-station.png'),
      ],
    );
  }

  _buildTile(
      {@required Color color, @required String text, @required String image}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: InkWell(
          splashColor: Colors.blue,
          onTap: () => _launchURL(),
          child: Container(
            width: size.width * .25,
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

  _launchURL() async {
    const url = 'tel:+639292052188';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
