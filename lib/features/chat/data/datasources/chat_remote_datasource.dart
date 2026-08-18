import '../models/chat_turn_model.dart';

abstract class ChatRemoteDatasource {
  Future<String> sendMessage(List<ChatTurnModel> conversation);
}
