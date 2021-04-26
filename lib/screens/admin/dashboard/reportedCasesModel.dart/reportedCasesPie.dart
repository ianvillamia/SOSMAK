import 'package:SOSMAK/screens/admin/dashboard/dataModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ReportedIncidentReport extends StatefulWidget {
  @override
  _ReportedIncidentReportState createState() {
    return _ReportedIncidentReportState();
  }
}

class _ReportedIncidentReportState extends State<ReportedIncidentReport> {
  List<charts.Series<BarGraphModel, String>> _seriesBarData;
  List<BarGraphModel> mydata;
  _generateData(mydata) {
    _seriesBarData = List<charts.Series<BarGraphModel, String>>();
    _seriesBarData.add(
      charts.Series(
        domainFn: (BarGraphModel reported, _) => reported.valDescription,
        measureFn: (BarGraphModel reported, _) => reported.value,
        colorFn: (BarGraphModel reported, _) => charts.ColorUtil.fromDartColor(Color(int.parse(reported.valColor))),
        id: 'reported',
        data: mydata,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF93E9BE),
      appBar: AppBar(
        title: Text('Reported Incident Report'),
      ),
      body: Container(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('graphData').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          List<BarGraphModel> reported = snapshot.data.docs.map((doc) => BarGraphModel.fromMap(doc.data())).toList();
          return _buildChart(context, reported);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<BarGraphModel> reportedData) {
    mydata = reportedData;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Total Reported Incident Report',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLegendsRow(legendName: '1-Brawl', colors: 0xFFFF0000),
                      _buildLegendsRow(legendName: '2-Burglary', colors: 0xFFFFFF00),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLegendsRow(legendName: '3-Child Abuse', colors: 0xFFFFC0CB),
                      _buildLegendsRow(legendName: '4-Cyber Crime', colors: 0xFFADD8E6),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLegendsRow(legendName: '5-Domestic Abuse', colors: 0xFFFFA500),
                      _buildLegendsRow(legendName: '6-Fire', colors: 0xFF800080),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLegendsRow(legendName: '7-Fraud', colors: 0xFF4B0082),
                      _buildLegendsRow(legendName: '8-Murder', colors: 0xFF00FFBF),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLegendsRow(legendName: '9-Rape', colors: 0xFF9966CC),
                      _buildLegendsRow(legendName: '10-Robbery', colors: 0xFF7B5C00),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLegendsRow(legendName: '11-Sexual Harassment', colors: 0xFFCE2029),
                      _buildLegendsRow(legendName: '12-Snatching', colors: 0xFF006994),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLegendsRow(legendName: '13-Terrorism', colors: 0xFF9A2A2A),
                      _buildLegendsRow(legendName: '14-Vehicle Accident', colors: 0xFFBFFF00),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildLegendsRow(legendName: '15-Violent Crime', colors: 0xFFFFFDD0),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: charts.BarChart(
                  _seriesBarData,
                  animate: true,
                  animationDuration: Duration(seconds: 5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildLegendsRow({@required String legendName, @required int colors}) {
    return Container(
      width: 180,
      child: Row(
        children: [
          ClipOval(
            child: Container(
              height: 10,
              width: 10,
              color: Color(colors),
            ),
          ),
          SizedBox(width: 5),
          Text(legendName)
        ],
      ),
    );
  }
}
