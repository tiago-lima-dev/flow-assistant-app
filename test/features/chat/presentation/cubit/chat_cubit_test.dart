import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flow_assistant_app/features/chat/domain/entities/chat_message_entity.dart';
import 'package:flow_assistant_app/features/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:flow_assistant_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:flow_assistant_app/features/chat/presentation/cubit/chat_state.dart';

class MockSendChatMessageUseCase extends Mock implements SendChatMessageUseCase {}

void main() {
  late MockSendChatMessageUseCase useCase;

  setUpAll(() {
    registerFallbackValue(<ChatMessageEntity>[]);
  });

  setUp(() {
    useCase = MockSendChatMessageUseCase();
  });

  group('sendMessage - sucesso', () {
    blocTest<ChatCubit, ChatState>(
      'emite a mensagem do usuário (isSending true) e depois a resposta (isSending false)',
      build: () {
        when(() => useCase.call(any())).thenAnswer((_) async => 'Olá! Como posso ajudar?');
        return ChatCubit(sendChatMessageUseCase: useCase);
      },
      act: (cubit) => cubit.sendMessage('oi'),
      expect: () => [
        isA<ChatState>()
            .having((s) => s.isSending, 'isSending', isTrue)
            .having((s) => s.messages, 'messages', hasLength(1))
            .having((s) => s.messages.single.role, 'role', ChatMessageRole.user)
            .having((s) => s.messages.single.content, 'content', 'oi'),
        isA<ChatState>()
            .having((s) => s.isSending, 'isSending', isFalse)
            .having((s) => s.messages, 'messages', hasLength(2))
            .having((s) => s.messages.last.role, 'role', ChatMessageRole.assistant)
            .having((s) => s.messages.last.content, 'content', 'Olá! Como posso ajudar?')
            .having((s) => s.messages.last.isError, 'isError', isFalse),
      ],
    );

    blocTest<ChatCubit, ChatState>(
      'remove espaços nas bordas do texto antes de enviar (trim)',
      build: () {
        when(() => useCase.call(any())).thenAnswer((_) async => 'ok');
        return ChatCubit(sendChatMessageUseCase: useCase);
      },
      act: (cubit) => cubit.sendMessage('  oi  '),
      expect: () => [
        isA<ChatState>().having((s) => s.messages.single.content, 'content', 'oi'),
        isA<ChatState>(),
      ],
    );

    blocTest<ChatCubit, ChatState>(
      'repassa a conversa acumulada (não só a mensagem nova) pro use case',
      build: () {
        when(() => useCase.call(any())).thenAnswer((_) async => 'ok');
        return ChatCubit(sendChatMessageUseCase: useCase);
      },
      seed: () => ChatState(
        messages: [
          ChatMessageEntity(id: '0', role: ChatMessageRole.user, content: 'oi', sentAt: DateTime(2026, 8, 17)),
        ],
      ),
      act: (cubit) => cubit.sendMessage('quero reservar uma sala'),
      verify: (_) {
        final captured = verify(() => useCase.call(captureAny())).captured.single as List<ChatMessageEntity>;
        expect(captured, hasLength(2));
        expect(captured.first.content, 'oi');
        expect(captured.last.content, 'quero reservar uma sala');
      },
    );
  });

  group('sendMessage - erro', () {
    blocTest<ChatCubit, ChatState>(
      'emite mensagem do assistente marcada como isError quando o use case falha',
      build: () {
        when(() => useCase.call(any())).thenThrow(Exception('sem conexão'));
        return ChatCubit(sendChatMessageUseCase: useCase);
      },
      act: (cubit) => cubit.sendMessage('oi'),
      expect: () => [
        isA<ChatState>().having((s) => s.isSending, 'isSending', isTrue),
        isA<ChatState>()
            .having((s) => s.isSending, 'isSending', isFalse)
            .having((s) => s.messages.last.isError, 'isError', isTrue)
            .having((s) => s.messages.last.role, 'role', ChatMessageRole.assistant)
            .having((s) => s.messages.last.content, 'content',
                'Não consegui falar com o assistente agora. Tente de novo.'),
      ],
    );
  });

  group('sendMessage - guardas', () {
    blocTest<ChatCubit, ChatState>(
      'texto vazio não emite nada nem chama o use case',
      build: () => ChatCubit(sendChatMessageUseCase: useCase),
      act: (cubit) => cubit.sendMessage(''),
      expect: () => [],
      verify: (_) => verifyNever(() => useCase.call(any())),
    );

    blocTest<ChatCubit, ChatState>(
      'texto só com espaços não emite nada',
      build: () => ChatCubit(sendChatMessageUseCase: useCase),
      act: (cubit) => cubit.sendMessage('   '),
      expect: () => [],
      verify: (_) => verifyNever(() => useCase.call(any())),
    );

    blocTest<ChatCubit, ChatState>(
      'ignora um novo envio enquanto isSending já é true',
      build: () => ChatCubit(sendChatMessageUseCase: useCase),
      seed: () => const ChatState(isSending: true),
      act: (cubit) => cubit.sendMessage('outra mensagem'),
      expect: () => [],
      verify: (_) => verifyNever(() => useCase.call(any())),
    );
  });

  group('reset', () {
    blocTest<ChatCubit, ChatState>(
      'volta pro estado inicial vazio, descartando mensagens e isSending anteriores',
      build: () => ChatCubit(sendChatMessageUseCase: useCase),
      seed: () => ChatState(
        messages: [
          ChatMessageEntity(id: '1', role: ChatMessageRole.user, content: 'oi', sentAt: DateTime(2026, 8, 17)),
        ],
      ),
      act: (cubit) => cubit.reset(),
      expect: () => [const ChatState()],
    );
  });
}
