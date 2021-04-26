import 'package:SOSMAK/screens/admin/dashboard/dataModel.dart';
import 'package:SOSMAK/screens/admin/dashboard/reportedCasesModel.dart/reportedCasesPie.dart';
import 'package:SOSMAK/screens/admin/dashboard/solved_cases/solvedCasesPie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  Size size;

  List<charts.Series<BarGraphModel, String>> _seriesBarData;
  List<BarGraphModel> mydata;
  _generateData(mydata) {
    _seriesBarData = List<charts.Series<BarGraphModel, String>>();
    _seriesBarData.add(
      charts.Series(
        domainFn: (BarGraphModel reported, _) => reported.valDescription,
        measureFn: (BarGraphModel reported, _) => reported.value,
        colorFn: (BarGraphModel reported, _) => charts.ColorUtil.fromDartColor(Color(int.parse(reported.valColor))),
        id: 'solved',
        data: mydata,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF93E9BE),
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildReportedCasesCard(),
            _buildSolvedCasesCard(),
          ],
        ),
      ),
    );
  }

  _buildReportedCasesCard() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('incidentReports').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        print(snapshot.connectionState);

        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return Column(
              children: [
                _buildCard(title: 'Reported Cases', data: '${snapshot.data.docs.length}'),
                SizedBox(height: 10),
                _buildBarChart(
                  collection: 'graphData',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportedIncidentReport(),
                      )),
                ),
              ],
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _buildSolvedCasesCard() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('incidentReports').where('status', isEqualTo: 2).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        print(snapshot.connectionState);

        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return Column(
              children: [
                _buildCard(title: 'Solved Cases', data: '${snapshot.data.docs.length}'),
                SizedBox(height: 10),
                _buildBarChart(
                    collection: 'solvedIncidentData',
                    onTap: () {
                      print('SOLVED SOLVED');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SolvedIncidentReport(),
                          ));
                    }),
              ],
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _buildCard({@required String title, @required String data}) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: size.height * 0.22,
        width: size.width * 0.42,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              data,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildBarChart({@required String collection, @required onTap}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collection).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          List<BarGraphModel> chartData = snapshot.data.docs.map((doc) => BarGraphModel.fromMap(doc.data())).toList();
          return Stack(
            children: [
              Card(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  height: size.height * 0.22,
                  width: size.width * 0.42,
                  child: _buildChart(context, chartData),
                ),
              ),
              Positioned.fill(
                child: new Material(
                  color: Colors.transparent,
                  child: new InkWell(
                    onTap: onTap,
                  ),
                ),
              )
            ],
          );
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<BarGraphModel> chartData) {
    mydata = chartData;
    _generateData(mydata);
    return Center(
      child: charts.BarChart(
        _seriesBarData,
        animate: false,
        animationDuration: Duration(seconds: 5),
        primaryMeasureAxis: new charts.NumericAxisSpec(renderSpec: new charts.NoneRenderSpec()),
        domainAxis: new charts.OrdinalAxisSpec(showAxisLine: true, renderSpec: new charts.NoneRenderSpec()),
        layoutConfig: new charts.LayoutConfig(
            leftMarginSpec: new charts.MarginSpec.fixedPixel(20),
            topMarginSpec: new charts.MarginSpec.fixedPixel(40),
            rightMarginSpec: new charts.MarginSpec.fixedPixel(20),
            bottomMarginSpec: new charts.MarginSpec.fixedPixel(40)),
      ),
    );
  }
}
