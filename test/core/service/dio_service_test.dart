import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board/common/model/failure_model.dart';
import 'package:kanban_board/core/config/dio_options.dart';
import 'package:kanban_board/core/services/dio_client.dart';
import 'package:kanban_board/core/services/dio_client_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dio_service_test.mocks.dart';

@GenerateMocks([Dio, DioConfigOptions, DioClient])
void main() {
  late MockDio mockDio;
  late MockDioConfigOptions configOptions;
  late DioClient dioClient;

  setUp(() {
    mockDio = MockDio();
    configOptions = MockDioConfigOptions();
    dioClient = DioClientImpl(
      dio: mockDio,
      dioConfigOptions: configOptions,
    );
    when(configOptions.getBaseOption()).thenAnswer(
        (_) async => BaseOptions(baseUrl: 'https://api.example.com'));
  });

  group('DioClient', () {
    //get Request
    test('getRequest should return data for a successful GET call', () async {
      const apiUrl = 'https://example.com/data';
      final mockResponse = Response(
        requestOptions: RequestOptions(path: apiUrl),
        statusCode: 200,
        data: {'key': 'value'},
      );

      when(
        mockDio.get(
          apiUrl,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
          onReceiveProgress: anyNamed('onReceiveProgress'),
        ),
      ).thenAnswer((_) async => mockResponse);

      final result = await dioClient.getRequest(apiUrl);

      expect(result, {'key': 'value'});
      verify(mockDio.get(
        apiUrl,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).called(1);
    });

    test('getRequest should throw FailureModel for DioException', () async {
      const apiUrl = 'https://example.com/data';
      final dioException = DioException(
        requestOptions: RequestOptions(path: apiUrl),
        type: DioExceptionType.connectionTimeout,
      );

      when(mockDio.get(
        apiUrl,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenThrow(dioException);

      expect(
        () => dioClient.getRequest(apiUrl),
        throwsA(isA<FailureModel>()),
      );
    });

    //post Request
    test('postRequest should return data for a successful POST call', () async {
      const apiUrl = 'https://example.com/data';
      final mockResponse = Response(
        requestOptions: RequestOptions(path: apiUrl),
        statusCode: 200,
        data: {'key': 'value'},
      );

      when(
        mockDio.post(
          apiUrl,
          data: {},
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
          onReceiveProgress: anyNamed('onReceiveProgress'),
        ),
      ).thenAnswer((_) async => mockResponse);

      final result = await dioClient.postRequest({}, apiUrl);

      expect(result, {'key': 'value'});
      verify(mockDio.post(
        apiUrl,
        data: {},
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).called(1);
    });

    test('postRequest should throw FailureModel for DioException', () async {
      const apiUrl = 'https://example.com/data';
      final dioException = DioException(
        requestOptions: RequestOptions(path: apiUrl),
        type: DioExceptionType.unknown,
      );

      when(mockDio.post(
        apiUrl,
        data: {},
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenThrow(dioException);

      expect(
        () => dioClient.postRequest({}, apiUrl),
        throwsA(isA<FailureModel>()),
      );
    });
  });
}
