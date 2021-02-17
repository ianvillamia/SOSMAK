import 'package:SOSMAK/models/incidentmodel.dart';
import 'package:SOSMAK/screens/incident_report/currentIncident.dart';
import 'package:SOSMAK/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

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

  TextEditingController locationController = TextEditingController(),
      descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isButtonDisabled = true;
  bool newIncident = false;
  bool showFab = false;
  //controllers

  @override
  void initState() {
    super.initState();

    //get current user\
    currentIncidentRef = widget.currentIncidentDoc;
    if (widget.currentIncidentDoc == '' || widget.currentIncidentDoc == null) {
      doesIncidentExist = true;
    }
    print(widget.userRef);
    print(doesIncidentExist);
    print(widget.currentIncidentDoc);
    check();
  }

  check() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('incidentReports')
        .doc(currentIncidentRef)
        .get();
    if (doc.exists) {
      //see first if document exists
    }
    IncidentModel incident = IncidentModel.get(doc);

    print(incident.status);
    if (incident.status == 2) {
      setState(() {
        showFab = true;
        //doesIncidentExist = true;
      });
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    //fetch status
    check();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    //  print(currentIncident);
    return Scaffold(
        floatingActionButton: showFab
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    newIncident = true;
                  });
                },
                child: Icon(Icons.add),
              )
            : Container(),
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
            ? _buildLoading()
            : newIncident == true
                ? _buildForm()
                : doesIncidentExist
                    ? _buildForm()
                    : CurrentIncident(
                        documentId: currentIncidentRef,
                      ));
  }

  _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text('Please wait..'),
        ],
      ),
    );
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
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text('Incident Report',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 20),
                _buildTextFormField(
                    label: 'Location', controller: locationController),
                SizedBox(height: 10),
                Text('Please select an Incident'),
                _dropDownButton(),
                SizedBox(height: 10),
                Text('Tell us what Happened'),
                _buildTextFormField(
                    label: 'Description',
                    maxLines: 4,
                    controller: descriptionController),
                SizedBox(
                  height: 5,
                ),
                _imagePicker(),
                _imagePreviews(),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _submitButton(),
                )
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
    return Container(
      width: size.width,
      child: TextFormField(
          textCapitalization: TextCapitalization.sentences,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          maxLines: maxLines ?? 1,
          controller: controller,
          decoration: InputDecoration(
              alignLabelWithHint: true,
              labelText: label,
              border: OutlineInputBorder())),
    );
  }

  _dropDownButton() {
    return Container(
      width: size.width,
      height: size.height * 0.085,
      child: DropdownButton<String>(
        isExpanded: true,
        value: dropdownValue,
        icon: Icon(Icons.keyboard_arrow_down),
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
    if (this.images.length == 0) {
      return Container(
        child: Text('Images are required. Please select images'),
      );
    } else {
      return Container(
        width: size.width,
        height: size.height * .18,
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: images.map<Widget>((image) {
              Asset asset = image;
              return Padding(
                padding: EdgeInsets.all(8),
                child: AssetThumb(
                  asset: asset,
                  width: 300,
                  height: 300,
                ),
              );
            }).toList()),
      );
    }
  }

  //
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    // ignore: unused_local_variable
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
                Future.delayed(Duration(seconds: 3), () {
                  setState(() {
                    isLoading = false;
                    currentIncidentRef = doc;
                  });
                  Navigator.pop(context);
                });
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
