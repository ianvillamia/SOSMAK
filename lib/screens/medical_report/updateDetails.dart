import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/screens/medical_report/updateDetails_2.dart';
import 'package:SOSMAK/services/authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  // setData(DocumentSnapshot doc) {
  //   UserModel user = UserModel.get(doc);
  // }

  DateTime selectedDate = DateTime.now();
  TextEditingController firstNameController = TextEditingController(),
      lastNameController = TextEditingController(),
      ageController = TextEditingController(),
      birthdayController = TextEditingController(),
      birthPlaceController = TextEditingController(),
      heightController = TextEditingController(),
      weightController = TextEditingController(),
      bloodTypeController = TextEditingController(),
      allergiesController = TextEditingController();

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate != null ? selectedDate : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
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
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: birthdayController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  String firstName,
      lastName,
      birthDate,
      birthPlace,
      bloodType,
      allergies,
      age,
      height,
      weight;
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
    print(counter);
  }

  @override
  Widget build(BuildContext context) {
    firebaseUser = context.watch<User>();

    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Medical Record'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                        SizedBox(
                          height: size.height * .03,
                        ),
                        // Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       textFormFeld(
                        //           width: size.width * 0.42,
                        //           controller: firstNameController,
                        //           label: 'First Name',
                        //           isNumber: false,
                        //           onChanged: (String firstName) =>
                        //               getFirstName(firstName)),
                        //       textFormFeld(
                        //           width: size.width * 0.42,
                        //           controller: lastNameController,
                        //           label: 'Last Name',
                        //           isNumber: false,
                        //           onChanged: (String lastName) =>
                        //               getLastName(lastName)),
                        //     ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: size.width * 0.42,
                                child: TextFormField(
                                  focusNode: AlwaysDisabledFocusNode(),
                                  controller: birthdayController,
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  onChanged: (String birthDay) =>
                                      getBirthDay(birthDay),
                                ),
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
                            controller: birthPlaceController,
                            label: 'Birth Place',
                            isNumber: false,
                            onChanged: (String birthPlace) =>
                                getBirthPlace(birthPlace)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              textFormFeld(
                                  width: size.width * 0.42,
                                  controller: heightController,
                                  label: 'Height (cm)',
                                  isNumber: true,
                                  onChanged: (String height) =>
                                      getHeight(height)),
                              textFormFeld(
                                  width: size.width * 0.42,
                                  controller: weightController,
                                  label: 'Weight (kg)',
                                  isNumber: true,
                                  onChanged: (String weight) =>
                                      getWeight(weight)),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              textFormFeld(
                                  width: size.width * 0.2,
                                  controller: bloodTypeController,
                                  label: 'Blood Type',
                                  isNumber: false,
                                  onChanged: (String bloodType) =>
                                      getBloodType(bloodType)),
                              textFormFeld(
                                  width: size.width * 0.68,
                                  controller: allergiesController,
                                  label: 'Allergies',
                                  isNumber: false,
                                  onChanged: (String allergies) =>
                                      getAllergies(allergies)),
                            ]),
                        SizedBox(height: size.height * 0.1),
                        RaisedButton(
                          color: Colors.blue[400],
                          child: Text('Update',
                              style: TextStyle(color: Colors.white)),
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

                            //update here
                            // print(_user.currentUser.ref);

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(firebaseUser.uid)
                                .update({
                              // 'firstName': widget.user.firstName,
                              // 'lastName': widget.user.lastName,
                              'birthDate': widget.user.birthDate,
                              'birthPlace': widget.user.birthPlace,
                              'age': widget.user.age,
                              'height': widget.user.height,
                              'weight': widget.user.weight,
                              'bloodType': widget.user.bloodType,
                              'allergies': widget.user.allergies
                            }).then((value) {
                              Navigator.pop(context);
                            });
                          },
                        )
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
        inputFormatters: isNumber
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : null,
        controller: controller,
        textCapitalization: TextCapitalization.words,
        enabled: enable,
        maxLines: maxLines ?? 1,
        onTap: onTap,
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
}
