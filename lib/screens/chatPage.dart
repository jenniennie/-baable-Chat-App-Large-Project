import 'package:flutter/material.dart';
import 'package:baable/models/chatListMod.dart';

import 'package:baable/screens/chatPageCenter.dart';
import 'package:baable/screens/contactPageCenter.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUsers> chatUsers = [
    ChatUsers(SenderId: "SenderId"),
  ];

  List<Widget> _pages = [ChatPageCenter(), contactPageCenter()];
  int selectedPage = 0;

  void initState() {
    super.initState();
    selectedPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Contacts',
          ),
        ],
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        },
        selectedItemColor: Colors.red, // COLOR CHANGEQ11!@RWEOHIFAO;IEW
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
