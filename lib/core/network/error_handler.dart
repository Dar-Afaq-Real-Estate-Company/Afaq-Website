import 'package:dio/dio.dart';

import 'api_error_model.dart';

class ApiErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    try {
      // If the error is already your ApiErrorModel, return it directly
      if (error is ApiErrorModel) return error;

      // Dio exceptions (network / HTTP)
      if (error is DioException) {
        switch (error.type) {
          case DioExceptionType.connectionError:
            return ApiErrorModel(message: "Connection to server failed");
          case DioExceptionType.cancel:
            return ApiErrorModel(
                message: "Request to the server was cancelled");
          case DioExceptionType.connectionTimeout:
            return ApiErrorModel(message: "Connection timeout with the server");
          case DioExceptionType.unknown:
            return ApiErrorModel(
                message:
                    "Connection to the server failed due to internet connection");
          case DioExceptionType.receiveTimeout:
            return ApiErrorModel(
                message: "Receive timeout in connection with the server");
          case DioExceptionType.badResponse:
            return _handleError(error.response?.data);
          case DioExceptionType.sendTimeout:
            return ApiErrorModel(
                message: "Send timeout in connection with the server");
          default:
            return ApiErrorModel(message: "Something went wrong");
        }
      }

      // Fallback for other types (String, Map, Exception, int, List, etc.)
      return _handleError(error);
    } catch (_) {
      return ApiErrorModel(message: "Unknown error occurred");
    }
  }

  static ApiErrorModel _handleError(dynamic error) {
    try {
      if (error == null) {
        return ApiErrorModel(message: "Unknown error occurred");
      }

      // If it's already ApiErrorModel inside nested data
      if (error is ApiErrorModel) return error;

      // String
      if (error is String && error.trim().isNotEmpty) {
        return ApiErrorModel(message: error);
      }

      // Numbers & booleans
      if (error is num || error is bool) {
        return ApiErrorModel(message: error.toString());
      }

      // Exception
      if (error is Exception) {
        return ApiErrorModel(message: error.toString());
      }

      // List -> try first element
      if (error is List && error.isNotEmpty) {
        return _handleError(error.first);
      }

      // Map -> try common keys and nested structures
      if (error is Map) {
        // Laravel validation style: { "message": "The given data was invalid.",
        // "errors": { "phone": ["The phone has already been taken."] } }
        // نتحقق من "errors" أولاً لأنها تحمل الرسالة الفعلية المفيدة،
        // بعكس "message" العام اللي ما يذكر السبب الحقيقي
        if (error.containsKey('errors') && error['errors'] != null) {
          final errs = error['errors'];
          if (errs is Map && errs.isNotEmpty) {
            final first = errs.values.first;
            return _handleError(first);
          } else if (errs is List && errs.isNotEmpty) {
            return _handleError(errs.first);
          }
        }

        final keysToCheck = [
          'message',
          'error',
          'msg',
          'detail',
          'description',
          'data'
        ];
        for (final k in keysToCheck) {
          if (error.containsKey(k) && error[k] != null) {
            return _handleError(error[k]);
          }
        }

        // As a last resort, stringify the map
        return ApiErrorModel(message: error.toString());
      }

      // Default fallback
      return ApiErrorModel(message: error.toString());
    } catch (_) {
      return ApiErrorModel(message: "Unknown error occurred");
    }
  }
}

// class ApiErrorHandler {
//   static ApiErrorModel handle(dynamic error) {
//     if (error is DioException) {
//       switch (error.type) {
//         case DioExceptionType.connectionError:
//           return ApiErrorModel(message: "Connection to server failed");
//         case DioExceptionType.cancel:
//           return ApiErrorModel(message: "Request to the server was cancelled");
//         case DioExceptionType.connectionTimeout:
//           return ApiErrorModel(message: "Connection timeout with the server");
//         case DioExceptionType.unknown:
//           return ApiErrorModel(
//               message:
//                   "Connection to the server failed due to internet connection");
//         case DioExceptionType.receiveTimeout:
//           return ApiErrorModel(
//               message: "Receive timeout in connection with the server");
//         case DioExceptionType.badResponse:
//           return _handleError(error.response?.data);
//         case DioExceptionType.sendTimeout:
//           return ApiErrorModel(
//               message: "Send timeout in connection with the server");
//         default:
//           return ApiErrorModel(message: "Something went wrong");
//       }
//     } else {
//       return ApiErrorModel(message: "Unexpected error occurred");
//     }
//   }

//   static ApiErrorModel _handleError(dynamic error) {
//     return ApiErrorModel(
//       message: error['message'] ?? "Unknown error occurred",
//     );
//   }
// }
