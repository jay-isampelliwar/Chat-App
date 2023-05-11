class Message {
  String message;
  DateTime date;
  bool join;
  String username;

  Message({
    required this.message,
    required this.date,
    required this.username,
    this.join = false,
  });
}
