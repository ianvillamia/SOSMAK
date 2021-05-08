import 'dart:io';

import 'package:SOSMAK/models/userModel.dart';
import 'package:SOSMAK/screens/user_profile/updateDetails_2.dart';
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

class UpdateUserProfile extends StatefulWidget {
  final UserModel user;
  UpdateUserProfile({@required this.user, Key key}) : super(key: key);

  @override
  _UpdateUserProfileState createState() => _UpdateUserProfileState();
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  Size size;
  User firebaseUser;
  int counter = 0;
  File _imageProfile;
  final picker = ImagePicker();
  List<String> genderList = ['Male', 'Female', 'Better not say'];
  String selectedGender;
  List<String> civilStatusList = ['Single', 'Married', 'Widowed', 'Divorced'];
  String selectedcivilStatus;
  List<String> relationList1 = ['Family', 'Loveone', 'Friend'];
  String selectedRelation1;
  List<String> relationList2 = ['Family', 'Loveone', 'Friend'];
  String selectedRelation2;
  List<String> relationList3 = ['Family', 'Loveone', 'Friend'];
  String selectedRelation3;
  List<String> bloodTypeList = ['A', 'B', 'AB', 'O'];
  String selectedBloodType;

  DateTime selectedDate = DateTime.now();
  TextEditingController firstNameController = TextEditingController(),
      lastNameController = TextEditingController(),
      addressController = TextEditingController(),
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
      emergencyPersonController1 = TextEditingController(),
      emergencyContactController1 = TextEditingController(),
      emergencyPersonController2 = TextEditingController(),
      emergencyContactController2 = TextEditingController(),
      emergencyPersonController3 = TextEditingController(),
      emergencyContactController3 = TextEditingController(),
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
      gender,
      address,
      civilStatus,
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
      contactPerson1,
      emergencyContact1,
      emerygencyRelation1,
      contactPerson2,
      emergencyContact2,
      emerygencyRelation2,
      contactPerson3,
      emergencyContact3,
      emerygencyRelation3,
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

  getContactPerson1(contact) {
    this.contactPerson1 = contact;
  }

  getEmergencyContact1(emergency) {
    this.emergencyContact1 = emergency;
  }

  getEmerygencyRelation1(rel) {
    this.emerygencyRelation1 = rel;
  }

  getContactPerson2(contact) {
    this.contactPerson2 = contact;
  }

  getEmergencyContact2(emergency) {
    this.emergencyContact2 = emergency;
  }

  getEmerygencyRelation2(rel) {
    this.emerygencyRelation2 = rel;
  }

  getContactPerson3(contact) {
    this.contactPerson3 = contact;
  }

  getEmergencyContact3(emergency) {
    this.emergencyContact3 = emergency;
  }

  getEmerygencyRelation3(rel) {
    this.emerygencyRelation3 = rel;
  }

  getProfileImage(pic) {
    this.profileImage = pic;
  }

  getGender(gender) {
    this.gender = gender;
  }

  getAddress(addr) {
    this.address = addr;
  }

  getCivilStatus(cs) {
    this.civilStatus = cs;
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

    selectedcivilStatus = widget.user.civilStatus.isEmpty ? 'Single' : widget.user.civilStatus;
    selectedGender = widget.user.gender;
    selectedRelation1 = widget.user.emergencyRelation1.isEmpty ? 'Family' : widget.user.emergencyRelation1;
    selectedRelation2 = widget.user.emergencyRelation2.isEmpty ? 'Family' : widget.user.emergencyRelation2;
    selectedRelation3 = widget.user.emergencyRelation3.isEmpty ? 'Family' : widget.user.emergencyRelation3;
    addressController.text = widget.user.address;
    birthdayController.text = widget.user.birthDate;
    birthPlaceController.text = widget.user.birthPlace;
    ageController.text = widget.user.age;
    heightController.text = widget.user.height;
    weightController.text = widget.user.weight;
    bloodTypeController.text = widget.user.bloodType;
    allergiesController.text = widget.user.allergies;
    languageController.text = widget.user.language;
    religionController.text = widget.user.religion;
    //1
    emergencyPersonController1.text = widget.user.emergencycontactPerson1;
    emergencyContactController1.text = widget.user.emergencyContactNo1.isEmpty
        ? widget.user.emergencyContactNo1
        : widget.user.emergencyContactNo1.substring(3);
    //2
    emergencyPersonController2.text = widget.user.emergencycontactPerson2;
    emergencyContactController2.text = widget.user.emergencyContactNo2.isEmpty
        ? widget.user.emergencyContactNo2
        : widget.user.emergencyContactNo2.substring(3);
    //3
    emergencyPersonController3.text = widget.user.emergencycontactPerson3;
    emergencyContactController3.text = widget.user.emergencyContactNo3.isEmpty
        ? widget.user.emergencyContactNo3
        : widget.user.emergencyContactNo3.substring(3);

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
                          textFormFeld(
                              width: size.width * 0.42,
                              controller: contactNoController,
                              label: 'Contact Number',
                              isNumber: true,
                              onChanged: (String myContact) => getContactNo(myContact)),
                          Container(
                            width: size.width * 0.42,
                            child: _showDropDownButton(
                              labelText: 'Gender',
                              value: selectedGender,
                              onChanged: (String gValue) {
                                getGender(gValue);
                                setState(() {
                                  selectedGender = gValue;
                                });
                              },
                              listData: genderList,
                            ),
                          ),
                        ]),
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
                              isDisabled: true,
                              isNumber: true,
                              onChanged: (String age) => getAge(age)),
                        ]),
                        textFormFeld(
                            width: size.width,
                            controller: addressController,
                            label: 'Address',
                            isNumber: false,
                            onChanged: (String addr) => getAddress(addr)),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          textFormFeld(
                              width: size.width * 0.42,
                              controller: birthPlaceController,
                              label: 'Birth Place',
                              isNumber: false,
                              onChanged: (String birthPlace) => getBirthPlace(birthPlace)),
                          Container(
                            width: size.width * 0.42,
                            child: _showDropDownButton(
                              labelText: 'Civil Status',
                              value: selectedcivilStatus,
                              onChanged: (String csValue) {
                                getCivilStatus(csValue);
                                setState(() {
                                  selectedcivilStatus = csValue;
                                });
                              },
                              listData: civilStatusList,
                            ),
                          ),
                        ]),
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
                            Container(
                              width: size.width * 0.2,
                              child: _showDropDownButton(
                                labelText: 'BloodType',
                                value: selectedBloodType,
                                onChanged: (String btValue) {
                                  getBloodType(bloodType);
                                  setState(() {
                                    selectedBloodType = btValue;
                                  });
                                },
                                listData: bloodTypeList,
                              ),
                            ),
                            textFormFeld(
                                width: size.width * 0.68,
                                controller: allergiesController,
                                label: 'Allergies',
                                isNumber: false,
                                onChanged: (String allergies) => getAllergies(allergies)),
                          ],
                        ),
                        //1
                        _buildEmergencyContactUpdate(
                          personController: emergencyPersonController1,
                          personOnChanged: (String contact) => getContactPerson1(contact),
                          dropdownOnChanged: (String relValue1) {
                            getEmerygencyRelation1(relValue1);
                            setState(() {
                              selectedRelation1 = relValue1;
                            });
                          },
                          selectedValue: selectedRelation1,
                          listData: relationList1,
                          contactNoController: emergencyContactController1,
                          contactNoOnChanged: (String emergency) => getEmergencyContact1(emergency),
                        ),
                        //2
                        _buildEmergencyContactUpdate(
                          personController: emergencyPersonController2,
                          personOnChanged: (String contact) => getContactPerson2(contact),
                          dropdownOnChanged: (String relValue2) {
                            getEmerygencyRelation2(relValue2);
                            setState(() {
                              selectedRelation2 = relValue2;
                            });
                          },
                          selectedValue: selectedRelation2,
                          listData: relationList2,
                          contactNoController: emergencyContactController2,
                          contactNoOnChanged: (String emergency) => getEmergencyContact2(emergency),
                        ),
                        //3
                        _buildEmergencyContactUpdate(
                          personController: emergencyPersonController3,
                          personOnChanged: (String contact) => getContactPerson3(contact),
                          dropdownOnChanged: (String relValue3) {
                            getEmerygencyRelation3(relValue3);
                            setState(() {
                              selectedRelation3 = relValue3;
                            });
                          },
                          selectedValue: selectedRelation3,
                          listData: relationList3,
                          contactNoController: emergencyContactController3,
                          contactNoOnChanged: (String emergency) => getEmergencyContact3(emergency),
                        ),
                        SizedBox(height: size.height * 0.03),
                        RaisedButton(
                          color: Colors.blue[400],
                          child: Text('Update', style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            // widget.user.firstName = firstNameController.text;
                            // widget.user.lastName = lastNameController.text;
                            widget.user.gender = selectedGender ?? '';
                            widget.user.birthDate = birthdayController.text;
                            widget.user.birthPlace = birthPlaceController.text;
                            widget.user.age = ageController.text;
                            widget.user.address = addressController.text;
                            widget.user.civilStatus = selectedcivilStatus ?? '';
                            widget.user.height = heightController.text;
                            widget.user.weight = weightController.text;
                            widget.user.bloodType = selectedBloodType ?? '';
                            widget.user.allergies = allergiesController.text;
                            widget.user.language = languageController.text;
                            widget.user.religion = religionController.text;
                            widget.user.contactNo = contactNoController.text;
                            widget.user.emergencycontactPerson1 = emergencyPersonController1.text;
                            widget.user.emergencyContactNo1 = emergencyContactController1.text;
                            widget.user.emergencyRelation1 = selectedRelation1;

                            widget.user.emergencycontactPerson2 = emergencyPersonController2.text;
                            widget.user.emergencyContactNo2 = emergencyContactController2.text;
                            widget.user.emergencyRelation2 = selectedRelation2;

                            widget.user.emergencycontactPerson3 = emergencyPersonController3.text;
                            widget.user.emergencyContactNo3 = emergencyContactController3.text;
                            widget.user.emergencyRelation3 = selectedRelation3;

                            //update here
                            // print(_user.currentUser.ref);

                            await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).update({
                              // 'firstName': widget.user.firstName,
                              // 'lastName': widget.user.lastName,
                              'gender': widget.user.gender ?? '',
                              'birthDate': widget.user.birthDate,
                              'birthPlace': widget.user.birthPlace,
                              'age': widget.user.age,
                              'address': widget.user.address,
                              'civilStatus': widget.user.civilStatus,
                              'height': widget.user.height,
                              'weight': widget.user.weight,
                              'bloodType': widget.user.bloodType,
                              'allergies': widget.user.allergies,
                              'language': widget.user.language,
                              'religion': widget.user.religion,
                              'contactNo': widget.user.contactNo,
                              'emergencycontactPerson1': widget.user.emergencycontactPerson1,
                              'emergencyContactNo1': "+63${widget.user.emergencyContactNo1}",
                              'emergencyRelation1': widget.user.emergencyRelation1,

                              'emergencycontactPerson2': widget.user.emergencycontactPerson2,
                              'emergencyContactNo2': "+63${widget.user.emergencyContactNo2}",
                              'emergencyRelation2': widget.user.emergencyRelation2,

                              'emergencycontactPerson3': widget.user.emergencycontactPerson3,
                              'emergencyContactNo3': "+63${widget.user.emergencyContactNo3}",
                              'emergencyRelation3': widget.user.emergencyRelation3,
                              'profileUrl': widget.user.profileUrl,
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
      bool isDisabled,
      int maxLength,
      onTap}) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: TextFormField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumber ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly] : null,
        controller: controller,
        textCapitalization: TextCapitalization.words,
        enabled: enable,
        maxLines: maxLines ?? 1,
        maxLength: maxLength ?? 100,
        onTap: onTap,

        // onChanged: onChanged,
        validator: (value) {
          if (value.length == 0) {
            return 'Should not be empty';
          }
          return null;
        },
        readOnly: isDisabled ?? false,
        decoration: InputDecoration(
          counterText: "",
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

  _showDropDownButton({
    @required String value,
    @required onChanged,
    @required List<String> listData,
    @required String labelText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Container(
        width: size.width,
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(8),
            hintText: labelText,
            labelText: labelText,
          ),

          value: value, //selectedGender,
          onChanged: onChanged,
          // (String gValue) {
          //   getGender(gValue);
          //   setState(() {
          //     selectedGender = gValue;
          //   });
          // },
          items: listData
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text("$value"),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  _buildEmergencyContactUpdate({
    @required TextEditingController personController,
    @required personOnChanged,
    @required dropdownOnChanged,
    @required String selectedValue,
    @required List<String> listData,
    @required TextEditingController contactNoController,
    @required contactNoOnChanged,
  }) {
    return Column(
      children: [
        textFormFeld(
            width: size.width,
            controller: personController,
            label: 'Emergency Person',
            isNumber: false,
            onChanged: personOnChanged), // (String contact) => getContactPerson(contact)),
        _showDropDownButton(
          labelText: 'Relation',
          value: selectedValue, //selectedRelation,
          onChanged: dropdownOnChanged,
          // (String relValue) {
          //   getEmerygencyRelation(relValue);
          //   setState(() {
          //     selectedRelation = relValue;
          //   });
          // },
          listData: listData, // relationList,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textFormFeld(
              width: size.width * 0.2,
              controller: null,
              label: '+63',
              isDisabled: true,
              onChanged: () {},
              isNumber: false,
            ),
            textFormFeld(
                width: size.width * 0.68,
                controller: contactNoController,
                label: 'Emergency Contact No.',
                maxLength: 10,
                isNumber: true,
                onChanged: contactNoOnChanged),
          ],
        )
      ],
    );
  }
}
