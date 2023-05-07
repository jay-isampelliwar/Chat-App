import 'package:flutter/material.dart';
import 'package:socket_io_test/core/constant/app_color.dart';
import 'package:socket_io_test/core/constant/app_text_styles.dart';

import '../model/message_model.dart';

class Chat extends StatefulWidget {
  Chat({required this.name, required this.phone, super.key});
  String name;
  String phone;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: ListView.builder(
                itemBuilder: ((context, index) {
                  return Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            size.width * 0.1,
                          ),
                        ),
                      )
                    ],
                  );
                }),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            margin: EdgeInsets.symmetric(
                horizontal: size.width * 0.04, vertical: size.height * 0.01),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(
                size.width * 0.1,
              ),
            ),
            child: Align(
              child: TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: "message",
                  hintStyle: AppTextStyles.text20(
                    bold: false,
                    size: size,
                  ),
                  suffixIcon: Container(
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.send,
                        color: AppColor.secondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

List<Message> messages = [
  Message(
    message: "Hey there!",
    isMe: true,
    date: DateTime.now(),
  ),
  Message(
    message: "Hi back!",
    isMe: false,
    date: DateTime.now(),
  ),
  Message(
    message: "How are you?",
    isMe: true,
    date: DateTime.now(),
  ),
  Message(
    message: "I'm doing well, thanks for asking!",
    isMe: false,
    date: DateTime.now(),
  ),
  Message(
    message: "What have you been up to lately?",
    isMe: true,
    date: DateTime.now(),
  ),
  Message(
    message: "Just working, mostly. How about you?",
    isMe: false,
    date: DateTime.now(),
  ),
  Message(
    message: "Same here, just trying to stay busy.",
    isMe: true,
    date: DateTime.now(),
  ),
  Message(
    message: "Well, it sounds like you're doing a good job of that!",
    isMe: false,
    date: DateTime.now(),
  ),
];
