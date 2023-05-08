class Message {
  String message;
  DateTime date;
  bool isMe;
  bool join;
  String username;

  Message(
      {required this.message,
      required this.date,
      required this.isMe,
      this.join = false,
      this.username = ""});
}
