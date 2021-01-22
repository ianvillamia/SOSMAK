import 'package:flutter/material.dart';

class MedicalReport2 extends StatefulWidget {
  MedicalReport2({Key key}) : super(key: key);

  @override
  _MedicalReport2State createState() => _MedicalReport2State();
}

class _MedicalReport2State extends State<MedicalReport2> {
  bool isHIV = false;
  bool isTB = false;
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          width: size.width,
          height: size.height,
          child: Column(
            children: <Widget>[
              ListTile(
                title: const Text('FALSE'),
                leading: Radio(
                  value: false,
                  groupValue: isHIV,
                  onChanged: (value) {
                    setState(() {
                      isHIV = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('TRUE'),
                leading: Radio(
                  value: true,
                  groupValue: isHIV,
                  onChanged: (value) {
                    setState(() {
                      isHIV = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('isTB False'),
                leading: Radio(
                  value: false,
                  groupValue: isTB,
                  onChanged: (value) {
                    setState(() {
                      isTB = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('isTB TRUe'),
                leading: Radio(
                  value: true,
                  groupValue: isTB,
                  onChanged: (value) {
                    setState(() {
                      isTB = value;
                    });
                  },
                ),
              ),
              MaterialButton(
                onPressed: () {
                  print('isHIV' + isHIV.toString());
                  print('isTB:' + isTB.toString());
                },
                child: Text('ISHIV?'),
              )
            ],
          )),
    );
  }

  buildTile({@required bool value, @required groupValue}) {
    return ListTile(
      title: value == true ? Text('TRUE$groupValue') : Text('FALSE$groupValue'),
      leading: Radio(
        value: value,
        groupValue: groupValue,
        onChanged: (val) {
          setState(() {
            groupValue = val;
          });
        },
      ),
    );
  }
}
