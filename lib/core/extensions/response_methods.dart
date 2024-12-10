import 'package:dio/dio.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/core/constants/app_strings.dart';

extension ResponseHandler on Response {
  dynamic handleResponse() async {
    if (statusCode == 500) {
      throw FailureModel(
        message: data["error"],
        state: statusCode,
      );
    } else if (statusCode! > 299) {
      throw FailureModel(
        message: data,
        state: statusCode,
      );
    } else {
      return data;
    }
  }
}

extension DioExceptionHandler on DioException {
  String handleDioException(DioExceptionType dioExceptionType) {
    const dioErrorTypes = {
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.badCertificate,
      DioExceptionType.badResponse,
      DioExceptionType.cancel,
    };

    if (dioErrorTypes.contains(dioExceptionType)) {
      return AppStrings.dioError;
    }

    switch (dioExceptionType) {
      case DioExceptionType.connectionError:
        return AppStrings.networkError;
      default:
        return AppStrings.unknownError;
    }
  }
}
