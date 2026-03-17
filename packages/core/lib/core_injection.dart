import 'package:core/common/database_helper.dart';
import 'package:core/common/network_info.dart';
import 'package:core/common/ssl_pinning.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

Future<void> initCoreInjection() async {
  final client = await SSLPinning.ioClient;

  locator.registerSingleton<http.Client>(client);

  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));
  locator.registerLazySingleton(() => DataConnectionChecker());
}
