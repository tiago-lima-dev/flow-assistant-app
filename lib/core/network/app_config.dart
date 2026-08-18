abstract final class AppConfig {
  /// Ajuste conforme o ambiente de teste:
  /// - Simulador iOS: `localhost` funciona direto
  /// - Emulador Android: use `http://ip-backend:8080/api` (00.0.0.0 é o alias
  ///   pro `localhost` da máquina host, visto de dentro do emulador)
  /// - Dispositivo físico: use o IP da máquina na rede local, ex:
  ///   `http://ip-backend:8080/api`
  static const String apiBaseUrl = 'http://localhost:8080/api';
}
