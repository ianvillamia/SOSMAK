import 'package:flutter/material.dart';

class ChatBottomNavigationBar extends StatefulWidget {
  final PageController pageController;
  ChatBottomNavigationBar({@required this.pageController});

  @override
  _ChatBottomNavigationBarState createState() =>
      _ChatBottomNavigationBarState();
}

class _ChatBottomNavigationBarState extends State<ChatBottomNavigationBar> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.local_police),
          label: 'Police List',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Recent',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blueAccent,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
          widget.pageController.animateToPage(index,
              duration: Duration(milliseconds: 400), curve: Curves.easeIn);
        });
      },
    );
  }
}
