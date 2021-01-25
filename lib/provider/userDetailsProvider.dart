import 'package:SOSMAK/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserDetailsProvider extends ChangeNotifier {
  UserModel currentUser;
  setCurrentUser(DocumentSnapshot doc) {
    UserModel _user = UserModel.get(doc);
    this.currentUser = _user;

    // notifyListeners();
  }
}
