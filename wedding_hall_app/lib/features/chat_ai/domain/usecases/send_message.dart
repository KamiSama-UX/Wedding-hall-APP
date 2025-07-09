
import '../entity/chat_message.dart';
import '../repository/chat_ai_repository.dart';

class SendMessage {
  final ChatAiRepository repository;

  SendMessage(this.repository);

  Future<ChatMessage> call(String text) async {
    return await repository.sendMessage(text);
  }
}
