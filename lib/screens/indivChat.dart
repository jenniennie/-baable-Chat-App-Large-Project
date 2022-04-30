import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:baable/models/chatMessageMod.dart';

import 'package:baable/models/userDataMod.dart';
// somethin
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class indivChat extends StatefulWidget {
  final String SenderId;

  const indivChat({
    Key? key,
    required this.SenderId,
  }) : super(key: key);

  @override
  singleChat createState() => singleChat();
}

class singleChat extends State<indivChat> {
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.SenderId),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}

  /*
  TextEditingController _messageController = new TextEditingController();
  ScrollController _controller = ScrollController();
  late IO.Socket socket;

  initSocket() async {
    print('Connecting to chat service');
    socket = IO.io('https://large21.herokuapp.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((_) {
      print('connected to websocket');
    });

    socket.on('newChat', (message) {
      print('newchat: $message');
      setState(() {
        MessagesModel.messages.add(message);
      });
    });

    socket.on('allChats', (messages) {
      print(messages);
      setState(() {
        MessagesModel.messages.addAll(messages);
      });
    });
  }

  void _sendMessage() {
    String messageText = _messageController.text.trim();
    _messageController.text = '';
    print('newchat: $messageText');
    socket.emit(
      "message",
      {
        "id": socket.id,
        "message": messageText,
        "username": widget.SenderId,
        "sentAt": DateTime.now().toLocal().toString().substring(0, 16),
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  @override
  void dispose() {
    _messageController.dispose();
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  CircleAvatar(
                    maxRadius: 20,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.SenderId,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.settings,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 60,
              width: 100, // tmp
              child: ListView.builder(
                controller: _controller,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                reverse: true,
                cacheExtent: 1000,
                itemCount: MessagesModel.messages.length,
                itemBuilder: (BuildContext context, int index) {
                  var message = MessagesModel
                      .messages[MessagesModel.messages.length - index - 1];
                  return (message['sender'] == widget.SenderId)
                      ? ChatBubble(
                          clipper:
                              ChatBubbleClipper1(type: BubbleType.sendBubble),
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          backGroundColor: Colors.yellow[100],
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: 100 * 0.7), // tmp
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('@${message['time']}',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10)),
                                Text('${message['message']}',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16))
                              ],
                            ),
                          ),
                        )
                      : ChatBubble(
                          clipper: ChatBubbleClipper1(
                              type: BubbleType.receiverBubble),
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          backGroundColor: Colors.grey[100],
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: 100 * 0.7), // tmp
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${message['sender']} @${message['time']}',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10)),
                                Text('${message['message']}',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16))
                              ],
                            ),
                          ),
                        );
                },
              ),
            ),
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
                        print('herhehrehrhehrh: ${_messageController.text}');
                        _sendMessage();
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                        controller: _messageController,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        _sendMessage();
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
*/