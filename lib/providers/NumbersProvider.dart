import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../core/error/failure.dart';
import '../domain/model/Number.dart';
import '../domain/repository/NumberRepository.dart';

class NumbersProvider extends ChangeNotifier {
  final NumberRepository numberRepo;
  NumbersProvider({@required this.numberRepo});

  bool _isLoading = false;
  Either<Failure, Number> _numberTrivia =
      Left(EmptyFailure('Enter a number to get started'));

  bool get isLoading => _isLoading;
  Either<Failure, Number> get numberTrivia => _numberTrivia;

  void getSingleNumber({@required int number}) async {
    _isLoading = true;
    notifyListeners();

    _numberTrivia = await numberRepo.getSingleNumber(number: number);

    _isLoading = false;
    notifyListeners();
  }

  void getRandomNumber() async {
    _isLoading = true;
    notifyListeners();

    _numberTrivia = await numberRepo.getRandomNumber();

    _isLoading = false;
    notifyListeners();
  }

  void cancelAllRequests() => numberRepo.cancelAllRequests();
}
