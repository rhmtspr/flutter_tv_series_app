import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import 'package:core/common/network_info.dart';
import 'package:core/common/database_helper.dart';
import 'package:tv_series/data/datasources/tv_series_local_data_source.dart';
import 'package:tv_series/data/datasources/tv_series_remote_data_source.dart';
import 'package:tv_series/domain/repositories/tv_series_repository.dart';

@GenerateMocks(
  [
    TvSeriesRepository,
    TvSeriesRemoteDataSource,
    TvSeriesLocalDataSource,
    DatabaseHelper,
    NetworkInfo,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
