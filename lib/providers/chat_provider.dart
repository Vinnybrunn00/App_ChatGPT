import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../services/api_mod.dart';
import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getChaList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required chosenModelId}) async {
    chatList.addAll(await ApiService.sendMessage(
      message: msg,
      modelId: chosenModelId,
    ));
    notifyListeners();
  }

  Future<void> sendMessageAndGetImage(
      {required String msg, required chosenModelId}) async {
    chatList.addAll(await ApiMod.sendMessage(
      message: msg,
      modelId: chosenModelId,
    ));
    notifyListeners();
  }
}
