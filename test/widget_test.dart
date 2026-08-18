import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:flow_assistant_app/features/chat/chat.dart';
import 'package:flow_assistant_app/main.dart';

void main() {
  testWidgets('App shows the chat page with an empty state message', (WidgetTester tester) async {
    ChatModule.setup();

    await tester.pumpWidget(FlowAssistantApp(getIt: GetIt.instance));

    expect(find.text('Assistente de salas'), findsOneWidget);
    expect(find.textContaining('Pergunte sobre disponibilidade'), findsOneWidget);
  });
}
