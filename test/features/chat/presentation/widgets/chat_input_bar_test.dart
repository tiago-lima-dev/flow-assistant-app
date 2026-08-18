import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flow_assistant_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:flow_assistant_app/features/chat/presentation/cubit/chat_state.dart';
import 'package:flow_assistant_app/features/chat/presentation/widgets/chat_input_bar.dart';

// Prova em código o ponto do docs/state-management.md: pra testar um widget
// que lê o cubit via context.read/BlocBuilder, basta injetar um fake através
// de BlocProvider.value — não é preciso registrar nem resetar nada no GetIt.
class MockChatCubit extends MockCubit<ChatState> implements ChatCubit {}

void main() {
  late MockChatCubit chatCubit;

  setUp(() {
    chatCubit = MockChatCubit();
    when(() => chatCubit.sendMessage(any())).thenAnswer((_) async {});
  });

  Future<void> pumpInputBar(WidgetTester tester, ChatState state) async {
    whenListen(chatCubit, Stream<ChatState>.empty(), initialState: state);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<ChatCubit>.value(
            value: chatCubit,
            child: const ChatInputBar(),
          ),
        ),
      ),
    );
  }

  testWidgets('envia o texto digitado e limpa o campo', (tester) async {
    await pumpInputBar(tester, const ChatState());

    await tester.enterText(find.byType(TextField), 'quero uma sala amanhã às 10h');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    verify(() => chatCubit.sendMessage('quero uma sala amanhã às 10h')).called(1);
    expect(find.text('quero uma sala amanhã às 10h'), findsNothing);
  });

  testWidgets('não chama sendMessage se o campo estiver vazio', (tester) async {
    await pumpInputBar(tester, const ChatState());

    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    verifyNever(() => chatCubit.sendMessage(any()));
  });

  testWidgets('não chama sendMessage se o texto for só espaços', (tester) async {
    await pumpInputBar(tester, const ChatState());

    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    verifyNever(() => chatCubit.sendMessage(any()));
  });

  testWidgets('desabilita o campo e mostra spinner enquanto isSending é true', (tester) async {
    await pumpInputBar(tester, const ChatState(isSending: true));

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.enabled, isFalse);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.send), findsNothing);
  });
}
