import 'package:SOSMAK/models/incidentmodel.dart';
import 'package:SOSMAK/provider/userDetailsProvider.dart';
import 'package:SOSMAK/screens/admin/incidentReportsAdmin/getPDF.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:typed_data';
import 'package:flutter/services.dart' show NetworkAssetBundle, rootBundle;
import 'package:syncfusion_flutter_pdf/pdf.dart';

class IncidentReportBottomSheet extends StatefulWidget {
  final UserDetailsProvider userDetailsProvider;
  final DocumentSnapshot doc;
  final IncidentModel incident;
  final BuildContext context;
  IncidentReportBottomSheet(
      {@required this.userDetailsProvider, @required this.doc, @required this.incident, @required this.context});

  @override
  _IncidentReportBottomSheetState createState() => _IncidentReportBottomSheetState();
}

class _IncidentReportBottomSheetState extends State<IncidentReportBottomSheet> {
  PageController _pageController;
  bool showDispatch = true;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future fetchStr() async {
    await Future.delayed(const Duration(seconds: 20), () {
      _createPDF();
    });
    Navigator.pop(context);
  }

  Size size;
  @override
  Widget build(BuildContext context) {
    if (widget.incident.status != 0) {
      showDispatch = false;
    }
    size = MediaQuery.of(context).size;
    return Container(
      color: Colors.grey[900],
      height: size.height * .7,
      child: Column(
        children: [
          Stack(children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: size.height * .8,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height * 0.1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Incident:',
                                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  buildChip(text: widget.incident.incident),
                                ],
                              ),
                              buildText(title: 'Date: ', data: widget.incident.date)
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          buildText(title: 'Location: ', data: widget.incident.location),
                          SizedBox(
                            height: 10,
                          ),
                          buildText(title: 'Description: ', data: widget.incident.desc),
                          SizedBox(
                            height: 10,
                          ),
                          buildText(title: 'Image/s: ', data: '${widget.doc.data()['images'].length}'),
                          getImages(doc: widget.doc),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(alignment: Alignment.topLeft, child: buildStatus()),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                color: Colors.white,
                elevation: 2,
                child: Text('Update Status'),
                onPressed: () {
                  if (widget.userDetailsProvider.currentUser.role == 'police') {
                    _showMaterialDialog(itemList: ['Pending', 'In Progress']);
                  }
                  if (widget.userDetailsProvider.currentUser.role == 'admin') {
                    _showMaterialDialog(itemList: ['In Progress', 'Solved']);
                  }
                },
              ),
              (widget.incident.status == 2) ? SizedBox(width: 20) : Container(),
              (widget.incident.status == 2)
                  ? MaterialButton(
                      color: Colors.white,
                      elevation: 2,
                      child: Text('Generate PDF'),
                      onPressed: () => _onLoading(context),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  void _onLoading(BuildContext context) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.white,
                child: FutureBuilder(
                  future: fetchStr(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Container(color: Colors.white, child: Text("Generating your PDF...")),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Container(color: Colors.white, child: Text("Complete!")),
                        ],
                      );
                    }
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    PdfGraphicsState state = page.graphics.save();

    page.graphics.setTransparency(0.2);

    page.graphics.drawImage(PdfBitmap(await _getLogo('watermarkLogo.png')), Rect.fromLTWH(60, 200, 400, 400));

    page.graphics.restore(state);

    page.graphics.drawString('SOSMAK Incident Report Generation', PdfStandardFont(PdfFontFamily.helvetica, 30));

    //page.graphics.drawImage(PdfBitmap(await _getLogo('sosmakLogo.png')), Rect.fromLTWH(100, 20, 300, 300));

    page.graphics
        .drawString('Date:', PdfStandardFont(PdfFontFamily.helvetica, 22), bounds: Rect.fromLTWH(0, 100, 0, 0));
    page.graphics.drawString('${widget.incident.date}', PdfStandardFont(PdfFontFamily.helvetica, 22),
        bounds: Rect.fromLTWH(150, 100, 0, 0));

    page.graphics
        .drawString('Incident:', PdfStandardFont(PdfFontFamily.helvetica, 22), bounds: Rect.fromLTWH(0, 140, 0, 0));
    page.graphics.drawString('${widget.incident.incident}', PdfStandardFont(PdfFontFamily.helvetica, 22),
        bounds: Rect.fromLTWH(150, 140, 0, 0));

    page.graphics
        .drawString('Location:', PdfStandardFont(PdfFontFamily.helvetica, 22), bounds: Rect.fromLTWH(0, 180, 0, 0));
    PdfTextElement locationText =
        PdfTextElement(text: '${widget.incident.location}', font: PdfStandardFont(PdfFontFamily.helvetica, 22));
    locationText.draw(
        page: page, bounds: Rect.fromLTWH(0, 220, page.getClientSize().width, page.getClientSize().height));

    page.graphics
        .drawString('Description:', PdfStandardFont(PdfFontFamily.helvetica, 22), bounds: Rect.fromLTWH(0, 280, 0, 0));
    PdfTextElement descriptionText =
        PdfTextElement(text: '${widget.incident.desc}', font: PdfStandardFont(PdfFontFamily.helvetica, 22));
    descriptionText.draw(
        page: page, bounds: Rect.fromLTWH(0, 320, page.getClientSize().width, page.getClientSize().height));

    page.graphics.drawString(
        'Image/s: ${widget.doc.data()['images'].length}', PdfStandardFont(PdfFontFamily.helvetica, 22),
        bounds: Rect.fromLTWH(0, 380, 0, 0));

    List images = widget.doc.data()['images'];

    if (widget.doc.data()['images'].length > 0) {
      page.graphics.drawImage(PdfBitmap(await _getImageUrls(images[0])), Rect.fromLTWH(0, 410, 150, 180));
    }
    if (widget.doc.data()['images'].length > 1) {
      page.graphics.drawImage(PdfBitmap(await _getImageUrls(images[1])), Rect.fromLTWH(170, 410, 150, 180));
    }
    if (widget.doc.data()['images'].length > 2) {
      page.graphics.drawImage(PdfBitmap(await _getImageUrls(images[2])), Rect.fromLTWH(350, 410, 150, 180));
    }

    List<int> bytes = document.save();
    document.dispose();

    saveAndLaunchFile(bytes, 'Incident Report.pdf');
  }

  Future<Uint8List> _getLogo(String name) async {
    final data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<Uint8List> _getImageUrls(String image) async {
    final data = (await NetworkAssetBundle(Uri.parse('$image')).load('$image')).buffer.asUint8List();
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  _showMaterialDialog({@required List<String> itemList}) {
    String selected;
    int status;
    showDialog(
        context: context,
        builder: (_) {
          if (widget.incident.status == 0) {
            selected = 'Pending';
          } else if (widget.incident.status == 1) {
            selected = 'In Progress';
          } else if (widget.incident.status == 2) {
            selected = 'Solved';
          }
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Update Status'),
              content: Container(
                width: size.width,
                height: size.height * 0.085,
                child: DropdownButton(
                  isExpanded: true,
                  items: itemList.map((option) {
                    return DropdownMenuItem(
                      child: Text("$option"),
                      value: option,
                    );
                  }).toList(),
                  value: selected,
                  onChanged: (String value) {
                    setState(() {
                      selected = value;
                    });
                  },
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Save'),
                  onPressed: () {
                    if (selected == 'Pending') {
                      status = 0;
                    } else if (selected == 'In Progress') {
                      status = 1;
                    } else if (selected == 'Solved') {
                      status = 2;
                    }
                    changeStatus(status, widget.doc);
                    print('Status Changed');
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
        });
  }

  changeStatus(int status, DocumentSnapshot doc) {
    CollectionReference incidentReport = FirebaseFirestore.instance.collection('incidentReports');
    return incidentReport.doc(doc.id).update({'status': status});
  }

  buildText({@required String title, @required String data}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
        Flexible(child: Text(data, style: TextStyle(color: Colors.white, fontSize: 17)))
      ],
    );
  }

  buildChip({@required String text}) {
    Color color = Colors.red;
    switch (text.toLowerCase()) {
      case 'murder':
        color = Colors.red;

        break;
      default:
        color = Colors.grey;
    }
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: color),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  buildStatus() {
    if (widget.incident.status == 0) {
      return Padding(
        padding: const EdgeInsets.all(13.0),
        child: Text('Pending', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      );
    } else if (widget.incident.status == 1) {
      return Padding(
        padding: const EdgeInsets.all(13.0),
        child: Text('In Progress', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      );
    } else if (widget.incident.status == 2) {
      return Padding(
        padding: const EdgeInsets.all(13.0),
        child: Text('Solved', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      );
    }
  }

  getImages({@required DocumentSnapshot doc}) {
    List images = doc.data()['images'];
    print(doc);
    if (images.length != 0) {
      return Container(
        width: size.width,
        height: size.height * .25,
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: images
                    ?.map<Widget>((doc) => InkWell(
                          onTap: () {
                            showImageDialog(doc.toString());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FadeInImage.assetNetwork(
                              placeholder: ('assets/loading.gif'),
                              image: doc.toString(),
                              width: 120,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ))
                    ?.toList() ??
                []),
      );
    }
  }

  showImageDialog(String image) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                content: Container(width: size.width * 0.9, height: size.height * 0.5, child: Image.network(image)),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }
}
