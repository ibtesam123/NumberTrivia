import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../core/error/exception.dart';
import '../../core/error/failure.dart';
import '../../domain/model/Number.dart';
import '../../domain/repository/NumberRepository.dart';
import '../connectivity/connection.dart';
import '../local/local.dart';
import '../remote/remote.dart';

class NumberRepositoryImpl implements NumberRepository {
  final Connection connection;
  final Local local;
  final Remote remote;

  NumberRepositoryImpl({
    @required this.connection,
    @required this.local,
    @required this.remote,
  });

  @override
  Future<Either<Failure, Number>> getRandomNumber() async {
    Number numberTrivia;
    try {
      if (await connection.isConnected()) {
        //Check for internet connection

        //Get Number Trivia from Server
        final res = await remote.getRandomNumber();
        numberTrivia = Number.fromMap(res);

        //Store the Number Trivia offline
        local.storeNumberOffline(numberTrivia);

        //Return the Number Trivia
        return Right(numberTrivia);
      } else {
        // Internet Connection not found so get NUmber Trivia from local storage
        numberTrivia = local.getNumberFromLocalStorage();
        return Right(numberTrivia);
      }
    } on ServerException catch (_) {
      // Error occured while fetching from server
      return Left(ServerFailure('Server Error Occured'));
    } on DataNotFoundException catch (_) {
      // Data not found in local storage so return No Connection error
      return Left(NoInternetFailure('No Internet Connection'));
    } on CacheException catch (_) {
      //Number cannot be stored offline so ignore it and send the number fetched from internet
      return Right(numberTrivia);
    } catch (e) {
      // Some other error occured
      return Left(ServerFailure('Server Error'));
    }
  }

  @override
  Future<Either<Failure, Number>> getSingleNumber({int number}) async {
    Number numberTrivia;
    try {
      if (await connection.isConnected()) {
        //Check for internet connection

        //Get Number Trivia from Server
        final res = await remote.getSingleNumber(number: number);
        numberTrivia = Number.fromMap(res);

        //Store the Number Trivia offline
        local.storeNumberOffline(numberTrivia);

        //Return the Number Trivia
        return Right(numberTrivia);
      } else {
        // Internet Connection not found so get NUmber Trivia from local storage
        numberTrivia = local.getNumberFromLocalStorage();
        return Right(numberTrivia);
      }
    } on ServerException catch (_) {
      // Error occured while fetching from server
      return Left(ServerFailure('Server Error Occured'));
    } on DataNotFoundException catch (_) {
      // Data not found in local storage so return No Connection error
      return Left(NoInternetFailure('No Internet Connection'));
    } on CacheException catch (_) {
      //Number cannot be stored offline so ignore it and send the number fetched from internet
      return Right(numberTrivia);
    } catch (e) {
      // Some other error occured
      return Left(ServerFailure('Server Error Occured'));
    }
  }

  @override
  void cancelAllRequests() {
    remote.cancelAllRequests();
  }
}
