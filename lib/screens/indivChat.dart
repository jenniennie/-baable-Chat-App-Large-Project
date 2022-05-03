import 'package:baable/models/chatListMod.dart';
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
  late Socket socket;

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void getPrevMessages() async {
    var obj = {
      "recipient": widget.SenderId,
      "author": GlobalData.loginName,
    };
    var js = jsonEncoder.convert(obj);
    var jsonObject;
    var results;
    try {
      String url = 'https://large21.herokuapp.com/api/loadmessages';
      String ret = await getAPI.getJson(url, js);
      jsonObject = json.decode(ret);
      results = jsonObject["results"];
      for (var i = 0; i < results.length; i++) {
        setStateIfMounted(() {
          _messages.add(ChatModel(
              socketId: jsonObject["results[i]._id"],
              author: jsonObject["results[i].Author"],
              time: jsonObject["results[i].Timestamp"],
              message: jsonObject["results[i].message"],
              roomName: jsonObject["results[i].Recipient"]));
        });
      }
    } catch (e) {
      newMessageText = jsonObject["error"];
      print('new message $newMessageText');
    }
  }

  @override
  void initState() {
    try {
      print('connecting');
      socket = io("https://large21.herokuapp.com/", <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
      });
      getPrevMessages();
      socket.emit("join_room", widget.SenderId);
      socket.connect();

      socket.on('connect', (data) async {
        debugPrint('connected');
        print(socket.connected);
      });

      socket.on('receive_message', (data) {
        var message = ChatModel.fromJson(data);

        setStateIfMounted(() {
          _messages.add(message);
        });
      });
/*
      socket.on('send_message', (data) {
        var message = ChatModel.fromJson(data);
        setStateIfMounted(() {
          _messages.add(message);
        });
      });*/

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
                              "recipient": widget.SenderId,
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
                                        roomName: widget.SenderId,
                                        socketId: socket.id!,
                                        author: GlobalData.loginName,
                                        message: message,
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
