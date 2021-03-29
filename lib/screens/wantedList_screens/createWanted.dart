import 'package:SOSMAK/models/wantedModel.dart';
import 'package:SOSMAK/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateWanted extends StatefulWidget {
  @override
  _CreateWantedState createState() => _CreateWantedState();
}

class _CreateWantedState extends State<CreateWanted> {
  TextEditingController nameController = TextEditingController(),
      lastKnownAddressController = TextEditingController(),
      aliasController = TextEditingController(),
      contactController = TextEditingController(),
      criminalNumberController = TextEditingController(),
      descriptionController = TextEditingController(),
      rewardController = TextEditingController();
  File _image;
  final picker = ImagePicker();
  Size size;
  final _formKey = GlobalKey<FormState>();
  bool isHidden = false;
  List<String> levels = ['High Level Crime', 'Low Level Crime'];
  String selectedLevel;
  int crimeLevel;

  @override
  void initState() {
    super.initState();
    contactController.text = '0927 505 1518';
  }

  @override
  Widget build(BuildContext context) {
    contactController.text = '0927 505 1518';
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF93E9BE),
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('New Wanted Person'),
        actions: [
          IconButton(
            icon: Icon(Icons.info, size: 30),
            onPressed: () => showReminderDialog(),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                createAddImage(),
                textFormFeld(
                  width: size.width,
                  controller: nameController,
                  label: 'Name',
                ),
                textFormFeld(
                  width: size.width,
                  controller: aliasController,
                  label: 'Alias',
                ),
                textFormFeld(
                  width: size.width,
                  controller: criminalNumberController,
                  label: 'Criminal Case Number',
                ),
                _dropDownButton(),
                textFormFeld(
                  width: size.width,
                  controller: descriptionController,
                  label: 'Description',
                ),
                textFormFeld(
                  width: size.width,
                  controller: lastKnownAddressController,
                  label: 'Last Known Address',
                ),
                textFormFeld(width: size.width, controller: contactController, enable: false, label: 'Hotline'),
                textFormFeld(
                  width: size.width,
                  controller: rewardController,
                  label: 'Reward',
                ),
                RaisedButton(
                    color: Colors.redAccent,
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      //validate!
                      if (_formKey.currentState.validate()) {
                        if (_image != null) {
                          Wanted wanted = Wanted();
                          print(aliasController.text);
                          wanted.name = nameController.text;
                          wanted.alias = aliasController.text;
                          wanted.criminalCaseNumber = criminalNumberController.text;
                          wanted.description = descriptionController.text;
                          wanted.lastKnownAddress = lastKnownAddressController.text;
                          wanted.contactHotline = contactController.text;
                          wanted.crimeLevel = crimeLevel;
                          wanted.reward = rewardController.text;
                          wanted.isHidden = isHidden;

                          //service
                          UserService().addCriminalPoster(wanted: wanted, file: _image).then((value) {
                            //reset controllers
                            reset();
                            if (value == null) {
                              Navigator.pop(context);
                              showAlertDialog(title: 'Success!', content: "Wanted Person Added.");
                            } else {
                              //problem error
                              showAlertDialog(title: 'Error', content: "Please check your input.");
                            }
                          });
                        } else {
                          //problem error
                          showAlertDialog(title: 'Error', content: "Please add a Wanted Image.");
                        }
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog({String title, String content}) {
    // show the dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
      },
    );
  }

  showReminderDialog() {
    AlertDialog alert = AlertDialog(
        contentPadding: EdgeInsets.all(12),
        title: Text('Note', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        content: Container(
          width: size.width,
          height: size.height * .6,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text('High Level Crimes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                      '•	Rape\n•	Murder\n•	Terrorism\n•	Robbery\n•	Any Crime Abuse\n•	Cyber Crime\n•	High Class – Drug Lord\n•	Sexual Harassment\n•	Fraud\n•	Kidnapping'),
                ),
                SizedBox(height: 20),
                Text('Low Level Crimes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                      '•	Snatching\n•	Brawl\n•	Assault\n•	Low Class-Drug Users and Sellers\n•	Shoplifting\n•	Violent Crime\n•	Burglary'),
                ),
              ],
            ),
          ),
        ));

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  reset() {
    nameController.text = '';
    lastKnownAddressController.text = '';
    aliasController.text = '';
    descriptionController.text = '';
    contactController.text = '';
    criminalNumberController.text = '';
    rewardController.text = '';
  }

  textFormFeld(
      {@required TextEditingController controller,
      @required String label,
      @required width,
      int maxLines,
      bool enable}) {
    return Container(
      width: width,
      padding: EdgeInsets.only(top: 8, bottom: 8),
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

  _dropDownButton() {
    return Container(
      width: size.width,
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1),
          ),
          hintText: "Crime Level",
        ),
        validator: (value) {
          if (value == null) {
            return 'Please choose a crime level';
          }
          return null;
        },
        value: selectedLevel,
        onChanged: (String gValue) {
          setState(() {
            selectedLevel = gValue;
            if (selectedLevel == 'High Level Crime') {
              crimeLevel = 1;
            } else if (selectedLevel == 'Low Level Crime') {
              crimeLevel = 2;
            }
          });
        },
        items: levels
            .map(
              (value) => DropdownMenuItem(
                value: value,
                child: Text("$value"),
              ),
            )
            .toList(),
      ),
    );
  }

  createAddImage() {
    return Stack(children: [
      _image == null
          ? CircleAvatar(
              backgroundColor: Colors.red[400],
              radius: 70,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: Image.asset(
                    'assets/mugshot-criminal.jpg',
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
                  )))
          : ClipOval(
              child: Container(
                width: 150,
                height: 150,
                child: Image.file(
                  _image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
      Positioned(
        left: 100,
        top: 100,
        child: ClipOval(
          child: Material(
            color: Colors.grey[200],
            child: InkWell(
              child: SizedBox(width: 40, height: 40, child: Icon(Icons.photo_camera)),
              onTap: () => getImage(),
            ),
          ),
        ),
      )
    ]);
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        debugPrint('hey');
        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }
}
