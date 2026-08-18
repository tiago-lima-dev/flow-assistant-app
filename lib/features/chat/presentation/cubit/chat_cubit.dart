import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/send_chat_message_usecase.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendChatMessageUseCase sendChatMessageUseCase;

  ChatCubit({required this.sendChatMessageUseCase}) : super(const ChatState());

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isSending) return;

    final userMessage = ChatMessageEntity(
      id: _generateId(),
      role: ChatMessageRole.user,
      content: trimmed,
      sentAt: DateTime.now(),
    );
    final updatedMessages = [...state.messages, userMessage];
    emit(state.copyWith(messages: updatedMessages, isSending: true));

    try {
      final reply = await sendChatMessageUseCase.call(updatedMessages);
      final assistantMessage = ChatMessageEntity(
        id: _generateId(),
        role: ChatMessageRole.assistant,
        content: reply,
        sentAt: DateTime.now(),
      );
      emit(state.copyWith(messages: [...state.messages, assistantMessage], isSending: false));
    } catch (_) {
      final errorMessage = ChatMessageEntity(
        id: _generateId(),
        role: ChatMessageRole.assistant,
        content: 'Não consegui falar com o assistente agora. Tente de novo.',
        sentAt: DateTime.now(),
        isError: true,
      );
      emit(state.copyWith(messages: [...state.messages, errorMessage], isSending: false));
    }
  }

  void reset() => emit(const ChatState());

  String _generateId() => DateTime.now().microsecondsSinceEpoch.toString();
}
