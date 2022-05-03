/*class MessagesModel {
  static final List<dynamic> messages = [];

  static updateMessages(dynamic message) async {
    messages.add(message);
  }
}*/
import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  ChatModel({
    required this.roomName,
    required this.socketId,
    required this.author,
    required this.time,
    required this.message,
  });

  String roomName;
  String socketId;
  String author;
  String time;
  String message;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        roomName: json["roomName"],
        socketId: json["socketId"],
        author: json["author"],
        message: json["message"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "roomName": roomName,
        "socketId": socketId,
        "author": author,
        "message": message,
        "time": time,
      };
}
