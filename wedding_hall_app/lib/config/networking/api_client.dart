import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio) {
    dio.options.baseUrl = "https://api.openai.com/v1/";
    dio.options.headers = {
      "Authorization": "Bearer YOUR_OPENAI_API_KEY",
      "Content-Type": "application/json",
    };
  }
}
