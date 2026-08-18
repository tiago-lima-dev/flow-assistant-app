import 'package:dio/dio.dart';

import '../models/chat_reply_model.dart';
import '../models/chat_turn_model.dart';
import 'chat_remote_datasource.dart';

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final Dio dio;

  ChatRemoteDatasourceImpl(this.dio);

  @override
  Future<String> sendMessage(List<ChatTurnModel> conversation) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/chat/messages',
      data: {'messages': conversation.map((turn) => turn.toJson()).toList()},
    );
    return ChatReplyModel.fromJson(response.data ?? const {}).reply;
  }
}
