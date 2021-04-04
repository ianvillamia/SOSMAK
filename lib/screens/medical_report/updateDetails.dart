import 'dart:io';

import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/screens/medical_report/updateDetails_2.dart';
import 'package:SOSMAK/services/authentication_service.dart';
import 'package:SOSMAK/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdateMedical extends StatefulWidget {
  final UserModel user;
  UpdateMedical({@required this.user, Key key}) : super(key: key);

  @override
  _UpdateMedicalState createState() => _UpdateMedicalState();
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _UpdateMedicalState extends State<UpdateMedical> {
  Size size;
  User firebaseUser;
  int counter = 0;
  File _imageProfile;
  final picker = ImagePicker();

  DateTime selectedDate = DateTime.now();
  TextEditingController firstNameController = TextEditingController(),
      lastNameController = TextEditingController(),
      ageController = TextEditingController(),
      birthdayController = TextEditingController(),
      birthPlaceController = TextEditingController(),
      heightController = TextEditingController(),
      weightController = TextEditingController(),
      bloodTypeController = TextEditingController(),
      allergiesController = TextEditingController(),
      languageController = TextEditingController(),
      religionController = TextEditingController(),
      contactNoController = TextEditingController(),
      contactPersonController = TextEditingController(),
      emergencyContactController = TextEditingController(),
      medicalController1 = TextEditingController(),
      medicalController2 = TextEditingController(),
      medicalController3 = TextEditingController(),
      medicalController4 = TextEditingController(),
      medicalController5 = TextEditingController(),
      profileImageController = TextEditingController();

  void _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate != null ? selectedDate : DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2022),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.blue[800],
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.blue[300],
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      selectedDate = newSelectedDate;
      birthdayController
        ..text = DateFormat.yMMMd().format(selectedDate)
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: birthdayController.text.length, affinity: TextAffinity.upstream));
      setState(() {
        age = calculateAge(selectedDate).toString();
        ageController.text = age;
      });
    }
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  String firstName,
      lastName,
      birthDate,
      birthPlace,
      bloodType,
      allergies,
      age,
      height,
      weight,
      language,
      religion,
      contactNo,
      contactPerson,
      emergencyContact,
      medCondition1,
      medCondition2,
      medCondition3,
      medCondition4,
      medCondition5,
      profileImage;
  // getFirstName(fname) {
  //   this.firstName = fname;
  // }

  // getLastName(lname) {
  //   this.lastName = lname;
  // }

  getAge(uAge) {
    this.age = uAge;
  }

  getBirthDay(bday) {
    this.birthDate = bday;
  }

  getBirthPlace(bplace) {
    this.birthPlace = bplace;
  }

  getHeight(tall) {
    this.height = tall;
  }

  getWeight(kg) {
    this.weight = kg;
  }

  getBloodType(btype) {
    this.bloodType = btype;
  }

  getAllergies(allergy) {
    this.allergies = allergy;
  }

  getLanguage(lang) {
    this.language = lang;
  }

  getReligion(rel) {
    this.religion = rel;
  }

  getContactNo(myContact) {
    this.contactNo = myContact;
  }

  getContactPerson(contact) {
    this.contactPerson = contact;
  }

  getEmergencyContact(emergency) {
    this.emergencyContact = emergency;
  }

  getMedical1(med1) {
    this.medCondition1 = med1;
  }

  getMedical2(med2) {
    this.medCondition2 = med2;
  }

  getMedical3(med3) {
    this.medCondition3 = med3;
  }

  getMedical4(med4) {
    this.medCondition4 = med4;
  }

  getMedical5(med5) {
    this.medCondition5 = med5;
  }

  getProfileImage(pic) {
    this.profileImage = pic;
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    // firstNameController.text = widget.user.firstName;
    // lastNameController.text = widget.user.lastName;
    birthdayController.text = widget.user.birthDate;
    birthPlaceController.text = widget.user.birthPlace;
    ageController.text = widget.user.age;
    heightController.text = widget.user.height;
    weightController.text = widget.user.weight;
    bloodTypeController.text = widget.user.bloodType;
    languageController.text = widget.user.language;
    religionController.text = widget.user.religion;
    contactPersonController.text = widget.user.contactPerson;
    emergencyContactController.text = widget.user.emergencyContact;

    medicalController1.text = widget.user.otherMedicalCondition1;
    medicalController2.text = widget.user.otherMedicalCondition2;
    medicalController3.text = widget.user.otherMedicalCondition3;
    medicalController4.text = widget.user.otherMedicalCondition4;
    medicalController5.text = widget.user.otherMedicalCondition5;

    print(counter);
  }

  @override
  Widget build(BuildContext context) {
    firebaseUser = context.watch<User>();

    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF93E9BE),
      appBar: AppBar(
        title: Text('Update User Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          RaisedButton(
            color: Colors.blue[400],
            child: Text('Update', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              // widget.user.firstName = firstNameController.text;
              // widget.user.lastName = lastNameController.text;

              widget.user.birthDate = birthdayController.text;
              widget.user.birthPlace = birthPlaceController.text;
              widget.user.age = ageController.text;
              widget.user.height = heightController.text;
              widget.user.weight = weightController.text;
              widget.user.bloodType = bloodTypeController.text;
              widget.user.allergies = allergiesController.text;
              widget.user.language = languageController.text;
              widget.user.religion = religionController.text;
              widget.user.contactNo = contactNoController.text;
              widget.user.contactPerson = contactPersonController.text;
              widget.user.emergencyContact = emergencyContactController.text;

              widget.user.otherMedicalCondition1 = medicalController1.text;
              widget.user.otherMedicalCondition2 = medicalController2.text;
              widget.user.otherMedicalCondition3 = medicalController3.text;
              widget.user.otherMedicalCondition4 = medicalController4.text;
              widget.user.otherMedicalCondition5 = medicalController5.text;

              //update here
              // print(_user.currentUser.ref);

              await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).update({
                // 'firstName': widget.user.firstName,
                // 'lastName': widget.user.lastName,
                'birthDate': widget.user.birthDate,
                'birthPlace': widget.user.birthPlace,
                'age': widget.user.age,
                'height': widget.user.height,
                'weight': widget.user.weight,
                'bloodType': widget.user.bloodType,
                'allergies': widget.user.allergies,
                'language': widget.user.language,
                'religion': widget.user.religion,
                'contactNo': widget.user.contactNo,
                'contactPerson': widget.user.contactPerson,
                'emergencyContact': widget.user.emergencyContact,
                'profileUrl': widget.user.profileUrl,
                'otherMedicalCondition1': widget.user.otherMedicalCondition1,
                'otherMedicalCondition2': widget.user.otherMedicalCondition2,
                'otherMedicalCondition3': widget.user.otherMedicalCondition3,
                'otherMedicalCondition4': widget.user.otherMedicalCondition4,
                'otherMedicalCondition5': widget.user.otherMedicalCondition5,
              }).then((value) {
                Navigator.pop(context);
              });
            },
          )
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: FutureBuilder<DocumentSnapshot>(
            future: AuthenticationService.getCurrentUser(firebaseUser.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // setData(snapshot.data);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .05),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: size.height * .01),
                        createProfileImage(),
                        SizedBox(height: size.height * .01),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Container(
                            width: size.width * 0.42,
                            child: TextFormField(
                                focusNode: AlwaysDisabledFocusNode(),
                                controller: birthdayController,
                                onTap: () {
                                  _selectDate(context);
                                },
                                onChanged: (String birthDay) => getBirthDay(birthDay),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: 'Birthdate',
                                  labelStyle: TextStyle(color: Colors.black),
                                )),
                          ),
                          textFormFeld(
                              width: size.width * 0.42,
                              controller: ageController,
                              label: 'Age',
                              isNumber: true,
                              onChanged: (String age) => getAge(age)),
                        ]),
                        textFormFeld(
                            width: size.width,
                            controller: contactNoController,
                            label: 'Contact Number',
                            isNumber: true,
                            onChanged: (String myContact) => getContactNo(myContact)),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          textFormFeld(
                              width: size.width * 0.42,
                              controller: languageController,
                              label: 'Language',
                              isNumber: false,
                              onChanged: (String lang) => getLanguage(lang)),
                          textFormFeld(
                              width: size.width * 0.42,
                              controller: religionController,
                              label: 'Religion',
                              isNumber: false,
                              onChanged: (String rel) => getReligion(rel)),
                        ]),
                        textFormFeld(
                            width: size.width,
                            controller: birthPlaceController,
                            label: 'Birth Place',
                            isNumber: false,
                            onChanged: (String birthPlace) => getBirthPlace(birthPlace)),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          textFormFeld(
                              width: size.width * 0.42,
                              controller: heightController,
                              label: 'Height (cm)',
                              isNumber: true,
                              onChanged: (String height) => getHeight(height)),
                          textFormFeld(
                              width: size.width * 0.42,
                              controller: weightController,
                              label: 'Weight (kg)',
                              isNumber: true,
                              onChanged: (String weight) => getWeight(weight)),
                        ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textFormFeld(
                                width: size.width * 0.2,
                                controller: bloodTypeController,
                                label: 'Blood Type',
                                isNumber: false,
                                onChanged: (String bloodType) => getBloodType(bloodType)),
                            textFormFeld(
                                width: size.width * 0.68,
                                controller: allergiesController,
                                label: 'Allergies',
                                isNumber: false,
                                onChanged: (String allergies) => getAllergies(allergies)),
                          ],
                        ),
                        textFormFeld(
                            width: size.width,
                            controller: contactPersonController,
                            label: 'Emergency Contact Person',
                            isNumber: false,
                            onChanged: (String contact) => getContactPerson(contact)),
                        textFormFeld(
                            width: size.width,
                            controller: emergencyContactController,
                            label: 'Emergency Contact No.',
                            isNumber: true,
                            onChanged: (String emergency) => getEmergencyContact(emergency)),
                        textFormFeld(
                            width: size.width,
                            controller: medicalController1,
                            label: 'Medical Condition 1',
                            isNumber: false,
                            onChanged: (String med1) => getMedical1(med1)),
                        textFormFeld(
                            width: size.width,
                            controller: medicalController2,
                            label: 'Medical Condition 2',
                            isNumber: false,
                            onChanged: (String med2) => getMedical2(med2)),
                        textFormFeld(
                            width: size.width,
                            controller: medicalController3,
                            label: 'Medical Condition 3',
                            isNumber: false,
                            onChanged: (String med3) => getMedical3(med3)),
                        textFormFeld(
                            width: size.width,
                            controller: medicalController4,
                            label: 'Medical Condition 4',
                            isNumber: false,
                            onChanged: (String med4) => getMedical4(med4)),
                        textFormFeld(
                            width: size.width,
                            controller: medicalController5,
                            label: 'Medical Condition 5',
                            isNumber: false,
                            onChanged: (String med5) => getMedical5(med5)),
                        SizedBox(height: size.height * 0.06),
                      ],
                    ),
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  textFormFeld(
      {@required controller,
      @required String label,
      @required width,
      @required onChanged,
      int maxLines,
      bool enable,
      bool isNumber,
      onTap}) {
    return Container(
      width: width,
      padding: EdgeInsets.only(top: 6, bottom: 6),
      child: TextFormField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumber ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly] : null,
        controller: controller,
        textCapitalization: TextCapitalization.words,
        enabled: enable,
        maxLines: maxLines ?? 1,
        onTap: onTap,
        // onChanged: onChanged,
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
          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black)),
          contentPadding: EdgeInsets.all(8),
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  button({@required String name, @required onPressed, Color btncolor, Color color, IconData icon, bool haveIcon}) {
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

  createProfileImage() {
    return Stack(children: [
      _imageProfile == null
          ? CircleAvatar(
              backgroundColor: Colors.green,
              radius: 70,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: Image.network(
                    widget.user.profileUrl,
                    fit: BoxFit.cover,
                    width: 130,
                    height: 130,
                  )))
          : CircleAvatar(
              backgroundColor: Colors.green,
              radius: 70,
              child: ClipOval(
                child: Container(
                  width: 130,
                  height: 130,
                  child: Image.file(
                    _imageProfile,
                    fit: BoxFit.cover,
                  ),
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
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    setState(() {
      if (pickedFile != null) {
        _imageProfile = File(pickedFile.path);
        uploadProfileImage(_imageProfile).then((value) async {
          String downUrl = await value.ref.getDownloadURL();
          widget.user.profileUrl = downUrl;
        });
        debugPrint('hey');
        print(_imageProfile);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadProfileImage(File file) async {
    // File file = File(filePath);
    DateTime date = DateTime.now();
    String fileName = date.toString();

    return await firebase_storage.FirebaseStorage.instance.ref('uploads/profileImages/$fileName.png').putFile(file);
  }
}
