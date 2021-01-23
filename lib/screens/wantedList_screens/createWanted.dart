import 'package:flutter/material.dart';

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
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('New Wanted Person'),
      ),
      body: Container(
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
                controller: aliasController,
                label: 'Last Known Address',
              ),
              textFormFeld(
                width: size.width,
                controller: aliasController,
                label: 'Hotline Number',
              ),
              textFormFeld(
                width: size.width,
                controller: aliasController,
                label: 'Reward',
              ),
              RaisedButton(
                color: Colors.redAccent,
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
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

  createAddImage() {
    return Stack(children: [
      CircleAvatar(
        radius: 70,
        child: Image.network(
            'https://firebasestorage.googleapis.com/v0/b/sosmak-82380.appspot.com/o/police.png?alt=media&token=998171c7-a096-4442-9908-15bf9047b977'),
      ),
      Positioned(
        left: 95,
        top: 95,
        child: ClipOval(
          child: Material(
            color: Colors.grey[200],
            child: InkWell(
              child: SizedBox(
                  width: 42, height: 42, child: Icon(Icons.photo_camera)),
              onTap: () {},
            ),
          ),
        ),
      )
    ]);
  }
}
