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
      rewardController = TextEditingController();
  File _image;
  final picker = ImagePicker();
  Size size;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('New Wanted Person'),
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
                  controller: lastKnownAddressController,
                  label: 'Last Known Address',
                ),
                textFormFeld(
                  width: size.width,
                  controller: criminalNumberController,
                  label: 'Criminal Case Number',
                ),
                textFormFeld(
                    width: size.width,
                    controller: null,
                    enable: false,
                    label: 'Hotline',
                    initialValue: '887-1798'),
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
                        Wanted wanted = Wanted();
                        wanted.alias = aliasController.text;
                        wanted.contactHotline = '887-1798';
                        wanted.criminalCaseNumber =
                            criminalNumberController.text;
                        wanted.lastKnownAddress =
                            lastKnownAddressController.text;
                        wanted.name = nameController.text;
                        wanted.reward = rewardController.text;

                        //service
                        UserService()
                            .addCriminalPoster(wanted: wanted, file: _image)
                            .then((value) {
                          //reset controllers
                          reset();
                          Navigator.pop(context);
                          if (value == true) {
                            showAlertDialog(
                                title: 'Success!',
                                content: "Wanted Person Added.");
                          } else {
                            //problem error
                            showAlertDialog(
                                title: 'Error',
                                content: "Please check your input.");
                          }
                        });
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

  reset() {
    nameController.text = '';
    lastKnownAddressController.text = '';
    aliasController.text = '';
    contactController.text = '';
    criminalNumberController.text = '';
    rewardController.text = '';
  }

  textFormFeld(
      {@required TextEditingController controller,
      @required String label,
      @required width,
      String initialValue,
      int maxLines,
      bool enable}) {
    return Container(
      width: width,
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: TextFormField(
        initialValue: initialValue,
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
              child: SizedBox(
                  width: 40, height: 40, child: Icon(Icons.photo_camera)),
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
