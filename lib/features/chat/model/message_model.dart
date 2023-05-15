class Message {
  String message;
  DateTime date;
  bool join;
  String username;
  bool isLeave;
  Message({
    required this.message,
    required this.date,
    required this.username,
    required this.isLeave,
    this.join = false,
  });
}
