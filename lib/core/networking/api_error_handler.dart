import 'package:dio/dio.dart';
import 'api_error_model.dart';

class ErrorHandler implements Exception {
  late ApiErrorModel apiErrorModel;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      apiErrorModel = _handleError(error);
    } else {
      apiErrorModel = ApiErrorModel(
        message: 'Unexpected error occurred',
        code: -7,
      );
    }
  }
}

ApiErrorModel _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return ApiErrorModel(message: 'Connection timed out', code: -1);
    case DioExceptionType.sendTimeout:
      return ApiErrorModel(message: 'Send timed out', code: -4);
    case DioExceptionType.receiveTimeout:
      return ApiErrorModel(message: 'Receive timed out', code: -3);
    case DioExceptionType.badResponse:
      if (error.response?.data != null) {
        return ApiErrorModel(
          message:
              error.response!.data['error'] ?? error.response!.data.toString(),
        );
      }
      return ApiErrorModel(
        message: 'Bad server response',
        code: error.response?.statusCode,
      );
    case DioExceptionType.cancel:
      return ApiErrorModel(message: 'Request cancelled', code: -2);
    case DioExceptionType.connectionError:
      return ApiErrorModel(message: 'No internet connection', code: -6);
    case DioExceptionType.badCertificate:
      return ApiErrorModel(message: 'Invalid certificate', code: -7);
    case DioExceptionType.transformTimeout:
      return ApiErrorModel(message: 'Transform timed out', code: -8);
    case DioExceptionType.unknown:
      if (error.response?.data != null) {
        return ApiErrorModel(
          message:
              error.response!.data['error'] ?? error.response!.data.toString(),
        );
      }
      return ApiErrorModel(
        message: 'Unknown error',
        code: error.response?.statusCode,
      );
    default:
      return ApiErrorModel(
        message: 'Unknown error',
        code: error.response?.statusCode,
      );
  }
}
