import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import '../../core/error/exception.dart';
import 'remote.dart';

class RemoteImpl implements Remote {
  final Dio dio;
  final CancelToken cancelToken;
  final RemoteConfig remoteConfig;
  RemoteImpl({
    @required this.dio,
    @required this.cancelToken,
    @required this.remoteConfig,
  });

  String singleNumberURL({@required int number}) {
    String apiURL = remoteConfig.getString('apiURL');
    apiURL = apiURL.substring(1, apiURL.length - 1);
    return apiURL + '$number?json';
  }

  String randomNumberURL() {
    String apiURL = remoteConfig.getString('apiURL');
    apiURL = apiURL.substring(1, apiURL.length - 1);
    return apiURL + 'random?json';
  }

  @override
  Future<Map<String, dynamic>> getRandomNumber() async {
    try {
      print(randomNumberURL());
      final res = await dio.get(
        randomNumberURL(),
        cancelToken: cancelToken,
      );
      if (res.statusCode == 200)
        return res.data;
      else
        throw ServerException();
    } on DioError catch (e) {
      print('[REMOTE IMPL] Dio Error: ${e.message}');
      throw ServerException();
    } catch (e) {
      print('[REMOTE IMPL] Error: $e');
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getSingleNumber({int number}) async {
    try {
      final res = await dio.get(
        singleNumberURL(number: number),
        cancelToken: cancelToken,
      );
      if (res.statusCode == 200)
        return res.data;
      else {
        print('[REMOTE IMPL] Response Status: ${res.statusCode}');
        throw ServerException();
      }
    } on DioError catch (e) {
      print('[REMOTE IMPL] Dio Error: ${e.message}');
      throw ServerException();
    } catch (e) {
      print('[REMOTE IMPL] Error: $e');
      throw ServerException();
    }
  }

  @override
  void cancelAllRequests() {
    cancelToken.cancel();
  }
}
