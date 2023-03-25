import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '/constants/constants.dart';
import 'text_widget.dart';
import '/services/assets_manager.dart';
import 'package:flutter/material.dart';

class Chatwidget extends StatelessWidget {
  const Chatwidget({super.key, required this.msg, required this.chatIndex});

  final String msg;
  final int chatIndex;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0
                      ? AssetsManager.userImage
                      : AssetsManager.botImage,
                  width: 30,
                  height: 30,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: chatIndex == 0
                      ? Textwidget(
                          label: msg,
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
                                  msg.trim(),
                                ),
                              ]),
                        ),
                ),
                chatIndex == 0
                    ? const SizedBox.shrink()
                    : Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(),
                            child: IconButton(
                              splashRadius: 10,
                              splashColor: const Color(0xFF00B181),
                              icon: const Icon(
                                Icons.copy,
                                color: Colors.white,
                                size: 21,
                              ),
                              onPressed: () {
                                final copymsg = ClipboardData(text: msg);
                                Clipboard.setData(copymsg);
                              },
                            ),
                          )
                        ],
                      ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
