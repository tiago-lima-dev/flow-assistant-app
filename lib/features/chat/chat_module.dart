import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'binds/chat_binds.dart';
import 'presentation/cubit/chat_cubit.dart';
import 'presentation/pages/chat_page.dart';

abstract final class ChatModule {
  static void setup() {
    ChatBinds.setupBinds(GetIt.instance);
  }

  // O ChatCubit é criado aqui, escopado a essa página: GetIt.instance<ChatCubit>()
  // é uma factory (chat_binds.dart), então cada chamada devolve uma instância
  // nova. O BlocProvider passa a ser o dono dela e fecha o cubit quando a
  // página sai da árvore.
  static Widget getChatPage() => BlocProvider<ChatCubit>(
        create: (_) => GetIt.instance<ChatCubit>(),
        child: const ChatPage(),
      );
}
