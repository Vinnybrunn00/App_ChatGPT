import 'dart:developer';
import 'package:chatgpt/screens/chat_mod.dart';
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
      drawer: Drawer(
        shadowColor: const Color(0xFF50fa7b),
        backgroundColor: const Color(0xFF44475a),
        child: ListView(
          primary: false,
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 43, 39, 63)),
              accountName: Text("CHATGPT"),
              accountEmail: Text(
                'Versão 1.0.8',
                style: TextStyle(
                  color: Color(0xFF50fa7b),
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 0, 177, 129),
                child: Image(
                  image: AssetImage('assets/images/logo_app.png'),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.chat_bubble_outline_outlined,
              ),
              title: const Text(
                'Gerador de Imagens',
                style: TextStyle(
                  color: Color.fromARGB(255, 186, 186, 186),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              iconColor: const Color.fromARGB(255, 0, 164, 99),
              onTap: () {
                try {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const ChatMod()),
                      (route) => false);
                  setState(() => chatProvider.chatList.clear());
                  log('onTap!!!');
                } catch (e) {
                  log('Error> $e');
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: const ButtonGitHub(),
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: const Text("Novo Chat - Mensagem"),
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
                  color: Color(0xFF50fa7b),
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
            color: Colors.red,
          ),
          backgroundColor: Colors.transparent,
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
      log("Erro_3 File: 'chat_screen.dart' > $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Textwidget(
            label: 'Requer uma chave API',
            color: Colors.red,
          ),
          backgroundColor: Colors.transparent,
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
