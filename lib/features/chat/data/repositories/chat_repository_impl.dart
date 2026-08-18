import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/chat_turn_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource datasource;

  ChatRepositoryImpl({required this.datasource});

  @override
  Future<String> sendMessage(List<ChatMessageEntity> conversation) {
    final turns = conversation
        .where((message) => !message.isError)
        .map(ChatTurnModel.fromEntity)
        .toList();
    return datasource.sendMessage(turns);
  }
}
