import 'package:equatable/equatable.dart';

enum ChatMessageRole { user, assistant }

class ChatMessageEntity extends Equatable {
  final String id;
  final ChatMessageRole role;
  final String content;
  final DateTime sentAt;
  final bool isError;

  const ChatMessageEntity({
    required this.id,
    required this.role,
    required this.content,
    required this.sentAt,
    this.isError = false,
  });

  @override
  List<Object?> get props => [id, role, content, sentAt, isError];
}
