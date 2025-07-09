class ApiErrorModel {
  final String? error; // Make nullable if server can return null
  final int? statusCode; // Make nullable if server can return null

  ApiErrorModel({required this.error, required this.statusCode});

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    return ApiErrorModel(
      error: json['error'] as String?,
      statusCode: json['statusCode'] as int?,
    );
  }
}