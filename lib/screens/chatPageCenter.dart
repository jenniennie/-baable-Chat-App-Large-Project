import 'package:flutter/material.dart';
import 'package:baable/models/chatListMod.dart';
import 'package:baable/widgets/conversationList.dart';

class ChatPageCenter extends StatefulWidget {
  @override
  chatPageCenter createState() => chatPageCenter();
}

List<ChatUsers> chatUsers = [ChatUsers(SenderId: "Jane Russel")];

class chatPageCenter extends State<ChatPageCenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Baable"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ConversationList(
                  SenderId: chatUsers[index].SenderId,
                  Chat: chatUsers[index].Chat,
                );
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 214, 237, 255),
              ),
              child: Text('Drawer Header'), // do something
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/chat');
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                // view profile??
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
