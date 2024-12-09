import 'package:dio/dio.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/core/config/dio_options.dart';
import 'package:kanban_board/core/extensions/response_methods.dart';
import 'package:kanban_board/core/services/dio_client.dart';
//
// class DioClient {
//   Dio dio = Dio()..interceptors.add(DioNetworkLogger());
//
//   Future<dynamic> getRequest(String apiUrl,
//       {Map<String, dynamic>? prams, bool? responseBytes}) async {
//     try {
//       dio.options = await DioConfigOptions.getBaseOption();
//       Response response = prams == null
//           ? await dio.get(apiUrl,
//               options: Options(
//                   responseType:
//                       responseBytes == true ? ResponseType.bytes : null))
//           : await dio.get(apiUrl,
//               queryParameters: prams,
//               options: Options(
//                   responseType:
//                       responseBytes == true ? ResponseType.bytes : null));
//
//       return response.handleResponse();
//     } catch (e) {
//       if (e is DioException) {
//         throw FailureModel(
//           message: e.handleDioException(e.type),
//           state: 0,
//         );
//       }
//       throw Exception(e);
//     }
//   }
//
//   /*
//    * Post Request Function
//    */
//   Future<dynamic> postRequest(body, String apiUrl,
//       {bool hasImages = false}) async {
//     try {
//       dio.options = await DioConfigOptions.getBaseOption();
//       Response response = await dio.post(apiUrl,
//           data: hasImages == true ? FormData.fromMap(body) : body);
//       return response.handleResponse();
//     } catch (e) {
//       if (e is DioException) {
//         throw FailureModel(
//           message: e.handleDioException(e.type),
//           state: 0,
//         );
//       }
//       throw Exception(e);
//     }
//   }
// }

class DioClientImpl implements DioClient {
  final Dio dio;
  final DioConfigOptions dioConfigOptions;

  DioClientImpl({required this.dio, required this.dioConfigOptions});

  Future<dynamic> _handleRequest(Future<Response> Function() request) async {
    try {
      dio.options = await dioConfigOptions.getBaseOption();
      final response = await request();
      return response.handleResponse();
    } catch (e) {
      if (e is DioException) {
        throw FailureModel(
          message: e.handleDioException(e.type),
          state: 0,
        );
      }
      throw Exception(e);
    }
  }

  @override
  Future<dynamic> getRequest(String apiUrl,
      {Map<String, dynamic>? prams, bool? responseBytes}) async {
    return _handleRequest(() => dio.get(apiUrl,
        queryParameters: prams,
        options: Options(
            responseType: responseBytes == true ? ResponseType.bytes : null)));
  }

  @override
  Future<dynamic> postRequest(dynamic body, String apiUrl,
      {bool hasImages = false}) async {
    if (apiUrl.isEmpty) {
      throw ArgumentError('API URL cannot be empty.');
    }
    if (body == null) {
      throw ArgumentError('Body cannot be null for POST requests.');
    }
    return _handleRequest(() => dio.post(apiUrl,
        data: hasImages == true ? FormData.fromMap(body) : body));
  }
}
