import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_test/core/constant/app_color.dart';
import 'package:socket_io_test/core/constant/app_text_styles.dart';
import 'package:socket_io_test/features/chat/provider/message.dart';

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
      // _socket.emit("leaveChat");
      // Provider.of<MessageProvider>(context).disconnectUser();
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
    _setup();
    joinUser();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
      body: Consumer<MessageProvider>(
        builder: (context, messageProvider, child) {
          return Column(
            children: [
              Expanded(
                child: Container(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messageProvider.messages.length,
                    itemBuilder: ((context, index) {
                      Message cur = messageProvider.messages[index];
                      String message = cur.message;
                      bool isMe = cur.username == widget.name;
                      DateTime date = cur.date;
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
                                                text:
                                                    cur.username == widget.name
                                                        ? "You"
                                                        : cur.username,
                                                style: AppTextStyles.text16(
                                                  bold: true,
                                                  size: size,
                                                ).copyWith(
                                                    color: AppColor.primary),
                                              ),
                                              TextSpan(
                                                text: " join the chat",
                                                style: AppTextStyles.text16(
                                                  bold: false,
                                                  size: size,
                                                ).copyWith(
                                                    color: AppColor.primary),
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
                          color: AppColor.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            sendMessage(_textEditingController.text.trim());
                            _textEditingController.clear();
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
          );
        },
      ),
    );
  }
}
