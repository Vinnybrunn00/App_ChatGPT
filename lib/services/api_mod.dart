import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chatgpt/constants/api_consts.dart';
import 'package:chatgpt/models/chat_model.dart';
import 'package:http/http.dart' as http;

class ApiMod {
  // send message
  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      log("modelId > $modelId");
      var response = await http.post(Uri.parse("$BASE_URL/images/generations"),
          headers: {
            'Authorization': 'Bearer $API_KEY',
            "Content-Type": "application/json"
          },
          body: jsonEncode(
            {
              "prompt": message,
              "n": 1,
              "size": '1024x1024',
            },
          ));

      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']['message']);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["data"].length > 0) {
        chatList = List.generate(
          jsonResponse["data"].length,
          (index) => ChatModel(
            msg: jsonResponse["data"][0]['url'],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("error_2 'api_service.dart' > $error");
      rethrow;
    }
  }
}
