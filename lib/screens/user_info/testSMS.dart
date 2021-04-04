// import 'package:flutter/material.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';

// class MessagesTest extends StatefulWidget {
//   @override
//   _MessagesTestState createState() => _MessagesTestState();
// }

// class _MessagesTestState extends State<MessagesTest> {
//   TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     twilioFlutter = TwilioFlutter(
//         accountSid: 'AC74579140bd7586a399b7c1923ed4c0b2',
//         authToken: 'e9970cdbd608a45ff5b01c9a07525d58',
//         twilioNumber: '+14159156802');
//     super.initState();
//   }

//   void sendSms() async {
//     twilioFlutter.sendSMS(
//         toNumber: '+639102257080', messageBody: 'Hii everyone this is a demo of\nflutter twilio sms.');
//   }

//   void getSms() async {
//     var data = await twilioFlutter.getSmsList();
//     print(data);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text('TEST SMS'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Text(
//           'Press the button to send SMS.',
//           style: TextStyle(color: Colors.black, fontSize: 16),
//         ),
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             onPressed: getSms,
//             tooltip: 'Get Sms',
//             child: Icon(Icons.receipt),
//           ),
//           FloatingActionButton(
//             onPressed: sendSms,
//             tooltip: 'Send Sms',
//             child: Icon(Icons.send),
//           ),
//         ],
//       ),
//     );
//   }
// }
