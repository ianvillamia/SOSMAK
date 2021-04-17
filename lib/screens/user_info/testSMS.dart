import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class MessagesTest extends StatefulWidget {
  @override
  _MessagesTestState createState() => _MessagesTestState();
}

class _MessagesTestState extends State<MessagesTest> {
  TwilioFlutter twilioFlutter;

  String accountSid = DotEnv.env['ACCOUNT_SID'];
  String authToken = DotEnv.env['AUTH_TOKEN'];
  String twilioNumber = DotEnv.env['TWILIO_NUMBER'];

  @override
  void initState() {
    print("SADASDASD $accountSid  $authToken  $twilioNumber");
    twilioFlutter = TwilioFlutter(
      accountSid: '$accountSid',
      authToken: '$authToken',
      twilioNumber: '$twilioNumber',
    );
    super.initState();
  }

  void sendSms() async {
    twilioFlutter.sendSMS(toNumber: '+639562354758', messageBody: "HELP ME! I'M IN TROUBLE, SEND SOME AUTHORITIES");
  }

  void getSms() async {
    var data = await twilioFlutter.getSmsList();
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    print("SADASDASD $accountSid  $authToken  $twilioNumber");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('TEST SMS'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Press the button to send SMS.',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: sendSms,
            tooltip: 'Send Sms',
            child: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
