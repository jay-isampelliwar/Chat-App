import 'package:flutter/material.dart';
import 'package:socket_io_test/core/constant/app_color.dart';
import 'package:socket_io_test/core/constant/app_text_styles.dart';
import 'package:socket_io_test/features/chat/bloc/chat_bloc.dart';
import 'package:socket_io_test/locator.dart';
import '../../../core/constant/app_helper.dart';
import '../model/message_model.dart';

class Chat extends StatefulWidget {
  Chat({required this.name, required this.phone, super.key});
  String name;
  String phone;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    locator.get<ChatBloc>().add(InitialChatSocketIOConnectionEvent());
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool flag = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Group Chat",
          style: AppTextStyles.text24(bold: true, size: size),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: ((context, index) {
                  Message cur = messages[index];
                  String message = cur.message;
                  bool isMe = cur.isMe;
                  DateTime date = cur.date;
                  return Row(
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: cur.join
                            ? Center(
                                child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.2,
                                        vertical: size.height * 0.01),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.03,
                                        vertical: size.height * 0.006),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade200,
                                      borderRadius: BorderRadius.circular(
                                        size.width * 0.01,
                                      ),
                                      border: Border.all(
                                        width: 1,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: cur.username,
                                            style: AppTextStyles.text16(
                                              bold: true,
                                              size: size,
                                            ).copyWith(color: AppColor.primary),
                                          ),
                                          TextSpan(
                                            text: " join the chat",
                                            style: AppTextStyles.text16(
                                              bold: false,
                                              size: size,
                                            ).copyWith(color: AppColor.primary),
                                          ),
                                        ],
                                      ),
                                    )),
                              )
                            : Container(
                                margin: isMe
                                    ? EdgeInsets.only(
                                        left: size.width * 0.25,
                                        right: size.width * 0.02,
                                        bottom: size.height * 0.006,
                                      )
                                    : EdgeInsets.only(
                                        right: size.width * 0.25,
                                        left: size.width * 0.02,
                                        bottom: size.height * 0.006,
                                      ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.04,
                                    vertical: size.height * 0.01),
                                decoration: BoxDecoration(
                                    color: isMe
                                        ? AppColor.primary
                                        : AppColor.secondary,
                                    borderRadius: BorderRadius.circular(
                                      size.width * 0.03,
                                    ),
                                    border: Border.all(
                                        width: 1, color: AppColor.primary)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        !isMe
                                            ? Text(
                                                cur.username,
                                                style: AppTextStyles.text16(
                                                    bold: true, size: size),
                                              )
                                            : const SizedBox(),
                                        Text(
                                          message,
                                          style: AppTextStyles.text16(
                                                  bold: false, size: size)
                                              .copyWith(
                                            color: isMe
                                                ? AppColor.secondary
                                                : AppColor.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          Helper.getTime(cur.date),
                                          style: AppTextStyles.text12(
                                                  bold: false, size: size)
                                              .copyWith(
                                                  color: isMe
                                                      ? AppColor.secondary
                                                      : AppColor.primary),
                                        ),
                                      ],
                                    )
                                  ],
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
                controller: _textEditingController,
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
                      onPressed: () {
                        setState(() {
                          messages.add(Message(
                              date: DateTime.now(),
                              message: _textEditingController.text,
                              isMe: flag ? true : false,
                              username: "Jay"));
                          flag = !flag;
                        });
                        _textEditingController.clear();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.easeOut,
                          );
                        });
                      },
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
      username: "Rohit"),
  Message(
      message: "Hi back!",
      isMe: false,
      date: DateTime.now(),
      username: "Bunty"),
  Message(
      message: "How are you?",
      isMe: true,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "I'm doing well, thanks for asking!",
      isMe: false,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "What have you been up to lately?",
      isMe: true,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "",
      date: DateTime.now(),
      isMe: false,
      join: true,
      username: "Jay"),
  Message(
      message: "Just working, mostly. How about you?",
      isMe: false,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Same here, just trying to stay busy.",
      isMe: true,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Well, it sounds like you're doing a good job of that!",
      isMe: false,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Just working, mostly. How about you?",
      isMe: false,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Rohan Join",
      date: DateTime.now(),
      isMe: false,
      join: true,
      username: "Rohan"),
  Message(
      message: "Same here, just trying to stay busy.",
      isMe: true,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Just working, mostly. How about you?",
      isMe: false,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Same here, just trying to stay busy.",
      isMe: true,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Just working, mostly. How about you?",
      isMe: false,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Same here, just trying to stay busy.",
      isMe: true,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Just working, mostly. How about you?",
      isMe: false,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Same here, just trying to stay busy.",
      isMe: true,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Rohan Join",
      date: DateTime.now(),
      isMe: false,
      join: true,
      username: "Bhagyesh"),
  Message(
      message: "Rohan Join",
      date: DateTime.now(),
      isMe: false,
      join: true,
      username: "Gouri"),
  Message(
      message: "Just working, mostly. How about you?",
      isMe: false,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Same here, just trying to stay busy.",
      isMe: true,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Just working, mostly. How about you?",
      isMe: false,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Same here, just trying to stay busy.",
      isMe: true,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Just working, mostly. How about you?",
      isMe: false,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Same here, just trying to stay busy.",
      isMe: true,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Rohan Join",
      date: DateTime.now(),
      isMe: false,
      join: true,
      username: "Donal Sir"),
  Message(
      message: "Just working, mostly. How about you?",
      isMe: false,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Same here, just trying to stay busy.",
      isMe: true,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Just working, mostly. How about you?",
      isMe: false,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Rohan Join",
      date: DateTime.now(),
      isMe: false,
      join: true,
      username: "HOD sir"),
  Message(
      message: "Same here, just trying to stay busy.",
      isMe: true,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message:
          "Globle will test your knowledge of geography. The goal of the game is to find the mystery country on the world map. After each guess, you will see on the map the country you have chosen and the hotter the color, the closer you are to the hidden country.?",
      isMe: false,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Same here, just trying to stay busy.",
      isMe: true,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Just working, mostly. How about you?",
      isMe: false,
      date: DateTime.now(),
      username: "Rohit"),
  Message(
      message: "Same here, just trying to stay busy.",
      isMe: true,
      date: DateTime.now(),
      username: "Rohit"),
];
