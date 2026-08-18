import 'package:flutter_test/flutter_test.dart';

import 'package:flow_assistant_app/features/chat/domain/entities/chat_message_entity.dart';

void main() {
  DateTime sentAt = DateTime(2026, 8, 17, 9, 0);

  group('ChatMessageEntity', () {
    test('isError tem valor padrão false quando não informado', () {
      final message = ChatMessageEntity(
        id: '1',
        role: ChatMessageRole.user,
        content: 'oi',
        sentAt: sentAt,
      );

      expect(message.isError, isFalse);
    });

    test('duas instâncias com os mesmos valores são iguais (Equatable)', () {
      final a = ChatMessageEntity(id: '1', role: ChatMessageRole.user, content: 'oi', sentAt: sentAt);
      final b = ChatMessageEntity(id: '1', role: ChatMessageRole.user, content: 'oi', sentAt: sentAt);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('instâncias com id diferente não são iguais', () {
      final a = ChatMessageEntity(id: '1', role: ChatMessageRole.user, content: 'oi', sentAt: sentAt);
      final b = ChatMessageEntity(id: '2', role: ChatMessageRole.user, content: 'oi', sentAt: sentAt);

      expect(a, isNot(equals(b)));
    });

    test('instâncias com isError diferente não são iguais', () {
      final a = ChatMessageEntity(id: '1', role: ChatMessageRole.assistant, content: 'erro', sentAt: sentAt);
      final b = ChatMessageEntity(
        id: '1',
        role: ChatMessageRole.assistant,
        content: 'erro',
        sentAt: sentAt,
        isError: true,
      );

      expect(a, isNot(equals(b)));
    });
  });
}
