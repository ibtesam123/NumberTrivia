import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../core/error/failure.dart';
import '../model/Number.dart';

abstract class NumberRepository {
  Future<Either<Failure, Number>> getSingleNumber({@required int number});

  Future<Either<Failure, Number>> getRandomNumber();

  void cancelAllRequests();
}
