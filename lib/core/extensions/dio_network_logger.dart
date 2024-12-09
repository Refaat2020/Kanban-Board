import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DioNetworkLogger extends dio.Interceptor {
  @override
  void onRequest(
      dio.RequestOptions options, dio.RequestInterceptorHandler handler) {
    // TODO: implement onRequest
    super.onRequest(options, handler);
    Logger().w(
      '''
    🚀🚀 Request 🚀🚀
    URL: ${options.baseUrl}${options.path}
    Method: ${options.method}
    Headers: ${options.headers}
    Params: ${options.queryParameters}
    Body: ${options.data.toString()}
    ReceiveTimeout: ${options.receiveTimeout}
    ''',
    );
  }

  @override
  void onResponse(
    dio.Response response,
    dio.ResponseInterceptorHandler handler,
  ) {
    super.onResponse(response, handler);
    _renderCurlRepresentation(response.requestOptions);
    Logger().w(
      '''
    📜📜Response 📜📜
     URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}
    Status Code: ${response.statusCode}
    Status Message: ${response.statusMessage}
    Headers: ${response.headers}
    Response Type: ${response.requestOptions.responseType.name}
    Response Body: ${response.data}
    ''',
    );
  }

  String _cURLRepresentation(RequestOptions options) {
    List<String> components = ['curl -i'];
    if (options.method.toUpperCase() != 'GET') {
      components.add('-X ${options.method}');
    }

    options.headers.forEach((k, v) {
      if (k != 'Cookie') {
        components.add('-H "$k: $v"');
      }
    });

    if (options.data != null) {
      // FormData can't be JSON-serialized, so keep only their fields attributes
      if (options.data is FormData) {
        options.data = Map.fromEntries(options.data.fields);
      }

      final data = json.encode(options.data).replaceAll('"', '\\"');
      components.add('-d "$data"');
    }

    components.add('"${options.uri.toString()}"');

    return components.join(' \\\n\t');
  }

  void _renderCurlRepresentation(RequestOptions requestOptions) {
    // add a breakpoint here so all errors can break
    try {
      log(_cURLRepresentation(requestOptions));
    } catch (err) {
      log('unable to create a CURL representation of the requestOptions');
    }
  }
}
