class MessagesModel {
  static final List<dynamic> messages = [];

  static updateMessages(dynamic message) async {
    messages.add(message);
  }
}
 /* final String? userId;
  final String? userName;

  final String? message;
  final String? time;

  MessagesModel({
    this.userId,
    this.userName,
    this.message,
    this.time,
  });

  factory MessagesModel.fromRawJson(Map<String, dynamic> jsonData) {
    return MessagesModel(
        userId: jsonData['userId'],
        userName: jsonData['userName'],
        message: jsonData['message'],
        time: jsonData['time']);
  }
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "userName": userName,
      "message": message,
      "time": time,
    };
  }
}
*/