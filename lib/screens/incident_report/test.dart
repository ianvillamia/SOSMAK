import 'package:SOSMAK/screens/incident_report/uploadImages.dart';
import 'package:SOSMAK/screens/incident_report/viewImages.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _globalKey,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Multiple Images'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.image),
                text: 'Images',
              ),
              Tab(
                icon: Icon(Icons.cloud_upload),
                text: "Upload Images",
              ),
            ],
            indicatorColor: Colors.red,
            indicatorWeight: 5.0,
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ViewImages(),
            UploadImages(
              globalKey: _globalKey,
            ),
          ],
        ),
      ),
    );
  }
}
