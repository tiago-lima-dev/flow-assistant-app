class ChatReplyModel {
  final String reply;

  const ChatReplyModel({required this.reply});

  factory ChatReplyModel.fromJson(Map<String, dynamic> json) {
    return ChatReplyModel(reply: (json['reply'] as String?) ?? '');
  }
}
