import '../../domain/entities/chat_message_entity.dart';

class ChatTurnModel {
  final String role;
  final String content;

  const ChatTurnModel({required this.role, required this.content});

  factory ChatTurnModel.fromEntity(ChatMessageEntity entity) {
    return ChatTurnModel(
      role: entity.role == ChatMessageRole.user ? 'user' : 'assistant',
      content: entity.content,
    );
  }

  Map<String, dynamic> toJson() => {'role': role, 'content': content};
}
