import 'package:SOSMAK/widgets/chatBottomNav.dart';
import 'package:flutter/material.dart';

class RecentChat extends StatefulWidget {
  RecentChat({Key key}) : super(key: key);

  @override
  _RecentChatState createState() => _RecentChatState();
}

class _RecentChatState extends State<RecentChat> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
