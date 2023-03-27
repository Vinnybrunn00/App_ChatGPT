import 'package:chatgpt/widgets/button_github.dart';
import 'package:chatgpt/widgets/custom_text_field.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/models_provider.dart';
import '../services/services.dart';
import '/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      floatingActionButton: const ButtonGitHub(),
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: const Text("Novo Chat"),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(
                context: context,
              );
            },
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Flexible(child: ChatWidget(controller: _listScrollController)),
              if (_isTyping) ...[
                const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 18,
                ),
              ],
              CustomTextField(
                controller: textEditingController,
                focusNode: focusNode,
                onSubmitted: (value) async {
                  await sendMessageFCT(
                    modelsProvider: modelsProvider,
                    chatProvider: chatProvider,
                  );
                },
                onPressed: () async {
                  await sendMessageFCT(
                    modelsProvider: modelsProvider,
                    chatProvider: chatProvider,
                  );
                },
              ),
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
      setState(
        () {
          _isTyping = true;
          chatProvider.addUserMessage(msg: msg);
          textEditingController.clear();
          focusNode.unfocus();
        },
      );
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
    } catch (error) {
      print("Erro_3 File: 'chat_screen.dart' > $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Textwidget(
            label: error.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}
