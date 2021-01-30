import 'package:SOSMAK/models/incidentmodel.dart';
import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:SOSMAK/screens/incident_report/currentIncident.dart';
import 'package:SOSMAK/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/src/provider.dart';

class IncidentReportV2 extends StatefulWidget {
  final String userRef;
  final String currentIncidentDoc;
  IncidentReportV2({@required this.userRef, @required this.currentIncidentDoc});

  @override
  _IncidentReportV2State createState() => _IncidentReportV2State();
}

class _IncidentReportV2State extends State<IncidentReportV2> {
  String currentIncidentRef;
  bool doesIncidentExist = false;
  Size size;
  String dropdownValue = 'Robbery';
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  TextEditingController locationController = TextEditingController(),
      descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isButtonDisabled = true;
  //controllers

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //get current user\
    currentIncidentRef = widget.currentIncidentDoc;
    if (widget.currentIncidentDoc == '' || widget.currentIncidentDoc == null) {
      doesIncidentExist = true;
    }

    print(doesIncidentExist);
    print(widget.currentIncidentDoc);
    check();
  }

  check() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('incidentReports')
        .doc(currentIncidentRef)
        .get();
    IncidentModel incident = IncidentModel.get(doc);
    print(incident.status);
    if (incident.status == 2) {
      setState(() {
        doesIncidentExist = true;
      });
    }
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    //fetch status
    check();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    //  print(currentIncident);
    return Scaffold(
        appBar: AppBar(
          title: Text('Incident Report'),
          leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : doesIncidentExist
                ? _buildForm()
                : CurrentIncident(
                    documentId: currentIncidentRef,
                  ));
  }

  _buildForm() {
    //this will be the form for the thing
    return Form(
      key: _formKey,
      child: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Incident Report'),
                _buildTextFormField(
                    label: 'Location', controller: locationController),
                SizedBox(
                  height: 10,
                ),
                Text('Select an Incident'),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: _dropDownButton(),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Tell us what Happend'),
                SizedBox(
                  height: 5,
                ),
                _buildTextFormField(
                    label: 'Description',
                    maxLines: 4,
                    controller: descriptionController),
                SizedBox(
                  height: 5,
                ),
                _imagePreviews(),
                _imagePicker(),
                Text('Images are required'),
                SizedBox(
                  height: 10,
                ),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildTextFormField(
      {@required String label,
      TextEditingController controller,
      int maxLines}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          maxLines: maxLines ?? 1,
          controller: controller,
          decoration:
              InputDecoration(labelText: label, border: OutlineInputBorder())),
    );
  }

  _dropDownButton() {
    return Container(
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.redAccent),
        underline: Container(
          height: 2,
          color: Colors.redAccent,
        ),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: <String>['Robbery', 'Snatching', 'Murder', 'Fire', 'Brawl']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  _imagePicker() {
    return Container(
        width: size.width * .35,
        child: MaterialButton(
          elevation: 5,
          color: Colors.blueAccent,
          onPressed: loadAssets,
          //image picker
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Images',
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.image,
                color: Colors.white,
              )
            ],
          ),
        ));
  }

  _imagePreviews() {
    if (this.images.length != 0) {
      return Container(
        width: size.width * .5,
        height: size.height * .1,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: images.map<Widget>((image) {
              Asset asset = image;
              return AssetThumb(
                asset: asset,
                width: 500,
                height: 600,
              );
            }).toList()),
      );
    } else {
      return Container(
        color: Colors.blue,
      );
    }
  }

  //
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#eb5952",
          actionBarTitle: "Pick Image of Incident",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
      _error = error;
      // print(images);
    });
  }

  _submitButton() {
    return Container(
      width: size.width * .75,
      child: MaterialButton(
        elevation: 5,
        onPressed: () async {
          // validate
          if (_formKey.currentState.validate()) {
            //print
            IncidentModel incident = IncidentModel();
            DateTime currentDate = DateTime.now();
            incident.date = currentDate.month.toString() +
                "/" +
                currentDate.day.toString() +
                "/" +
                currentDate.year.toString(); // MM//DD//YYYY
            incident.desc = descriptionController.text;
            incident.incident = dropdownValue;
            incident.location = locationController.text;
            incident.status = 0;
            incident.reporterRef = widget.userRef;
            //
            setState(() {
              isLoading = true;
            });
            if (images.length != 0) {
              await UserService()
                  .postIncident(incident: incident, images: images)
                  .then((doc) async {
                setState(() {
                  isLoading = false;
                  currentIncidentRef = doc;
                });
                Navigator.pop(context);
              });
            } else {
              showAlertDialog(context);
              setState(() {
                isLoading = false;
              });
            }
          }
        },
        child: Text(
          'Submit Report',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.redAccent,
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text("You must Add an Image to your report"),
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
