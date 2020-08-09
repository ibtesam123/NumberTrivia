import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'connection.dart';

class ConnectionImpl implements Connection {
  final DataConnectionChecker connectionChecker;

  ConnectionImpl({@required this.connectionChecker});

  @override
  Future<bool> isConnected() {
    return connectionChecker.hasConnection;
  }
}
