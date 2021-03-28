import 'package:SOSMAK/screens/chat_screens/chatList.dart';

import 'package:flutter/material.dart';

class ChatHome extends StatefulWidget {
  ChatHome({Key key}) : super(key: key);

  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF93E9BE),
      // bottomNavigationBar: ChatBottomNavigationBar(
      //   pageController: pageController,
      // ),
      body: Container(
          width: size.width,
          height: size.height,
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              ChatList()
              //, RecentChat()
            ],
          )),
    );
  }
}
