import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/data/connectivity/connection.dart';
import 'package:number_trivia/data/local/local.dart';
import 'package:number_trivia/data/remote/remote.dart';
import 'package:number_trivia/data/repository/number_repository_impl.dart';
import 'package:number_trivia/domain/model/Number.dart';

import '../raw/json_reader.dart';
import '../raw/single_number_response.dart';

class MockConnection extends Mock implements Connection {}

class MockLocal extends Mock implements Local {}

class MockRemote extends Mock implements Remote {}

void main() {
  MockConnection connection;
  MockLocal local;
  MockRemote remote;
  NumberRepositoryImpl repo;

  setUp(() {
    connection = MockConnection();
    local = MockLocal();
    remote = MockRemote();

    repo = NumberRepositoryImpl(
      connection: connection,
      local: local,
      remote: remote,
    );
  });

  final Either<Failure, Number> tNoInternetFailure =
      Left(NoInternetFailure('No Internet Connection'));
  final Either<Failure, Number> tServerFailure =
      Left(ServerFailure('Server Error Occured'));

  void setupInternetConnection(bool isConnected) {
    when(connection.isConnected()).thenAnswer((_) async => isConnected);
  }

  void setupLocalNumber(bool isFound) {
    if (isFound) {
      final number = Number.fromMap(jsonReader(single_number_response));
      when(local.getNumberFromLocalStorage()).thenAnswer((_) => number);
    } else {
      when(local.getNumberFromLocalStorage())
          .thenThrow(DataNotFoundException());
    }
  }

  void setupRemoteSingle(bool hasError, int number) {
    if (hasError) {
      when(remote.getSingleNumber(number: number)).thenThrow(ServerException());
    } else {
      when(remote.getSingleNumber(number: number)).thenAnswer(
        (_) async => jsonReader(single_number_response),
      );
    }
  }

  void setupRemoteRandom(bool hasError) {
    if (hasError) {
      when(remote.getRandomNumber()).thenThrow(ServerException());
    } else {
      when(remote.getRandomNumber()).thenAnswer(
        (_) async => jsonReader(single_number_response),
      );
    }
  }

  group('test repo single', () {
    final tSingleNumber = 0;
    final Either<Failure, Number> tSingleNumberTrivia =
        Right(Number.fromMap(jsonReader(single_number_response)));

    test(
      'hasInternet noLocal hasRemote',
      () async {
        // arrange
        setupInternetConnection(true);
        setupLocalNumber(false);
        setupRemoteSingle(false, tSingleNumber);

        // act
        final res = await repo.getSingleNumber(number: tSingleNumber);

        // assert
        verify(connection.isConnected());
        verify(remote.getSingleNumber(number: tSingleNumber));
        verify(local.storeNumberOffline(
            Number.fromMap(jsonReader(single_number_response))));
        expect(res, tSingleNumberTrivia);
        verifyNoMoreInteractions(connection);
        verifyNoMoreInteractions(remote);
        verifyNoMoreInteractions(local);
      },
    );

    test(
      'hasInternet noLocal noRemote',
      () async {
        // arrange
        setupInternetConnection(true);
        setupLocalNumber(false);
        setupRemoteSingle(true, tSingleNumber);

        // act
        final res = await repo.getSingleNumber(number: tSingleNumber);
        // assert
        verify(connection.isConnected());
        verify(remote.getSingleNumber(number: tSingleNumber));
        expect(res, equals(tServerFailure));
        verifyNoMoreInteractions(connection);
        verifyNoMoreInteractions(remote);
      },
    );

    test(
      'noInternet noLocal hasRemote',
      () async {
        // arrange
        setupInternetConnection(false);
        setupLocalNumber(false);
        setupRemoteSingle(true, tSingleNumber);

        // act
        final res = await repo.getSingleNumber(number: tSingleNumber);
        // assert
        verify(connection.isConnected());
        verifyZeroInteractions(remote);
        verify(local.getNumberFromLocalStorage());
        expect(res, equals(tNoInternetFailure));
        verifyNoMoreInteractions(connection);
        verifyNoMoreInteractions(remote);
        verifyNoMoreInteractions(local);
      },
    );

    test(
      'noInternet hasLocal hasRemote',
      () async {
        // arrange
        setupInternetConnection(false);
        setupLocalNumber(true);
        setupRemoteSingle(true, tSingleNumber);

        // act
        final res = await repo.getSingleNumber(number: tSingleNumber);
        // assert
        verify(connection.isConnected());
        verifyZeroInteractions(remote);
        verify(local.getNumberFromLocalStorage());
        expect(res, tSingleNumberTrivia);
        verifyNoMoreInteractions(connection);
        verifyNoMoreInteractions(remote);
        verifyNoMoreInteractions(local);
      },
    );
  });

  group('test repo random', () {
    final Either<Failure, Number> tRandomNumberTrivia =
        Right(Number.fromMap(jsonReader(single_number_response)));

    test(
      'hasInternet noLocal hasRemote',
      () async {
        // arrange
        setupInternetConnection(true);
        setupLocalNumber(false);
        setupRemoteRandom(false);

        // act
        final res = await repo.getRandomNumber();

        // assert
        verify(connection.isConnected());
        verify(remote.getRandomNumber());
        verify(local.storeNumberOffline(
            Number.fromMap(jsonReader(single_number_response))));
        expect(res, tRandomNumberTrivia);
        verifyNoMoreInteractions(connection);
        verifyNoMoreInteractions(remote);
        verifyNoMoreInteractions(local);
      },
    );

    test(
      'hasInternet noLocal noRemote',
      () async {
        // arrange
        setupInternetConnection(true);
        setupLocalNumber(false);
        setupRemoteRandom(true);

        // act
        final res = await repo.getRandomNumber();
        // assert
        verify(connection.isConnected());
        verify(remote.getRandomNumber());
        expect(res, equals(tServerFailure));
        verifyNoMoreInteractions(connection);
        verifyNoMoreInteractions(remote);
      },
    );

    test(
      'noInternet noLocal hasRemote',
      () async {
        // arrange
        setupInternetConnection(false);
        setupLocalNumber(false);
        setupRemoteRandom(true);

        // act
        final res = await repo.getRandomNumber();
        // assert
        verify(connection.isConnected());
        verifyZeroInteractions(remote);
        verify(local.getNumberFromLocalStorage());
        expect(res, equals(tNoInternetFailure));
        verifyNoMoreInteractions(connection);
        verifyNoMoreInteractions(remote);
        verifyNoMoreInteractions(local);
      },
    );

    test(
      'noInternet hasLocal hasRemote',
      () async {
        // arrange
        setupInternetConnection(false);
        setupLocalNumber(true);
        setupRemoteRandom(true);

        // act
        final res = await repo.getRandomNumber();
        // assert
        verify(connection.isConnected());
        verifyZeroInteractions(remote);
        verify(local.getNumberFromLocalStorage());
        expect(res, tRandomNumberTrivia);
        verifyNoMoreInteractions(connection);
        verifyNoMoreInteractions(remote);
        verifyNoMoreInteractions(local);
      },
    );
  });
}
