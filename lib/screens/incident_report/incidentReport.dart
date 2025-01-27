import 'dart:io';
import 'package:SOSMAK/models/incidentmodel.dart';
import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/screens/incident_report/currentIncident.dart';
import 'package:SOSMAK/services/authentication_service.dart';
import 'package:SOSMAK/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class IncidentChecker {
  String ref;
  int status;
}

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
  List imageUrls = [];
  // ignore: unused_field
  String _error = 'No Error Dectected';
  User firebaseUser;
  Future checkCurrentReport(String uid) async {
    //get current user
    IncidentChecker incidentChecker = IncidentChecker();

    await AuthenticationService.getCurrentUser(uid).then((doc) async {
      UserModel user = UserModel.get(doc);
      String currentIncident = user.currentIncidentRef;
      incidentChecker.ref = currentIncident;

      if (currentIncident == '') {
        print('hey' + user.currentIncidentRef);
        print('no current report');
        incidentChecker.status = -1;
      } else {
        await UserService().getCurrentIncident(currentIncident).then((doc2) {
          IncidentModel incident = IncidentModel.get(doc2);
          incidentChecker.status = incident.status;
          print(incident.status);
          print(' current report');
        });
      }
      //if()
      //get status
      // if(currentIncident)
    });
    return incidentChecker;
  }

  @override
  Widget build(BuildContext context) {
    firebaseUser = context.watch<User>();
    size = MediaQuery.of(context).size;
    //check docu? here?

    return Scaffold(
        appBar: AppBar(
          title: Text('SOSMAK'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: FutureBuilder(
            future: checkCurrentReport(firebaseUser.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  print(snapshot.data.status);
                  IncidentChecker incident = snapshot.data;
                  bool showIncident = false;

                  if (incident.status == 0 ||
                      incident.status == 1 ||
                      incident.status == -1) {
                    showIncident = true;
                    //return Container();
                    return showIncident == true
                        ? CurrentIncident(
                            documentId: incident.ref,
                          )
                        : _buildIncidentForm();
                  } else {
                    return _buildIncidentForm();
                  }
                }
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  _buildIncidentForm() {
    return Form(
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                    name: 'Add Images',
                    btncolor: Colors.blue,
                    color: Colors.white,
                    haveIcon: true,
                    icon: Icons.image,
                    onPressed: loadAssets,
                  ),
                ),
              ),
              SizedBox(
                  height: 80.0,
                  width: size.width,
                  child: images.length == 0
                      ? Container(
                          child: Text('Please select images'),
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
                  if (images.length == 0 ||
                      locationController.text == '' ||
                      dateController.text == '' ||
                      timeController.text == '' ||
                      _selectedIncident.name == '' ||
                      descController.text == '') {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            content: Text(
                              "Missing data. Do not leave blanks.",
                            ),
                            actions: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 80,
                                  height: 30,
                                  color: Colors.blue,
                                  child: Center(
                                      child: Text(
                                    "Ok",
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              )
                            ],
                          );
                        });
                  } else {
                    SnackBar snackbar = SnackBar(
                        duration: const Duration(seconds: 2),
                        content:
                            Text('Please wait, we are sending your report'));
                    _scaffoldKey.currentState.showSnackBar(snackbar);

                    uploadIncident();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  reset() {
    locationController.text = '';
    dateController.text = '';
    timeController.text = '';
    _selectedIncident = null;
    descController.text = '';
    images = [];
    imageUrls = [];
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
                  name,
                  style: TextStyle(color: Colors.white),
                )
              ],
            )
          : Text(name, style: TextStyle(color: color ?? Colors.black)),
    );
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
      postImage(imageFile).then((downloadUrl) async {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          //String documnetID = DateTime.now().toString();
          IncidentModel incident = IncidentModel();
          incident.location = locationController.text;
          incident.date = '${dateController.text}, ${timeController.text}';
          incident.incident = _selectedIncident.name;
          incident.imageUrls = images;
          incident.status = 0;
          incident.desc = descController.text;
          incident.reporterRef = firebaseUser.uid;
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
