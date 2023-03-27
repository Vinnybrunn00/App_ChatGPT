import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/chat_model.dart';
import '../providers/chat_provider.dart';
import '/constants/constants.dart';
import 'text_widget.dart';
import '/services/assets_manager.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key, required this.controller });


  final ScrollController controller;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  bool like = false;
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    List<ChatModel> chatList = chatProvider.getChaList;

    return ListView.builder(
      controller: widget.controller,
      itemCount: chatList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Material(
              color: index == 0 ? scaffoldBackgroundColor : cardColor,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          index == 0
                              ? AssetsManager.userImage
                              : AssetsManager.botImage,
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: index == 0
                              ? Textwidget(
                            label: chatList[index].msg,
                          )
                              : DefaultTextStyle(
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                            child: AnimatedTextKit(
                                isRepeatingAnimation: false,
                                repeatForever: false,
                                displayFullTextOnTap: true,
                                totalRepeatCount: 1,
                                animatedTexts: [
                                  TyperAnimatedText(
                                    chatList[index].msg.trim(),
                                  ),
                                ]),
                          ),
                        ),
                        index == 0
                            ? const SizedBox.shrink()
                            : Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(),
                              child: IconButton(
                                splashRadius: 15,
                                splashColor: const Color(0xFF00B181),
                                icon: const Icon(
                                  Icons.copy,
                                  color: Colors.white,
                                  size: 19,
                                ),
                                onPressed: () {
                                  final copymsg =
                                  ClipboardData(text: chatList[index].msg);
                                  Clipboard.setData(copymsg);
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    index == 0
                        ? const SizedBox.shrink()
                        : Row(
                      children: [
                        const SizedBox(
                          width: 35,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(100),
                          color: index == 0
                              ? scaffoldBackgroundColor
                              : cardColor,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              if (liked == false) {
                                setState(() {
                                  liked = true;
                                  like = true;
                                });
                              } else {
                                setState(() {
                                  liked = !liked;
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Ink(
                                child: Icon(
                                  liked == true
                                      ? like == true
                                      ? Icons.thumb_up_alt
                                      : Icons.thumb_up_off_alt
                                      : Icons.thumb_up_off_alt,
                                  color: liked == true
                                      ? like == true
                                      ? const Color.fromARGB(
                                      255, 0, 253, 152)
                                      : Colors.white
                                      : Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(100),
                          color: index == 0
                              ? scaffoldBackgroundColor
                              : cardColor,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              if (liked == false) {
                                setState(() {
                                  liked = true;
                                  like = false;
                                });
                              } else {
                                setState(() {
                                  liked = !liked;
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Ink(
                                child: Icon(
                                  liked == true
                                      ? like == false
                                      ? Icons.thumb_down_alt
                                      : Icons.thumb_down_off_alt
                                      : Icons.thumb_down_off_alt,
                                  color: liked == true
                                      ? like == false
                                      ? const Color.fromARGB(
                                      255, 255, 0, 106)
                                      : Colors.white
                                      : Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },

    );
  }
}
