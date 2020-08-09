import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/data/remote/remote_impl.dart';

import '../raw/json_reader.dart';
import '../raw/random_number_response.dart';
import '../raw/single_number_response.dart';

class MockDioClient extends Mock implements Dio {}

class MockCancelToken extends Mock implements CancelToken {}

class MockRemoteConfig extends Mock implements RemoteConfig {}

void main() {
  RemoteImpl remoteImpl;
  MockDioClient dio;
  MockCancelToken cancelToken;
  MockRemoteConfig remoteConfig;

  setUp(() {
    dio = MockDioClient();
    cancelToken = MockCancelToken();
    remoteConfig = MockRemoteConfig();
    when(remoteConfig.getString(any))
        .thenAnswer((_) => '"http://numbersapi.com/"');
    remoteImpl = RemoteImpl(
      dio: dio,
      cancelToken: cancelToken,
      remoteConfig: remoteConfig,
    );
  });

  group('Single Number Test', () {
    String tURL = 'http://numbersapi.com/0?json';

    void setUpSuccess() async {
      final res = Response(
        statusCode: 200,
        data: jsonReader(single_number_response),
      );

      when(dio.get(tURL, cancelToken: cancelToken))
          .thenAnswer((_) async => res);
    }

    void setupError() async {
      final res = Response(
        statusCode: 400,
        statusMessage: 'An error occured',
      );
      when(dio.get(tURL, cancelToken: cancelToken))
          .thenAnswer((_) async => res);
    }

    final tSingleNumber = 0;
    final tMap = jsonReader(single_number_response);

    test(
      'test single number when no error occurs',
      () async {
        // arrange
        setUpSuccess();

        // act
        final res = await remoteImpl.getSingleNumber(number: tSingleNumber);

        // assert
        verify(dio.get('http://numbersapi.com/$tSingleNumber?json',
            cancelToken: cancelToken));

        expect(res, tMap);
      },
    );

    test(
      'test single number when dio error occurs',
      () async {
        // arrange
        setupError();

        // act
        final call = remoteImpl.getSingleNumber;

        // assert
        expect(
            () => call(number: tSingleNumber), throwsA(isA<ServerException>()));
      },
    );
  });

  group('Random Number Test', () {
    String tURL = 'http://numbersapi.com/random?json';

    void setUpSuccess() async {
      final res = Response(
        statusCode: 200,
        data: jsonReader(random_number_response),
      );

      when(dio.get(tURL, cancelToken: cancelToken))
          .thenAnswer((_) async => res);
    }

    void setupError() async {
      final res = Response(
        statusCode: 400,
        statusMessage: 'An error occured',
      );
      when(dio.get(tURL, cancelToken: cancelToken))
          .thenAnswer((_) async => res);
    }

    final tMap = jsonReader(random_number_response);

    test(
      'test random number when no error occurs',
      () async {
        // arrange
        setUpSuccess();

        // act
        final res = await remoteImpl.getRandomNumber();

        // assert
        verify(dio.get(tURL, cancelToken: cancelToken));

        expect(res, tMap);
      },
    );

    test(
      'test random number when dio error occurs',
      () async {
        // arrange
        setupError();

        // act
        final call = remoteImpl.getRandomNumber;

        // assert
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );
  });
}
