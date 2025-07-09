
import '../entity/chat_message.dart';

abstract class ChatAiRepository {
  Future<ChatMessage> sendMessage(String text);
}
