
class ChatMessageModel {
  final String id;
  final String message;
  final bool isFromUser;

  ChatMessageModel({
    required this.id,
    required this.message,
    required this.isFromUser,
  });
}
