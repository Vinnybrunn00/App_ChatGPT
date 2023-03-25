import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '/constants/constants.dart';
import 'text_widget.dart';
import '/services/assets_manager.dart';
import 'package:flutter/material.dart';

class Chatwidget extends StatefulWidget {
  const Chatwidget({super.key, required this.msg, required this.chatIndex});

  final String msg;
  final int chatIndex;

  @override
  State<Chatwidget> createState() => _ChatwidgetState();
}

class _ChatwidgetState extends State<Chatwidget> {
  bool like = false;
  bool liked = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: widget.chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      widget.chatIndex == 0
                          ? AssetsManager.userImage
                          : AssetsManager.botImage,
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: widget.chatIndex == 0
                          ? Textwidget(
                              label: widget.msg,
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
                                      widget.msg.trim(),
                                    ),
                                  ]),
                            ),
                    ),
                    widget.chatIndex == 0
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
                                        ClipboardData(text: widget.msg);
                                    Clipboard.setData(copymsg);
                                  },
                                ),
                              )
                            ],
                          ),
                  ],
                ),
                widget.chatIndex == 0
                    ? const SizedBox.shrink()
                    : Row(
                        children: [
                          const SizedBox(
                            width: 35,
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(100),
                            color: widget.chatIndex == 0
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
                                print('Like: $like Liked: $liked');
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
                            color: widget.chatIndex == 0
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
                                print('Like: $like Liked: $liked');
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
  }
}
