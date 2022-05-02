import 'package:flutter/material.dart';
import 'package:baable/models/chatListMod.dart';
import 'package:baable/widgets/conversationList.dart';
import 'package:baable/models/userDataMod.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

List<ChatUsers> chatUsers = [ChatUsers(SenderId: "My Flock")];

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        backgroundColor: Colors.black,
        elevation: 0,
        title: Image.asset('assets/images/cloud.png', height: 32),
        centerTitle: true,

        /* title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/cloud.png',
              fit: BoxFit.contain,
              height: 32,
            ),
          ],
        ),
        //centerTitle: true,*/
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
            DrawerHeader(
              padding: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    //backgroundImage: NetworkImage(widget.imageUrl),
                    maxRadius: 50,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    GlobalData.firstName + " " + GlobalData.lastName,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 64, 155, 79),
              ),
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
                Navigator.pushNamed(context, '/profile');
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
