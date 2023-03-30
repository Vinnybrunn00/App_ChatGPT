// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import '../models/chat_model.dart';
import '../providers/chat_provider.dart';
import '/constants/constants.dart';
import 'text_widget.dart';
import '/services/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key, required this.controller});

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
              color: chatList[index].chatIndex == 0
                  ? scaffoldBackgroundColor
                  : cardColor,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        chatList[index].chatIndex == 0
                            ? Image.asset(
                                AssetsManager.userImage,
                                width: 30,
                                height: 30,
                              )
                            : Image.asset(
                                AssetsManager.botImage,
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
                              : chatList[index].msg.contains('http')
                                  ? Image.network(chatList[index].msg)
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
                        chatList[index].chatIndex == 0
                            ? const SizedBox.shrink()
                            : Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(),
                                    child: IconButton(
                                      splashRadius: 15,
                                      splashColor: const Color(0xFF00B181),
                                      icon: Icon(
                                        chatList[index].msg.contains('http')
                                            ? Icons.download
                                            : Icons.copy,
                                        color: Colors.white,
                                        size: 19,
                                      ),
                                      onPressed: () async {
                                        if (chatList[index]
                                            .msg
                                            .contains('http')) {
                                          ScaffoldMessenger.of(context)
                                              .clearSnackBars();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  content: Text(
                                                    '⏳ BAIXANDO...',
                                                    style: TextStyle(
                                                        color: Colors.yellow),
                                                  )));
                                          final response = await http.get(
                                              Uri.parse(chatList[index].msg));
                                          final bytes = response.bodyBytes;
                                          final result =
                                              await ImageGallerySaver.saveImage(
                                                  bytes);
                                          ScaffoldMessenger.of(context)
                                              .clearSnackBars();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  content: Text(
                                                    '✔ IMAGEM SALVA NA GALERIA',
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  )));
                                        } else {
                                          final copymsg = ClipboardData(
                                              text: chatList[index].msg);
                                          Clipboard.setData(copymsg);
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                      ],
                    ),
                    chatList[index].chatIndex == 0
                        ? const SizedBox.shrink()
                        : Row(
                            children: [
                              const SizedBox(
                                width: 35,
                              ),
                              Material(
                                borderRadius: BorderRadius.circular(100),
                                color: chatList[index].chatIndex == 0
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
                                color: chatList[index].chatIndex == 0
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
