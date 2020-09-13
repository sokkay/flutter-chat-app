import 'package:chat/global/environment.dart';
import 'package:chat/models/message.dart';
import 'package:chat/models/mensaje_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ChatService {

  static ChatService _instance;

  factory ChatService(){
    if(_instance == null){
      _instance = new ChatService._();
    }
    return _instance;
  }

  ChatService._();

  Future<List<Message>> getChat(String userID) async {
    try {
      final resp = await http.get(
        '${Environment.apiUrl}/mensajes/$userID',
        headers: {'x-token': await AuthService.getToken()},
      );
      final messagesResponse = MensajesResponse.fromJson(resp.body);
      return messagesResponse.messages;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
