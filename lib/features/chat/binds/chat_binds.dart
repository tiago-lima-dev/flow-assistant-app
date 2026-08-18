import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../core/network/app_config.dart';
import '../data/datasources/chat_remote_datasource.dart';
import '../data/datasources/chat_remote_datasource_impl.dart';
import '../data/repositories/chat_repository_impl.dart';
import '../domain/repositories/chat_repository.dart';
import '../domain/usecases/send_chat_message_usecase.dart';
import '../presentation/cubit/chat_cubit.dart';

abstract final class ChatBinds {
  static void setupBinds(GetIt getIt) {
    if (!getIt.isRegistered<Dio>()) {
      getIt.registerSingleton<Dio>(Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)));
    }

    getIt.registerSingleton<ChatRemoteDatasource>(ChatRemoteDatasourceImpl(getIt()));
    getIt.registerSingleton<ChatRepository>(ChatRepositoryImpl(datasource: getIt()));
    getIt.registerSingleton<SendChatMessageUseCase>(SendChatMessageUseCase(repository: getIt()));

    // Factory, não singleton: o ChatCubit é escopado à ChatPage via
    // BlocProvider(create:) em chat_module.dart, não vive solto no GetIt.
    // Ver docs/state-management.md, seção "Antes vs Depois".
    getIt.registerFactory<ChatCubit>(() => ChatCubit(sendChatMessageUseCase: getIt()));
  }
}
