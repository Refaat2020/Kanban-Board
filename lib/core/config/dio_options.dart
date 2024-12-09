import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';

class DioConfigOptions {
  Future<BaseOptions> getBaseOption() async {
    return BaseOptions(
      baseUrl: dotenv.env['API_URL']!,
      connectTimeout: const Duration(milliseconds: 80000),
      receiveTimeout: const Duration(milliseconds: 80000),
      followRedirects: false,
      validateStatus: (status) {
        return status! <= 500;
      },
      headers: {
        'Content-type': 'application/json',
        "X-Request-Id": const Uuid().v4(),
        "Accept": "text/plain",
        'authorization': "Bearer ${dotenv.env['API_KEY']!}",
        "accept": "application/json",
      },
    );
  }
}
