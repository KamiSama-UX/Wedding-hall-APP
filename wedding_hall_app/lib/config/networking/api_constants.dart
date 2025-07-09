class ApiConstants {
  static const String baseUrlApi = "http://10.0.2.2:5000/api/";
  static const String baseUrl = "http://10.0.2.2:5000";
  static const String register = "auth/register";
  static const String verifyRegister = "auth/verify-email-otp";

  static const String login = "auth/login";
  static const String tokenLogin = "auth/token-login";
  static const String logout = "auth/logout";

  static const String sendOtpEmailResetPasword = "auth/reset/send-otp";
  static const String verifyOtpResetPassword = "auth/reset/verify-otp";
  static const String resetPassword = "auth/reset-password";

  static const String userReservations = "bookings/my-bookings";
  static const String makeReservations = "bookings";

  static const String allHalls = "halls/all";
  static const String trendingHalls = "halls/Trend/halls";
  static const String topHalls = "halls/Top/halls";
  static const String hallAva = "halls/availability";
  static const String getHallService = "halls/{id}/services";
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
