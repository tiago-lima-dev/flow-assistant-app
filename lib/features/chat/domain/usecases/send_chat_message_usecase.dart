import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class SendChatMessageUseCase {
  final ChatRepository repository;

  SendChatMessageUseCase({required this.repository});

  Future<String> call(List<ChatMessageEntity> conversation) => repository.sendMessage(conversation);
}
