import 'package:chatgpt/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import '../constants/api_consts.dart';
import '../providers/chat_provider.dart';
import '../providers/models_provider.dart';
import '../services/services.dart';
import '/constants/constants.dart';
import '/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(
      Uri.parse('$REPO_URL'),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $_launchUrl');
    }
  }

  //List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      floatingActionButton: GestureDetector(
        child: Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.only(bottom: 65),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 177, 129),
                borderRadius: BorderRadius.circular(50)),
            child: IconButton(
              icon: Image.asset('assets/images/github.png'),
              iconSize: 21,
              onPressed: () {
                try {
                  _launchUrl();
                  print('click');
                } catch (e) {
                  print('error $e');
                }
              },
            )),
      ),
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: const Text("Novo Chat"),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                      controller: _listScrollController,
                      itemCount: chatProvider.getChaList.length,
                      itemBuilder: (context, index) {
                        return Chatwidget(
                          msg: chatProvider
                              .getChaList[index].msg, //chatList[index].msg,
                          chatIndex: chatProvider.getChaList[index]
                              .chatIndex, //chatList[index].chatIndex,
                        );
                      })),
              if (_isTyping) ...[
                const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 18,
                ),
              ],
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.all(11),
                child: Material(
                  shadowColor: Colors.cyan,
                  borderRadius: BorderRadius.circular(16),
                  color: cardColor,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.white,
                          obscureText: false,
                          autofocus: false,
                          focusNode: focusNode,
                          style: const TextStyle(color: Colors.white),
                          controller: textEditingController,
                          onSubmitted: (value) async {
                            await sendMessageFCT(
                                modelsProvider: modelsProvider,
                                chatProvider: chatProvider);
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            border: InputBorder.none,
                            isCollapsed: true,
                            hintText: null,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            await sendMessageFCT(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider,
                            );
                          },
                          icon: const Icon(
                            Icons.send_outlined,
                            color: Color(0xFF00B181),
                            size: 21,
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Textwidget(
            label: "Escreva algo!",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        //chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      //chatList.addAll(await ApiService.sendMessage(
      // message: textEditingController.text,
      //  modelId: modelsProvider.getCurrentModel,
      //));
    } catch (error) {
      print("Erro_3 File: 'chat_screen.dart' > $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Textwidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}
