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
    required this.author,
    required this.time,
    required this.message,
  });

  String author;
  String time;
  String message;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        author: json["author"],
        time: json["time"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "author": author,
        "time": time,
        "message": message,
      };
}
