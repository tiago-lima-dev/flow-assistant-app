import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flow_assistant_app/features/chat/data/datasources/chat_remote_datasource_impl.dart';
import 'package:flow_assistant_app/features/chat/data/models/chat_turn_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late ChatRemoteDatasourceImpl datasource;

  setUp(() {
    dio = MockDio();
    datasource = ChatRemoteDatasourceImpl(dio);
  });

  Response<Map<String, dynamic>> responseWith(Map<String, dynamic>? data) {
    return Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/chat/messages'),
      data: data,
      statusCode: 200,
    );
  }

  test('faz POST em /chat/messages com o corpo {"messages": [...]}', () async {
    when(() => dio.post<Map<String, dynamic>>('/chat/messages', data: any(named: 'data')))
        .thenAnswer((_) async => responseWith({'reply': 'Olá!'}));

    final conversation = [const ChatTurnModel(role: 'user', content: 'oi')];
    await datasource.sendMessage(conversation);

    final captured = verify(() => dio.post<Map<String, dynamic>>('/chat/messages', data: captureAny(named: 'data')))
        .captured
        .single as Map<String, dynamic>;
    expect(captured['messages'], [
      {'role': 'user', 'content': 'oi'},
    ]);
  });

  test('devolve o campo reply da resposta', () async {
    when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
        .thenAnswer((_) async => responseWith({'reply': 'Reserva confirmada!'}));

    final reply = await datasource.sendMessage([]);

    expect(reply, 'Reserva confirmada!');
  });

  test('resposta sem corpo devolve string vazia em vez de quebrar', () async {
    when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
        .thenAnswer((_) async => responseWith(null));

    final reply = await datasource.sendMessage([]);

    expect(reply, '');
  });

  test('propaga DioException do Dio pra camada acima', () async {
    when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data'))).thenThrow(
      DioException(requestOptions: RequestOptions(path: '/chat/messages'), type: DioExceptionType.connectionTimeout),
    );

    expect(() => datasource.sendMessage([]), throwsA(isA<DioException>()));
  });

  test('mensagens com múltiplos turnos são serializadas na ordem', () async {
    when(() => dio.post<Map<String, dynamic>>('/chat/messages', data: any(named: 'data')))
        .thenAnswer((_) async => responseWith({'reply': 'ok'}));

    final conversation = [
      const ChatTurnModel(role: 'user', content: 'oi'),
      const ChatTurnModel(role: 'assistant', content: 'Olá! Em que posso ajudar?'),
      const ChatTurnModel(role: 'user', content: 'quero reservar uma sala'),
    ];
    await datasource.sendMessage(conversation);

    final captured = verify(() => dio.post<Map<String, dynamic>>('/chat/messages', data: captureAny(named: 'data')))
        .captured
        .single as Map<String, dynamic>;
    expect(captured['messages'], [
      {'role': 'user', 'content': 'oi'},
      {'role': 'assistant', 'content': 'Olá! Em que posso ajudar?'},
      {'role': 'user', 'content': 'quero reservar uma sala'},
    ]);
  });
}
