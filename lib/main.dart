import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'features/chat/chat.dart';

void main() {
  final getIt = GetIt.instance;

  ChatModule.setup();

  runApp(FlowAssistantApp(getIt: getIt));
}

class FlowAssistantApp extends StatelessWidget {
  final GetIt getIt;

  const FlowAssistantApp({super.key, required this.getIt});

  @override
  Widget build(BuildContext context) {
    // Sem BlocProvider aqui: o ChatCubit agora é escopado dentro de
    // ChatModule.getChatPage() (ver chat_module.dart), não mais publicado
    // pra árvore inteira do app.
    return MaterialApp(
      title: 'Flow Assistant',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
      home: ChatModule.getChatPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
