import 'package:dio/dio.dart';
import '../../domain/entity/chat_message.dart';
import '../../domain/repository/chat_ai_repository.dart';

class ChatAiRepositoryImpl implements ChatAiRepository {
  final Dio dio;

  ChatAiRepositoryImpl(this.dio);

  @override
  Future<ChatMessage> sendMessage(String text) async {
    try {
      final response = await dio.post(
        "http://192.168.1.101:6000/chat",
        data: {"message": text},
        
      );
        print("Response data: ${response.data}");

      final reply = response.data["response"];
    

      return ChatMessage(
        id: DateTime.now().toString(),
        message: reply,
        isFromUser: false,
      );
      
    } catch (e) {
      throw Exception("Failed to get AI response: \$e");
    }
  }
  
}