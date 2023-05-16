import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_test/core/constant/app_color.dart';
import 'package:socket_io_test/core/constant/app_text_styles.dart';
import 'package:socket_io_test/core/constant/const_size_box.dart';
import 'package:socket_io_test/features/chat/provider/message.dart';

import '../../../core/constant/app_helper.dart';
import '../model/message_model.dart';

class Chat extends StatefulWidget {
  Chat({required this.name, super.key});
  String name;
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> with WidgetsBindingObserver {
  final IO.Socket _socket = IO.io("http://192.168.1.20:3000",
      IO.OptionBuilder().setTransports(['websocket']).build());
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _setup() {
    _socket.onConnect((data) {
      log("Connect");
    });
    _socket.onError((data) {
      log("Error $data");
    });
    _socket.onDisconnect((data) {
      log("Disconnected");
    });
    _socket.on("message", (data) {
      String jsonString = jsonEncode(data);
      Map<String, dynamic> map = jsonDecode(jsonString);
      Provider.of<MessageProvider>(context, listen: false).addMessage(map);
      scrollToBottom();
    });

    _socket.on("newUserJoin", (data) {
      String jsonString = jsonEncode(data);
      Map<String, dynamic> map = jsonDecode(jsonString);
      Provider.of<MessageProvider>(context, listen: false).addMessage(map);
      scrollToBottom();
    });

    _socket.on("userLeaveChat", (data) {
      String jsonString = jsonEncode(data);
      Map<String, dynamic> map = jsonDecode(jsonString);
      Provider.of<MessageProvider>(context, listen: false).addMessage(map);
      scrollToBottom();
    });
  }

  void sendMessage(String message) {
    _socket.emit("message", {
      "username": widget.name,
      "message": message,
      "date": DateTime.now().toString(),
    });
  }

  void joinUser() {
    _socket.emit("newUserJoin", {
      "username": widget.name,
    });
  }

  void _leaveUser() {
    _socket.emit("userLeaveChat", {"username": widget.name});
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 50), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setup();
    joinUser();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _leaveUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<MessageProvider>(
      builder: (context, messageProvider, child) {
        return WillPopScope(
          onWillPop: () async {
            bool isPop = false;
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Are you sure you want to exit?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "No",
                        style: AppTextStyles.text16(bold: true, size: size),
                      )),
                  TextButton(
                      onPressed: () {
                        isPop = true;
                        _leaveUser();
                        exit(0);
                      },
                      child: Text(
                        "Yes",
                        style: AppTextStyles.text16(bold: true, size: size),
                      ))
                ],
              ),
            );
            return isPop;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey.shade200,
              elevation: 0,
              centerTitle: true,
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: size.width * 0.04),
                  child: Center(
                      child: Text(
                    "Online ${messageProvider.numberOfActiveUser}",
                    style: AppTextStyles.text14(bold: true, size: size),
                  )),
                )
              ],
              title: Text(
                "Group Chat",
                style: AppTextStyles.text24(bold: true, size: size),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    color: AppColor.backgroundColor,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: messageProvider.messages.length,
                      itemBuilder: ((context, index) {
                        Message cur = messageProvider.messages[index];
                        String message = cur.message;
                        bool isMe = cur.username == widget.name;
                        return Row(
                          mainAxisAlignment: isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
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
                                              color: AppColor.joinCard,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                size.width * 0.01,
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                  offset: Offset(0, 1),
                                                  blurRadius: 1,
                                                )
                                              ]),
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: cur.username ==
                                                          widget.name
                                                      ? "You"
                                                      : cur.username,
                                                  style: AppTextStyles.text16(
                                                    bold: true,
                                                    size: size,
                                                  ).copyWith(
                                                      color: AppColor
                                                          .friendMessageColor),
                                                ),
                                                TextSpan(
                                                  text: " join the chat",
                                                  style: AppTextStyles.text16(
                                                    bold: false,
                                                    size: size,
                                                  ).copyWith(
                                                      color: AppColor
                                                          .friendMessageColor),
                                                ),
                                              ],
                                            ),
                                          )),
                                    )
                                  : cur.isLeave
                                      ? Center(
                                          child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: size.width * 0.2,
                                                  vertical: size.height * 0.01),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: size.width * 0.03,
                                                  vertical:
                                                      size.height * 0.006),
                                              decoration: BoxDecoration(
                                                  color: AppColor.leaveCard,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    size.width * 0.01,
                                                  ),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      offset: Offset(0, 1),
                                                      blurRadius: 1,
                                                    )
                                                  ]),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: cur.username ==
                                                              widget.name
                                                          ? "You"
                                                          : cur.username,
                                                      style: AppTextStyles
                                                          .text16(
                                                        bold: true,
                                                        size: size,
                                                      ).copyWith(
                                                          color: AppColor
                                                              .friendMessageColor),
                                                    ),
                                                    TextSpan(
                                                      text: " join the chat",
                                                      style: AppTextStyles
                                                          .text16(
                                                        bold: false,
                                                        size: size,
                                                      ).copyWith(
                                                          color: AppColor
                                                              .friendMessageColor),
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
                                                ? AppColor.userMessageCardColor
                                                : AppColor
                                                    .friendMessageCardColor,
                                            borderRadius: BorderRadius.circular(
                                              size.width * 0.03,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  !isMe
                                                      ? Text(
                                                          cur.username,
                                                          style: AppTextStyles
                                                                  .text16(
                                                                      bold:
                                                                          true,
                                                                      size:
                                                                          size)
                                                              .copyWith(
                                                                  color: AppColor
                                                                      .userMessageColor),
                                                        )
                                                      : const SizedBox(),
                                                  Text(
                                                    message,
                                                    style: AppTextStyles.text16(
                                                            bold: false,
                                                            size: size)
                                                        .copyWith(
                                                            color: AppColor
                                                                .userMessageColor),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  AppConstSizedBox.height(
                                                      size.height * 0.007),
                                                  Text(
                                                    Helper.getTime(cur.date),
                                                    style: AppTextStyles.text12(
                                                            bold: false,
                                                            size: size)
                                                        .copyWith(
                                                      color: AppColor
                                                          .userMessageColor,
                                                    ),
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
                      horizontal: size.width * 0.04,
                      vertical: size.height * 0.01),
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
                            color: AppColor.userMessageCardColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              sendMessage(_textEditingController.text.trim());
                              _textEditingController.clear();
                            },
                            icon: Icon(
                              Icons.send,
                              color: AppColor.userMessageColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
