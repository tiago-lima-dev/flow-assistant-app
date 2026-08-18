import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flow_assistant_app/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:flow_assistant_app/features/chat/data/models/chat_turn_model.dart';
import 'package:flow_assistant_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:flow_assistant_app/features/chat/domain/entities/chat_message_entity.dart';

class MockChatRemoteDatasource extends Mock implements ChatRemoteDatasource {}

void main() {
  late MockChatRemoteDatasource datasource;
  late ChatRepositoryImpl repository;

  final sentAt = DateTime(2026, 8, 17);

  setUpAll(() {
    registerFallbackValue(<ChatTurnModel>[]);
  });

  setUp(() {
    datasource = MockChatRemoteDatasource();
    repository = ChatRepositoryImpl(datasource: datasource);
  });

  test('mapeia entities pra turns preservando a ordem e devolve a resposta do datasource', () async {
    final conversation = [
      ChatMessageEntity(id: '1', role: ChatMessageRole.user, content: 'oi', sentAt: sentAt),
      ChatMessageEntity(id: '2', role: ChatMessageRole.assistant, content: 'Olá!', sentAt: sentAt),
    ];
    when(() => datasource.sendMessage(any())).thenAnswer((_) async => 'tudo certo');

    final reply = await repository.sendMessage(conversation);

    expect(reply, 'tudo certo');
    final captured = verify(() => datasource.sendMessage(captureAny())).captured.single as List<ChatTurnModel>;
    expect(captured, hasLength(2));
    expect(captured[0].role, 'user');
    expect(captured[0].content, 'oi');
    expect(captured[1].role, 'assistant');
    expect(captured[1].content, 'Olá!');
  });

  test('filtra mensagens marcadas como erro antes de mandar pro datasource', () async {
    final conversation = [
      ChatMessageEntity(id: '1', role: ChatMessageRole.user, content: 'oi', sentAt: sentAt),
      ChatMessageEntity(
        id: '2',
        role: ChatMessageRole.assistant,
        content: 'Não consegui falar com o assistente agora. Tente de novo.',
        sentAt: sentAt,
        isError: true,
      ),
      ChatMessageEntity(id: '3', role: ChatMessageRole.user, content: 'tenta de novo', sentAt: sentAt),
    ];
    when(() => datasource.sendMessage(any())).thenAnswer((_) async => 'ok');

    await repository.sendMessage(conversation);

    final captured = verify(() => datasource.sendMessage(captureAny())).captured.single as List<ChatTurnModel>;
    expect(captured, hasLength(2));
    expect(captured.map((t) => t.content), ['oi', 'tenta de novo']);
  });

  test('conversa só com mensagens de erro resulta numa lista vazia enviada', () async {
    final conversation = [
      ChatMessageEntity(id: '1', role: ChatMessageRole.assistant, content: 'erro', sentAt: sentAt, isError: true),
    ];
    when(() => datasource.sendMessage(any())).thenAnswer((_) async => 'ok');

    await repository.sendMessage(conversation);

    final captured = verify(() => datasource.sendMessage(captureAny())).captured.single as List<ChatTurnModel>;
    expect(captured, isEmpty);
  });
}
