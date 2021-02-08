import 'package:SOSMAK/models/userModel.dart';
import 'package:flutter/material.dart';

class LearningProvider extends ChangeNotifier {
  void addLesson({@required UserModel lesson}) {
    //this.lessons.add(lesson);
    notifyListeners();
  }
}
