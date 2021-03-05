import 'package:flutter/material.dart';

class Alerts {
  static showAlertDialog(BuildContext context, {String title, String content}) {
    AlertDialog alert = AlertDialog(
      title: title != "" ? Text(title) : Container(),
      content: content != "" ? Text(content) : Container(),
      actions: [
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }
}
