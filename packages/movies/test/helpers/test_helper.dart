import 'package:core/common/network_info.dart';
import 'package:core/common/database_helper.dart';

import 'package:movies/data/datasources/movies_local_data_source.dart';
import 'package:movies/data/datasources/movies_remote_data_source.dart';
import 'package:movies/domain/repositories/movies_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [
    MovieRepository,
    MovieRemoteDataSource,
    MovieLocalDataSource,
    DatabaseHelper,
    NetworkInfo,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
