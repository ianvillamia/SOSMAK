import 'dart:io';

import 'package:SOSMAK/models/incidentmodel.dart';
import 'package:SOSMAK/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class IncidentReport extends StatefulWidget {
  @override
  _IncidentReportState createState() => _IncidentReportState();
}

class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, 'Robbery'),
      Company(2, 'Snatching'),
      Company(3, 'Murder'),
      Company(4, 'Fire'),
      Company(5, 'Brawl'),
    ];
  }
}

class _IncidentReportState extends State<IncidentReport> {
  TextEditingController locationController = TextEditingController(),
      dateController = TextEditingController(),
      timeController = TextEditingController(),
      incidentController = TextEditingController(),
      descController = TextEditingController();
  Size size;
  final picker = ImagePicker();
  File image;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _hour, _minute, _time;
  String dateTime;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime selectedDate = DateTime.now();

  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedIncident;

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

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    super.initState();
  }

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedIncident = selectedCompany;
    });
  }

  List<Asset> images = List<Asset>();
  List<File> files = List<File>();
  Future<void> pickImages() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "SOSMAK",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    setState(() {
      images = resultList;
      getFileList();
    });
  }

  Future<File> getImageFileFromAsset(String path) async {
    final file = File(path);
    return file;
  }

  void getFileList() async {
    files.clear();
    for (int i = 0; i < images.length; i++) {
      var path2 =
          await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
      //var path = await images[i].filePath;
      print('asdasd $path2');
      var file = await getImageFileFromAsset(path2);
      print('asdasd $file');
      files.add(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('SOSMAK'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Incident Report',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                textFormFeld(
                  width: size.width,
                  controller: locationController,
                  label: 'Location',
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textFormFeld(
                        enable: false,
                        width: size.width * 0.6,
                        controller: dateController,
                        label: 'Date',
                      ),
                      button(
                          name: 'Set Date',
                          btncolor: Colors.white70,
                          onPressed: () => _selectDate(context)),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textFormFeld(
                        enable: false,
                        width: size.width * 0.6,
                        controller: timeController,
                        label: 'Time',
                      ),
                      button(
                          name: 'Set Time',
                          btncolor: Colors.white70,
                          onPressed: () => _selectTime(context)),
                    ]),
                Container(
                  width: size.width,
                  height: size.height * 0.085,
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text('Please select an Incident'),
                    value: _selectedIncident,
                    items: _dropdownMenuItems,
                    onChanged: onChangeDropdownItem,
                  ),
                ),
                textFormFeld(
                  maxLines: 5,
                  width: size.width,
                  controller: descController,
                  label: 'Description',
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: size.width * 0.3,
                    child: button(
                      name: 'Gallery',
                      btncolor: Colors.blue,
                      color: Colors.white,
                      haveIcon: true,
                      icon: Icons.image,
                      onPressed: pickImages,
                    ),
                  ),
                ),
                SizedBox(
                    height: 80.0,
                    width: size.width,
                    child: images == null
                        ? Container(
                            child: Text('none'),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: AssetThumb(
                                    height: 200,
                                    width: 200,
                                    asset: images[index],
                                  ),
                                ))),
                button(
                  name: 'Save',
                  btncolor: Colors.blue,
                  color: Colors.white,
                  onPressed: () {
                    print(images.toList());
                    // if (_formKey.currentState.validate()) {
                    //   IncidentModel incident = IncidentModel();
                    //   incident.location = locationController.text;
                    //   incident.date =
                    //       '${dateController.text}, ${timeController.text}';
                    //   incident.incident = _selectedIncident.name;
                    //   incident.desc = descController.text;

                    //   UserService()
                    //       .addIncidentReport(incident: incident, file: image)
                    //       .then((value) {
                    //     setState(() {
                    //       reset();
                    //     });

                    //     _scaffoldKey.currentState.showSnackBar(
                    //       SnackBar(
                    //         content: Text('Incident Reported Successfully'),
                    //       ),
                    //     );
                    //     // if (value == true) {
                    //     //   Alerts.showAlertDialog(context,
                    //     //       title: 'Created Successfully');
                    //     // } else {
                    //     //   //problem error
                    //     //   Alerts.showAlertDialog(context,
                    //     //       title: 'Problem with Create');
                    //     // }
                    //   });
                    // }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  reset() {
    locationController.text = '';
    dateController.text = '';
    timeController.text = '';
    _selectedIncident.name = '';
    descController.text = '';
    image = null;
  }

  textFormFeld(
      {@required TextEditingController controller,
      @required String label,
      @required width,
      int maxLines,
      bool enable}) {
    return Container(
      width: width,
      padding: EdgeInsets.only(top: 6, bottom: 6),
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        enabled: enable,
        maxLines: maxLines ?? 1,
        controller: controller,
        validator: (value) {
          if (value.length == 0) {
            return 'Should not be empty';
          }
          return null;
        },
        decoration: InputDecoration(
            alignLabelWithHint: true,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(8),
            labelText: label),
      ),
    );
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
                  'Add Images',
                  style: TextStyle(color: Colors.white),
                )
              ],
            )
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
