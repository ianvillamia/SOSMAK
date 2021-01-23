import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

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
  // double _width, _height;
  // String _setTime, _setDate;

  String _hour, _minute, _time;
  String dateTime;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime selectedDate = DateTime.now();

  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;

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
      _selectedCompany = selectedCompany;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('SOSMAK'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.all(12),
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
                  value: _selectedCompany,
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
              Row(
                children: [
                  Container(
                    width: 40,
                    child: button(
                      name: 'Save',
                      btncolor: Colors.blue,
                      color: Colors.white,
                      haveIcon: true,
                      icon: Icons.image,
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Container(
                    width: 40,
                    child: button(
                      name: 'Save',
                      btncolor: Colors.blue,
                      color: Colors.white,
                      haveIcon: true,
                      icon: Icons.photo_camera,
                      onPressed: () {},
                    ),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              button(
                name: 'Save',
                btncolor: Colors.blue,
                color: Colors.white,
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
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
          ? Icon(icon, color: Colors.white)
          : Text(name, style: TextStyle(color: color ?? Colors.black)),
    );
  }
}
