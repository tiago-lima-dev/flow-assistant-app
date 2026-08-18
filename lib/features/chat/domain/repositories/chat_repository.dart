import '../entities/chat_message_entity.dart';

abstract class ChatRepository {
  Future<String> sendMessage(List<ChatMessageEntity> conversation);
}
