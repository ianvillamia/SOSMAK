import 'package:SOSMAK/models/dashboardModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardModel dashboard;

  getDashboard(DocumentSnapshot doc) {
    DashboardModel dashboard = DashboardModel.get(doc);
    this.dashboard = dashboard;
    // notifyListeners();
  }
}
