import 'dart:io';

import 'package:SOSMAK/models/incidentmodel.dart';
import 'package:SOSMAK/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdateIncidentReport extends StatefulWidget {
  final DocumentSnapshot doc;
  final IncidentModel incident;
  UpdateIncidentReport({@required this.doc, @required this.incident});
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
              Row(
                children: [
                  Container(
                    width: 40,
                    child: button(
                      name: 'Gallery',
                      btncolor: Colors.blue,
                      color: Colors.white,
                      haveIcon: true,
                      icon: Icons.image,
                      onPressed: () {
                        getImagefromGallery();
                      },
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Container(
                    width: 40,
                    child: button(
                      name: 'Camera',
                      btncolor: Colors.blue,
                      color: Colors.white,
                      haveIcon: true,
                      icon: Icons.photo_camera,
                      onPressed: () {
                        getImagefromCamera();
                      },
                    ),
                  ),
                ],
              ),
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
          ? Icon(icon, color: Colors.white)
          : Text(name, style: TextStyle(color: color ?? Colors.black)),
    );
  }

  Future getImagefromGallery() async {
    final fileGallery = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (fileGallery != null) {
        image = File(fileGallery.path);

        debugPrint('hey');
        print(image);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImagefromCamera() async {
    var fileCamera = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (fileCamera != null) {
        image = File(fileCamera.path);

        debugPrint('hey');
        print(image);
      } else {
        print('No image selected.');
      }
    });
  }
}
