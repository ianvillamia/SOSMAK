import 'dart:io';

import 'package:SOSMAK/models/incidentmodel.dart';
import 'package:SOSMAK/screens/incident_report/incidentReport.dart';
import 'package:SOSMAK/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class UpdateIncidentReport extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final DocumentSnapshot doc;
  final IncidentModel incident;
  UpdateIncidentReport(
      {this.scaffoldKey, @required this.doc, @required this.incident});
  @override
  _UpdateIncidentReportState createState() => _UpdateIncidentReportState();
}

class _UpdateIncidentReportState extends State<UpdateIncidentReport> {
  TextEditingController locationController = TextEditingController(),
      dateController = TextEditingController(),
      timeController = TextEditingController(),
      incidentController = TextEditingController(),
      descController = TextEditingController();

  Size size;
  File image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  List<Asset> images = List<Asset>();
  List imageUrls = [];
  String _error = 'No Error Dectected';

  String location, date, time, incident, descripton;
  String _hour, _minute, _time;
  String dateTime;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        timeController.text = _time;
        timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  getLocation(loc) {
    this.location = loc;
  }

  getDate(dates) {
    this.date = dates;
  }

  getTime(times) {
    this.time = times;
  }

  getIncident(inc) {
    this.incident = inc;
  }

  getDesc(desc) {
    this.descripton = desc;
  }

  CollectionReference courses =
      FirebaseFirestore.instance.collection('incidentReport');
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Update Incident',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.05),
              textFormFeld(
                  width: size.width,
                  initiaLValue: widget.incident.location,
                  label: 'Location',
                  onChanged: (String location) => getLocation(location)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                addDateTime(
                    enabled: false,
                    title: 'Date',
                    controller: dateController,
                    onChanged: (String date) => getDate(date)),
                button(
                    name: 'Set Date',
                    btncolor: Colors.white,
                    onPressed: () => _selectDate(context)),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                addDateTime(
                    enabled: false,
                    title: 'Time',
                    controller: timeController,
                    onChanged: (String time) => getTime(time)),
                button(
                    name: 'Set Time',
                    btncolor: Colors.white,
                    onPressed: () => _selectTime(context)),
              ]),
              Container(
                width: size.width,
                height: size.height * 0.085,
                child: DropdownButton(
                  isExpanded: true,
                  hint: Text('Please select an Incident',
                      style: TextStyle(color: Colors.white)),
                  items: [
                    'Robbery',
                    'Snatching',
                    'Murder',
                    'Fire',
                    'Brawl',
                  ].map((option) {
                    return DropdownMenuItem(
                      child:
                          Text("$option", style: TextStyle(color: Colors.grey)),
                      value: option,
                    );
                  }).toList(),
                  value: widget.incident.incident,
                  onChanged: (String value) {
                    setState(() {
                      widget.incident.incident = value;
                      getIncident(value);
                    });
                  },
                ),
              ),
              textFormFeld(
                  maxLines: 5,
                  width: size.width,
                  initiaLValue: widget.incident.desc,
                  label: 'Description',
                  onChanged: (String description) => getDesc(description)),
              MaterialButton(
                color: Colors.white,
                elevation: 2,
                child: Text('Update Status'),
                onPressed: () {
                  UserService().updateIncident(
                      widget.doc, location, date, time, incident, descripton);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  textFormFeld(
      {@required String initiaLValue,
      @required String label,
      @required width,
      @required onChanged,
      int maxLines,
      bool enable}) {
    return Container(
      width: width,
      padding: EdgeInsets.only(top: 6, bottom: 6),
      child: TextFormField(
        initialValue: initiaLValue ?? '',
        textCapitalization: TextCapitalization.words,
        enabled: enable,
        maxLines: maxLines ?? 1,
        onChanged: onChanged,
        validator: (value) {
          if (value.length == 0) {
            return 'Should not be empty';
          }
          return null;
        },
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          alignLabelWithHint: true,
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black)),
          contentPadding: EdgeInsets.all(8),
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  addDateTime(
      {@required String title,
      @required controller,
      @required onChanged,
      bool enabled}) {
    return Container(
        width: size.width * 0.6,
        padding: EdgeInsets.only(top: 6, bottom: 6),
        child: TextFormField(
          enabled: enabled,
          controller: controller,
          validator: (value) {
            if (value.length == 0) {
              return 'Should not be empty';
            }
            return null;
          },
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            alignLabelWithHint: true,
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black)),
            contentPadding: EdgeInsets.all(8),
            labelText: title,
            labelStyle: TextStyle(color: Colors.black),
          ),
          onChanged: onChanged,
        ));
  }

  button(
      {@required String name,
      @required onPressed,
      Color btncolor,
      Color color,
      IconData icon,
      bool haveIcon}) {
    return RaisedButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      color: btncolor,
      child: haveIcon ?? false
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(icon, color: Colors.white),
                Text(
                  name,
                  style: TextStyle(color: Colors.white),
                )
              ],
            )
          : Text(name, style: TextStyle(color: color ?? Colors.black)),
    );
  }

  getImages({@required DocumentSnapshot doc}) {
    List images = doc.data()['imageUrls'];
    print(doc);
    if (images.length != 0) {
      return Container(
        width: size.width,
        height: size.height * .25,
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: images
                    ?.map<Widget>((doc) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: ('assets/loading.gif'),
                            image: doc.toString(),
                            width: 120,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ))
                    ?.toList() ??
                []),
      );
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      print(resultList.length);
      print((await resultList[0].getThumbByteData(122, 100)));
      print((await resultList[0].getByteData()));
      print((await resultList[0].metadata));
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
    setState(() {
      images = resultList;
      _error = error;
    });
  }

  void uploadIncident() {
    for (var imageFile in images) {
      postImage(imageFile).then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          //String documnetID = DateTime.now().toString();
          FirebaseFirestore.instance
              .collection('incidentReport')
              .doc(widget.incident.incident)
              .update({
            'location': locationController.text,
            'date': '${dateController.text}, ${timeController.text}',
            'incident': widget.incident.incident,
            'desc': descController.text,
            'imageUrls': imageUrls,
            'status': 0,
          }).then((_) {
            SnackBar snackbar =
                SnackBar(content: Text('Reported Successfully'));
            widget.scaffoldKey.currentState.showSnackBar(snackbar);
            setState(() {
              Navigator.pop(context);
            });
          });
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref('uploads/incidentImages/$fileName');
    UploadTask uploadTask =
        reference.putData((await imageFile.getByteData()).buffer.asUint8List());
    //TaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    print(imageUrl);
    return imageUrl;
  }
}
