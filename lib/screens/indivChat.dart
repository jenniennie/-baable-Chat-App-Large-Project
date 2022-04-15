import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class indivChat extends StatefulWidget {
  const indivChat({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  singleChat createState() => singleChat();
}

class singleChat extends State<indivChat> {
  final TextEditingController messageControl = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baable'),
        textTheme: TextTheme(
          headline6: TextStyle(
            // ???
            color: Colors.grey,
            fontSize: 24,
          ),
        ),
      ),
      drawer: Drawer(),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageControl,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 24),
                  StreamBuilder(
                    stream: _channel.stream,
                    builder: (context, snapshot) {
                      return Text(snapshot.hasData ? '${snapshot.data}' : '');
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.lightBlue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    if (messageControl.text.isNotEmpty) {
      _channel.sink.add(messageControl.text);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    messageControl.dispose();
    super.dispose();
  }
}
