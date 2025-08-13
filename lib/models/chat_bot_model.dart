class ChatBotModel {
  String message;
  bool isMe;
  String timeStamp;

  ChatBotModel(
      {required this.message, required this.isMe, required this.timeStamp});

  ChatBotModel copyWith({String? message, String? timeStamp, bool? isMe}) {
    return ChatBotModel(
        message: message ?? this.message,
        isMe: isMe ?? this.isMe,
        timeStamp: timeStamp ?? this.timeStamp);
  }
}
