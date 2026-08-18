import 'package:flutter_test/flutter_test.dart';

import 'package:flow_assistant_app/features/chat/data/models/chat_turn_model.dart';
import 'package:flow_assistant_app/features/chat/domain/entities/chat_message_entity.dart';

void main() {
  group('ChatTurnModel.fromEntity', () {
    test('mapeia ChatMessageRole.user para o literal "user"', () {
      final entity = ChatMessageEntity(
        id: '1',
        role: ChatMessageRole.user,
        content: 'quero uma sala',
        sentAt: DateTime(2026, 8, 17),
      );

      final model = ChatTurnModel.fromEntity(entity);

      expect(model.role, 'user');
      expect(model.content, 'quero uma sala');
    });

    test('mapeia ChatMessageRole.assistant para o literal "assistant"', () {
      final entity = ChatMessageEntity(
        id: '2',
        role: ChatMessageRole.assistant,
        content: 'Claro, qual sala?',
        sentAt: DateTime(2026, 8, 17),
      );

      final model = ChatTurnModel.fromEntity(entity);

      expect(model.role, 'assistant');
    });
  });

  group('ChatTurnModel.toJson', () {
    test('serializa role e content como chaves planas', () {
      const model = ChatTurnModel(role: 'user', content: 'oi');

      expect(model.toJson(), {'role': 'user', 'content': 'oi'});
    });
  });
}
