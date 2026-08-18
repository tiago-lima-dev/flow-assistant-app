import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_message_entity.dart';

class ChatState extends Equatable {
  final List<ChatMessageEntity> messages;
  final bool isSending;

  const ChatState({this.messages = const [], this.isSending = false});

  ChatState copyWith({List<ChatMessageEntity>? messages, bool? isSending}) {
    return ChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [messages, isSending];
}
