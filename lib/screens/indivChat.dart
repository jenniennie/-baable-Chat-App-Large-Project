import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:baable/models/chatMessageMod.dart';
import 'package:baable/models/userDataMod.dart';
import 'package:baable/utils/getAPI.dart';
import 'dart:convert';

class indivChat extends StatefulWidget {
  final String SenderId;

  const indivChat({
    Key? key,
    required this.SenderId,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<indivChat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatModel> _messages = [];
  final bool _showSpinner = false;
  final bool _showVisibleWidget = false;
  final bool _showErrorIcon = false;
  final jsonEncoder = JsonEncoder();
  String newMessageText = '';

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  late Socket socket;

  @override
  void initState() {
    try {
      print('connecting');
      socket = io("https://large21.herokuapp.com/", <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
      });

      socket.connect();

      socket.on('connect', (data) async {
        debugPrint('connected');
        print(socket.connected);
        var obj = {
          "socketid": socket.id!,
        };
        var js = jsonEncoder.convert(obj);
        var jsonObject;
        var results;
        try {
          String url = 'https://large21.herokuapp.com/api/loadmessages';
          String ret = await getAPI.getJson(url, js);
          jsonObject = json.decode(ret);
          results = jsonObject["results"];
          print(results.length);
          for (var i = 0; i < results.length; i++) {
            setStateIfMounted(() {
              _messages.add(results[i]);
            });
          }
        } catch (e) {
          newMessageText = jsonObject["error"];
          print('new message $newMessageText');
        }
      });

      socket.on('receive_message', (data) {
        var message = ChatModel.fromJson(data);
        setStateIfMounted(() {
          _messages.add(message);
        });
      });

      socket.on('send_message', (data) {
        var message = ChatModel.fromJson(data);
        setStateIfMounted(() {
          _messages.add(message);
        });
      });

      socket.onDisconnect((_) => debugPrint('disconnect'));
    } catch (e) {
      print(e);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(widget.SenderId),
          backgroundColor: Color.fromARGB(255, 0, 0, 0)),
      body: SafeArea(
        child: Container(
          color: Color.fromARGB(255, 63, 63, 63),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    reverse: _messages.isEmpty ? false : true,
                    itemCount: 1,
                    shrinkWrap: false,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 3),
                        child: Column(
                          mainAxisAlignment: _messages.isEmpty
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: _messages.map((message) {
                                  return ChatBubble(
                                    date: message.time,
                                    message: message.message,
                                    isMe:
                                        message.author == GlobalData.loginName,
                                  );
                                }).toList()),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                    bottom: 10, left: 20, right: 10, top: 5),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          minLines: 1,
                          maxLines: 5,
                          controller: _messageController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration.collapsed(
                            hintText: "Type a message",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 43,
                      width: 42,
                      child: FloatingActionButton(
                        backgroundColor: Color.fromARGB(255, 64, 155, 79),
                        onPressed: () async {
                          String message = _messageController.text.trim();
                          if (_messageController.text.trim().isNotEmpty) {
                            var obj = {
                              "message": message,
                              "author": GlobalData.loginName,
                              "timestamp": DateTime.now()
                                  .toLocal()
                                  .toString()
                                  .substring(0, 16),
                              "socketid": socket.id!,
                            };
                            var js = jsonEncoder.convert(obj);
                            var jsonObject;

                            try {
                              String url =
                                  'https://large21.herokuapp.com/api/savemessage';
                              String ret = await getAPI.getJson(url, js);
                              jsonObject = json.decode(ret);
                            } catch (e) {
                              newMessageText = jsonObject["error"];
                              print('new message $newMessageText');
                            }

                            socket.emit(
                                "send_message",
                                ChatModel(
                                        message: message,
                                        author: GlobalData.loginName,
                                        time: DateTime.now()
                                            .toLocal()
                                            .toString()
                                            .substring(0, 16))
                                    .toJson());

                            _messageController.clear();
                          }
                        },
                        mini: true,
                        child: Transform.rotate(
                            angle: 0,
                            child: const Icon(Icons.send,
                                size: 20, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// add sender
class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final String date;

  ChatBubble({
    required this.message,
    this.isMe = true,
    required this.date,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            constraints: BoxConstraints(maxWidth: size.width * .5),
            decoration: BoxDecoration(
              color: isMe
                  ? Color.fromARGB(255, 0, 0, 0)
                  : Color.fromARGB(255, 64, 155, 79),
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topRight: Radius.circular(11),
                      topLeft: Radius.circular(11),
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(11),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(11),
                      topLeft: Radius.circular(11),
                      bottomRight: Radius.circular(11),
                      bottomLeft: Radius.circular(0),
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  message,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontSize: 14),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(
                      date,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 190, 190, 190),
                          fontSize: 9),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
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
*/
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