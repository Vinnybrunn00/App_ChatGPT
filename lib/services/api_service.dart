import 'dart:convert';
import 'dart:io';
import 'dart:convert' show utf8;
import 'package:chatgpt/constants/api_consts.dart';
import 'package:chatgpt/models/chat_model.dart';
import 'package:chatgpt/models/models_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(Uri.parse("$BASE_URL/models"),
          headers: {'Authorization': 'Bearer $API_KEY'});

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']['message']}");
        throw HttpException((jsonResponse['error']['message']));
      }

      // print("jsonResponse $jsonResponse");
      List temp = [];
      for (var value in jsonResponse['data']) {
        temp.add(value);
        // print("temp ${value['id']}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      print("Erro_1 File: 'api_service.dart' > $error");
      rethrow;
    }
  }

  // send message
  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    // try aqui
    // try {
    print("modelId > $modelId");
    var response = await http.post(Uri.parse("$BASE_URL/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "prompt": message,
            "max_tokens": 100,
          },
        ));

    Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));

    // print(jsonResponse);
    if (jsonResponse['error'] != null) {
      // print("jsonResponse['error'] ${jsonResponse['error']['message']}");
      throw HttpException(jsonResponse['error']['message']);
    }
    List<ChatModel> chatList = [];
    if (jsonResponse["choices"].length > 0) {
      // print("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
      chatList = List.generate(
        jsonResponse["choices"].length,
        (index) => ChatModel(
          msg: jsonResponse["choices"][index]["text"],
          chatIndex: 1,
        ),
      );
    }
    return chatList;
    // } catch (error) {
    //   print("error_2 'api_service.dart' > $error");
    //   rethrow;
    // }
  }
}
