import 'package:flutter_test/flutter_test.dart';

import 'package:flow_assistant_app/features/chat/data/models/chat_reply_model.dart';

void main() {
  group('ChatReplyModel.fromJson', () {
    test('extrai o campo reply quando presente', () {
      final model = ChatReplyModel.fromJson({'reply': 'Reserva confirmada!'});

      expect(model.reply, 'Reserva confirmada!');
    });

    test('devolve string vazia quando reply está ausente', () {
      final model = ChatReplyModel.fromJson({});

      expect(model.reply, '');
    });

    test('devolve string vazia quando reply é null', () {
      final model = ChatReplyModel.fromJson({'reply': null});

      expect(model.reply, '');
    });
  });
}
