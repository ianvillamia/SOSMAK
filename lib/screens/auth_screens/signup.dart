import 'package:SOSMAK/screens/auth_screens/login.dart';
import 'package:SOSMAK/screens/auth_screens/signup2.dart';
import 'package:SOSMAK/screens/auth_screens/signupTermsAndCondition.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Signup extends StatefulWidget {
  Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController(),
      confirmPasswordController = TextEditingController(),
      firstNameController = TextEditingController(),
      addressController = TextEditingController(),
      lastNameController = TextEditingController(),
      genderController = TextEditingController(),
      birthdayController = TextEditingController(),
      ageController = TextEditingController(),
      codeNoController = TextEditingController(),
      emergencyNameController1 = TextEditingController(),
      emergencyContactController1 = TextEditingController(),
      emergencyNameController2 = TextEditingController(),
      emergencyContactController2 = TextEditingController(),
      emergencyNameController3 = TextEditingController(),
      emergencyContactController3 = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Size size;
  final _formKey = GlobalKey<FormState>();
  File _imageProfile;
  final picker = ImagePicker();
  bool _isHidden = true;
  bool isChecked = false;
  List<String> genderList = ['Male', 'Female', 'Better not say'];
  String selectedGender;
  List<String> relationList1 = ['Family', 'Loveone', 'Friend'];
  String selectedRelation1;
  List<String> relationList2 = ['Family', 'Loveone', 'Friend'];
  String selectedRelation2;
  List<String> relationList3 = ['Family', 'Loveone', 'Friend'];
  String selectedRelation3;
  String age;
  var selectedYear;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ageController.text = age;
    codeNoController.text = '+63';
  }

  @override
  Widget build(BuildContext context) {
    ageController.text = age;
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.center,
                  child: createProfileImage(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Personal Information',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.5,
                      child:
                          _buildTextFormField(controller: firstNameController, isDisabled: true, label: 'First Name'),
                    ),
                    Container(
                      width: size.width * 0.5,
                      child: _buildTextFormField(controller: lastNameController, isDisabled: true, label: 'Last Name'),
                    ),
                  ],
                ),
                _buildTextFormField(caps: false, controller: emailController, isDisabled: true, label: 'Email'),
                _buildTextFormField(controller: addressController, isDisabled: true, label: 'Address', maxLines: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.5,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: TextFormField(
                        focusNode: AlwaysDisabledFocusNode(),
                        controller: birthdayController,
                        onTap: () {
                          _selectDate(context);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please select your Birthday';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            alignLabelWithHint: true,
                            labelText: 'Birthdate',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
                      ),
                    ),
                    Container(
                      width: size.width * 0.5,
                      child: _buildTextFormField(
                        isDisabled: false,
                        controller: ageController,
                        label: 'Age',
                      ),
                    ),
                  ],
                ),
                _buildDropDownButton(
                  hintText: 'Gender',
                  items: genderList,
                  value: selectedGender,
                  onChanged: (String gValue) {
                    setState(() {
                      selectedGender = gValue;
                    });
                  },
                ),
                _buildPasswordField(
                    controller1: passwordController,
                    controller2: confirmPasswordController,
                    label1: 'Password',
                    label2: 'Confirm Password'),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Emergency Contact Detail',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                //First Emergency Contact
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'First Contact Person',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildTextFormField(controller: emergencyNameController1, isDisabled: true, label: 'Full Name'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.23,
                      child: _buildTextFormField(
                          controller: codeNoController, isNumber: true, isDisabled: false, label: ''),
                    ),
                    Container(
                      width: size.width * 0.77,
                      child: _buildTextFormField(
                          isNumber: true,
                          controller: emergencyContactController1,
                          isDisabled: true,
                          label: 'Contact Number'),
                    )
                  ],
                ),
                _buildDropDownButton(
                  hintText: 'Relationship',
                  items: relationList1,
                  value: selectedRelation1,
                  onChanged: (String rValue1) {
                    setState(() {
                      selectedRelation1 = rValue1;
                    });
                  },
                ),
                //Second Emergency Contact
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Second Contact Person',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildTextFormField(controller: emergencyNameController2, isDisabled: true, label: 'Full Name'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.23,
                      child: _buildTextFormField(
                          controller: codeNoController, isNumber: true, isDisabled: false, label: ''),
                    ),
                    Container(
                      width: size.width * 0.77,
                      child: _buildTextFormField(
                          isNumber: true,
                          controller: emergencyContactController2,
                          isDisabled: true,
                          label: 'Contact Number'),
                    )
                  ],
                ),
                _buildDropDownButton(
                  hintText: 'Relationship',
                  items: relationList2,
                  value: selectedRelation2,
                  onChanged: (String rValue2) {
                    setState(() {
                      selectedRelation2 = rValue2;
                    });
                  },
                ),
                //Third Emergency Contact
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Third Contact Person',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildTextFormField(controller: emergencyNameController3, isDisabled: true, label: 'Full Name'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.23,
                      child: _buildTextFormField(
                          controller: codeNoController, isNumber: true, isDisabled: false, label: ''),
                    ),
                    Container(
                      width: size.width * 0.77,
                      child: _buildTextFormField(
                          isNumber: true,
                          controller: emergencyContactController3,
                          isDisabled: true,
                          label: 'Contact Number'),
                    )
                  ],
                ),
                _buildDropDownButton(
                  hintText: 'Relationship',
                  items: relationList3,
                  value: selectedRelation3,
                  onChanged: (String rValue3) {
                    setState(() {
                      selectedRelation3 = rValue3;
                    });
                  },
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return Login();
                            }));
                          },
                          child: Text('Already Got an Account? Click here to login'))),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Checkbox(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          value: isChecked,
                          checkColor: Colors.green,
                          activeColor: Colors.grey[300],
                          onChanged: (bool value) {
                            setState(() {
                              isChecked = value;
                            });
                          },
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: 'I agree to the ',
                              ),
                              TextSpan(
                                  text: 'Terms and conditions and Privacy Provisions',
                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SignUpTermsAndCondition(),
                                          ));
                                    }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    MaterialButton(
                      elevation: 5,
                      color: Colors.blueAccent,
                      disabledColor: Colors.grey,
                      textColor: Colors.white,
                      onPressed: isChecked
                          ? () {
                              if (_formKey.currentState.validate()) {
                                if (_imageProfile != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUpSecondPage(
                                        fNameController: firstNameController,
                                        lNameController: lastNameController,
                                        emailContoller: emailController,
                                        addressController: addressController,
                                        bdayController: birthdayController,
                                        ageController: ageController,
                                        gender: selectedGender ?? '',
                                        passwordController: passwordController,
                                        imageProfile: _imageProfile,
                                        emergencyNameController1: emergencyNameController1,
                                        emergencyContactController1: emergencyContactController1,
                                        emergencyRelation1: selectedRelation1,
                                        emergencyNameController2: emergencyNameController2,
                                        emergencyContactController2: emergencyContactController2,
                                        emergencyRelation2: selectedRelation2,
                                        emergencyNameController3: emergencyNameController3,
                                        emergencyContactController3: emergencyContactController3,
                                        emergencyRelation3: selectedRelation3,
                                      ),
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Something went wrong"),
                                        content: Text("Please take a profile picture."),
                                      );
                                    },
                                  );
                                }
                              }

                              //.signIn(email: email.text.trim(), password: password.text.trim());
                            }
                          : null,
                      // () {
                      //   print("1" + firstNameController.text);
                      //   print("2" + lastNameController.text);
                      //   print("3" + emailController.text);
                      //   print("4" + addressController.text);
                      //   print("5" + birthdayController.text);
                      //   print("6" + ageController.text);
                      //   print(selectedGender);
                      //   print("8" + passwordController.text);
                      //   print("9" + emergencyNameController1.text);
                      //   print("10" + emergencyContactController1.text);
                      //   print(selectedRelation1);
                      //   print("12" + emergencyNameController2.text);
                      //   print("13" + emergencyContactController2.text);
                      //   print(selectedRelation2);
                      //   print("15" + emergencyNameController3.text);
                      //   print("16" + emergencyContactController3.text);
                      //   print(selectedRelation3);
                      // },

                      child: Text('Next'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildTextFormField({
    TextEditingController controller,
    String label,
    int maxLines,
    bool caps = true,
    bool isNumber = false,
    bool isDisabled,
    int maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: TextFormField(
        textCapitalization: caps ? TextCapitalization.words : TextCapitalization.none,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter a value';
          }
          return null;
        },
        enabled: isDisabled,
        controller: controller,
        maxLines: maxLines ?? 1,
        maxLength: isNumber ? 10 : 100,
        decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.all(10),
            alignLabelWithHint: true,
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  _buildPasswordField(
      {TextEditingController controller1, TextEditingController controller2, String label1, String label2}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
            controller: controller1,
            obscureText: _isHidden,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                labelText: label1,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                suffixIcon: IconButton(
                    onPressed: _toggleVisibility,
                    icon: _isHidden ? Icon(Icons.visibility_off, size: 20) : Icon(Icons.visibility, size: 20))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: TextFormField(
            validator: (val) {
              if (val != passwordController.text || val == null) {
                return "Password don't match!";
              }
              return null;
            },
            controller: controller2,
            obscureText: _isHidden,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                labelText: label2,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                suffixIcon: IconButton(
                    onPressed: _toggleVisibility,
                    icon: _isHidden ? Icon(Icons.visibility_off, size: 20) : Icon(Icons.visibility, size: 20))),
          ),
        ),
      ],
    );
  }

  _buildDropDownButton(
      {@required String hintText, @required String value, @required List<String> items, @required onChanged}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Container(
        width: size.width,
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(30.0),
              ),
            ),
            hintText: hintText,
          ),
          value: value,
          onChanged: onChanged,
          items: items
              .map(
                (val) => DropdownMenuItem(
                  value: val,
                  child: Text("$val"),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  createProfileImage() {
    return Stack(children: [
      _imageProfile == null
          ? CircleAvatar(
              backgroundColor: Colors.black,
              radius: 70,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: Image.asset(
                    'assets/citizen.png',
                    fit: BoxFit.cover,
                    width: 130,
                    height: 130,
                  )))
          : CircleAvatar(
              backgroundColor: Colors.black,
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
              onTap: () => getProfileImage(),
            ),
          ),
        ),
      )
    ]);
  }

  Future getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    setState(() {
      if (pickedFile != null) {
        _imageProfile = File(pickedFile.path);

        debugPrint('hey');
        print(_imageProfile);
      } else {
        print('No image selected.');
      }
    });
  }
}
