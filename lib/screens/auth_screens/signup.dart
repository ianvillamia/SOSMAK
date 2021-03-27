import 'package:SOSMAK/screens/auth_screens/login.dart';
import 'package:SOSMAK/screens/auth_screens/signup2.dart';
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
      firstNameController = TextEditingController(),
      addressController = TextEditingController(),
      lastNameController = TextEditingController(),
      genderController = TextEditingController(),
      birthdayController = TextEditingController(),
      ageController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Size size;
  final _formKey = GlobalKey<FormState>();
  File _imageProfile;
  final picker = ImagePicker();
  bool _isHidden = true;
  List<String> gender = ['Male', 'Female'];
  String selectedGender;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.5,
                      child: _buildTextFormField(controller: firstNameController, label: 'First Name'),
                    ),
                    Container(
                      width: size.width * 0.5,
                      child: _buildTextFormField(controller: lastNameController, label: 'Last Name'),
                    ),
                  ],
                ),
                _buildTextFormField(caps: false, controller: emailController, label: 'Email'),
                _buildTextFormField(controller: addressController, label: 'Address', maxLines: 2),
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
                        controller: ageController,
                        label: 'Age',
                      ),
                    ),
                  ],
                ),
                _dropDownButton(),
                _buildPasswordField(controller: passwordController, label: 'Password'),
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    MaterialButton(
                      elevation: 5,
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          if (_imageProfile != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpMedical(
                                  fNameController: firstNameController,
                                  lNameController: lastNameController,
                                  emailContoller: emailController,
                                  addressController: addressController,
                                  bdayController: birthdayController,
                                  ageController: ageController,
                                  gender: selectedGender,
                                  passwordController: passwordController,
                                  imageProfile: _imageProfile,
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
                      },
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
    bool isPassword,
    int maxLines,
    bool caps = true,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: TextFormField(
        textCapitalization: caps ? TextCapitalization.words : TextCapitalization.none,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter a value';
          }
          return null;
        },
        controller: controller,
        maxLines: maxLines ?? 1,
        obscureText: isPassword ?? false,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            alignLabelWithHint: true,
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  _buildPasswordField({TextEditingController controller, String label}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Password is required';
          }
          return null;
        },
        controller: controller,
        obscureText: _isHidden,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            suffixIcon: IconButton(
                onPressed: _toggleVisibility,
                icon: _isHidden ? Icon(Icons.visibility_off, size: 20) : Icon(Icons.visibility, size: 20))),
      ),
    );
  }

  _dropDownButton() {
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
            hintText: "Gender",
          ),
          validator: (value) {
            if (value == null) {
              return 'Please choose a gender';
            }
            return null;
          },
          value: selectedGender,
          onChanged: (String gValue) {
            setState(() {
              selectedGender = gValue;
            });
          },
          items: gender
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
          : ClipOval(
              child: Container(
                width: 150,
                height: 150,
                child: Image.file(
                  _imageProfile,
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
