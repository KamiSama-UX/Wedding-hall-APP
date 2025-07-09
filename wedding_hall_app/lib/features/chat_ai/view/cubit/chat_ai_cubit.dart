
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/chat_message.dart';
import '../../domain/usecases/send_message.dart';

abstract class ChatAiState {}

class ChatAiInitial extends ChatAiState {}

class ChatAiLoaded extends ChatAiState {
  final List<ChatMessage> messages;
  ChatAiLoaded(this.messages);
}

class ChatAiError extends ChatAiState {
  final String message;
  ChatAiError(this.message);
}

class ChatAiCubit extends Cubit<ChatAiState> {
  final SendMessage sendMessageUseCase;
  List<ChatMessage> _messages = [];

  ChatAiCubit(this.sendMessageUseCase) : super(ChatAiInitial());

  void sendUserMessage(String text) async {
    if (text.trim().isEmpty) {
  return;
}

    _messages.add(ChatMessage(
      id: DateTime.now().toString(),
      message: text,
      isFromUser: true,
    ));
    emit(ChatAiLoaded(List.from(_messages)));

    try {
      final aiMessage = await sendMessageUseCase(text);
      _messages.add(aiMessage);
      emit(ChatAiLoaded(List.from(_messages)));
    } catch (e) {
      emit(ChatAiError("Failed to get AI response"));
    }
  }
}
