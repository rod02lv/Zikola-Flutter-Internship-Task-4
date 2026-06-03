class ApiEndpoints {
  static const String baseUrl = "https://api.escuelajs.co/api/v1";

  static const String login = "/auth/login"; // ( post )
  static const String refreshToken = "/auth/refresh-token"; // ( post )
  static const String profile = "/auth/profile"; // ( get )
  static const String users = "/users"; // ( get ) & ( post )

}