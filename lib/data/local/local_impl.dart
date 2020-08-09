import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../core/constants.dart';
import '../../core/error/exception.dart';
import '../../domain/model/Number.dart';
import 'local.dart';

class LocalImpl implements Local {
  final Box numberBox;

  LocalImpl({@required this.numberBox});

  @override
  Number getNumberFromLocalStorage() {
    try {
      Number number = numberBox.get(kNumber);
      if (number == null)
        throw DataNotFoundException();
      else
        return number;
    } catch (e) {
      if (e is DataNotFoundException) {
        print('[LOCAL IMPL] Throwing DataNotFound');
        throw DataNotFoundException();
      } else {
        print('[LOCAL IMPL] Throwing CacheException');
        throw CacheException();
      }
    }
  }

  @override
  void storeNumberOffline(Number number) {
    if (number != null) {
      try {
        numberBox.put(kNumber, number);
      } catch (e) {
        print('[LOCAL IMPL] Error: $e');
        throw CacheException();
      }
    } else {
      throw DataNotFoundException();
    }
  }
}
