import 'dart:developer' as developer;
import 'package:dio/dio.dart';

import 'api_error_model.dart';

/// Enum representing possible data source errors
enum DataSource {
  noContent,
  badRequest,
  forbidden,
  unauthorized,
  notFound,
  internalServerError,
  connectTimeout,
  cancel,
  receiveTimeout,
  sendTimeout,
  cacheError,
  noInternetConnection,
  defaultError
}

/// Response codes with camelCase naming
class ResponseCode {
  static const int success = 200; // Success with data
  static const int noContent = 201; // Success with no data (no content)
  static const int badRequest = 400; // Failure, API rejected request
  static const int unauthorized = 401; // Failure, user is not authorized
  static const int forbidden = 403; // Failure, API rejected request
  static const int internalServerError = 500; // Failure, crash on server side
  static const int notFound = 404; // Failure, not found
  static const int apiLogicError = 422; // API logic error

  // Local status codes
  static const int connectTimeout = -1;
  static const int cancel = -2;
  static const int receiveTimeout = -3;
  static const int sendTimeout = -4;
  static const int cacheError = -5;
  static const int noInternetConnection = -6;
  static const int defaultError = -7;
}

/// Response messages with camelCase naming
class ResponseMessage {
  static const String noContent = "No content available.";
  static const String badRequest = "Bad request. Please check your input.";
  static const String unauthorized =
      "Unauthorized access. Please log in again.";
  static const String forbidden =
      "Access forbidden. You do not have permission.";
  static const String internalServerError =
      "Internal server error. Please try again later.";
  static const String notFound = "Resource not found.";
  static const String timeout = "Request timed out. Please try again.";
  static const String cacheError = "Cache error. Please clear cache and retry.";
  static const String noInternetConnection =
      "No internet connection. Please check your network.";
  static const String defaultError = "Error Modeling";
}

extension DataSourceExtension on DataSource {
  ApiErrorModel getFailure() {
    switch (this) {
      case DataSource.noContent:
        return ApiErrorModel(
          error: ResponseMessage.noContent,
          statusCode: ResponseCode.noContent,
        );
      case DataSource.badRequest:
        return ApiErrorModel(
          error: ResponseMessage.badRequest,
          statusCode: ResponseCode.badRequest,
        );
      case DataSource.forbidden:
        return ApiErrorModel(
          error: ResponseMessage.forbidden,
          statusCode: ResponseCode.forbidden,
        );
      case DataSource.unauthorized:
        return ApiErrorModel(
          error: ResponseMessage.unauthorized,
          statusCode: ResponseCode.unauthorized,
        );
      case DataSource.notFound:
        return ApiErrorModel(
          error: ResponseMessage.notFound,
          statusCode: ResponseCode.notFound,
        );
      case DataSource.internalServerError:
        return ApiErrorModel(
          error: ResponseMessage.internalServerError,
          statusCode: ResponseCode.internalServerError,
        );
      case DataSource.connectTimeout:
      case DataSource.receiveTimeout:
      case DataSource.sendTimeout:
        return ApiErrorModel(
          error: ResponseMessage.timeout,
          statusCode: ResponseCode.connectTimeout,
        );
      case DataSource.cancel:
        return ApiErrorModel(
          error: "Request canceled.",
          statusCode: ResponseCode.cancel,
        );
      case DataSource.cacheError:
        return ApiErrorModel(
          error: ResponseMessage.cacheError,
          statusCode: ResponseCode.cacheError,
        );
      case DataSource.noInternetConnection:
        return ApiErrorModel(
          error: ResponseMessage.noInternetConnection,
          statusCode: ResponseCode.noInternetConnection,
        );
      case DataSource.defaultError:
        return ApiErrorModel(
          error: ResponseMessage.defaultError,
          statusCode: ResponseCode.defaultError,
        );
    }
  }
}

/// ErrorHandler class
class ErrorHandler implements Exception {
  late ApiErrorModel apiErrorModel;

  ErrorHandler.handle(dynamic error) {
    developer.log("ErrorHandler triggered with error: $error");
    if (error is DioException) {
      apiErrorModel = _handleDioError(error);
    } else {
      // Default error
      apiErrorModel = DataSource.defaultError.getFailure();
    }
  }

  /// Helper function to handle Dio errors
  ApiErrorModel _handleDioError(DioException error) {
    developer.log("Handling DioException: ${error.type}", error: error);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return DataSource.connectTimeout.getFailure();
      case DioExceptionType.cancel:
        return DataSource.cancel.getFailure();
      case DioExceptionType.badResponse:
        return _parseErrorResponse(error.response?.data);
      case DioExceptionType.unknown:
        return _handleUnknownError(error);
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return DataSource.defaultError.getFailure();
    }
  }

  /// Parse error response from API
  ApiErrorModel _parseErrorResponse(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return ApiErrorModel.fromJson(responseData);
    } else {
      return DataSource.defaultError.getFailure();
    }
  }

  /// Handle unknown errors
  ApiErrorModel _handleUnknownError(DioException error) {
    if (error.error is String &&
        (error.error as String).contains("SocketException")) {
      return DataSource.noInternetConnection.getFailure();
    }
    return DataSource.defaultError.getFailure();
  }
}

/// ApiInternalStatus class
class ApiInternalStatus {
  static const int success = 0;
  static const int failure = 1;
}
