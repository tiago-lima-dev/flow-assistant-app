import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flow_assistant_app/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flow_assistant_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:flow_assistant_app/features/chat/domain/usecases/send_chat_message_usecase.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository repository;
  late SendChatMessageUseCase useCase;

  setUp(() {
    repository = MockChatRepository();
    useCase = SendChatMessageUseCase(repository: repository);
  });

  test('repassa a conversa pro repositório e devolve a resposta dele', () async {
    final conversation = [
      ChatMessageEntity(id: '1', role: ChatMessageRole.user, content: 'oi', sentAt: DateTime(2026, 8, 17)),
    ];
    when(() => repository.sendMessage(conversation)).thenAnswer((_) async => 'Olá! Como posso ajudar?');

    final reply = await useCase.call(conversation);

    expect(reply, 'Olá! Como posso ajudar?');
    verify(() => repository.sendMessage(conversation)).called(1);
  });

  test('propaga exceções do repositório sem interceptar', () async {
    final conversation = <ChatMessageEntity>[];
    when(() => repository.sendMessage(conversation)).thenThrow(Exception('sem conexão'));

    expect(() => useCase.call(conversation), throwsException);
  });
}
