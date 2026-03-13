import 'package:flutter_tv_series_app/common/network_info.dart';
import 'package:flutter_tv_series_app/data/datasources/movies_local_data_source.dart';
import 'package:flutter_tv_series_app/data/datasources/db/database_helper.dart';
import 'package:flutter_tv_series_app/data/datasources/movies_remote_data_source.dart';
import 'package:flutter_tv_series_app/data/datasources/tv_series_local_data_source.dart';
import 'package:flutter_tv_series_app/data/datasources/tv_series_remote_data_source.dart';
import 'package:flutter_tv_series_app/domain/repositories/movies_repository.dart';
import 'package:flutter_tv_series_app/domain/repositories/tv_series_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [
    MovieRepository,
    MovieRemoteDataSource,
    MovieLocalDataSource,
    TvSeriesRepository,
    TvSeriesRemoteDataSource,
    TvSeriesLocalDataSource,
    DatabaseHelper,
    NetworkInfo,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
