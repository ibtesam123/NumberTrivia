import 'package:flutter/material.dart';

abstract class Remote {
  Future<Map<String, dynamic>> getSingleNumber({@required int number});

  Future<Map<String, dynamic>> getRandomNumber();

  void cancelAllRequests();
}
