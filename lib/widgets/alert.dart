import 'package:flutter/material.dart';

class Alerts {
  static showAlertDialog(BuildContext context, {String title, String content}) {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: title != null ? Text(title) : Container(),
      content: content != null ? Text(content) : Container(),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
