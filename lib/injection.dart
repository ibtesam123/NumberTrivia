import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'core/constants.dart';
import 'data/connectivity/connection.dart';
import 'data/connectivity/connection_impl.dart';
import 'data/local/local.dart';
import 'data/local/local_impl.dart';
import 'data/remote/remote.dart';
import 'data/remote/remote_impl.dart';
import 'data/repository/number_repository_impl.dart';
import 'domain/model/Number.dart';
import 'domain/repository/NumberRepository.dart';
import 'providers/NumbersProvider.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  // Registering all 3rd party dependencies
  getIt.registerLazySingleton(() => DataConnectionChecker());
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => CancelToken());

  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  await remoteConfig.fetch(expiration: Duration(hours: 1));
  await remoteConfig.activateFetched();

  getIt.registerLazySingleton(() => remoteConfig);

  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDirectory.path)
    ..registerAdapter(NumberAdapter());
  final numberBox = await Hive.openBox(kNumberBox);

  // Registering Data Sources
  getIt.registerLazySingleton<Connection>(
    () => ConnectionImpl(connectionChecker: getIt()),
  );
  getIt.registerLazySingleton<Local>(
    () => LocalImpl(numberBox: numberBox),
  );
  getIt.registerLazySingleton<Remote>(
    () => RemoteImpl(
      dio: getIt(),
      cancelToken: getIt(),
      remoteConfig: getIt(),
    ),
  );

  // Registering Repositories
  getIt.registerLazySingleton<NumberRepository>(
    () => NumberRepositoryImpl(
      connection: getIt(),
      local: getIt(),
      remote: getIt(),
    ),
  );

  // Registering Providers
  getIt.registerSingleton(
    NumbersProvider(numberRepo: getIt()),
  );
}
