import 'dart:convert';
import 'package:flutter_tv_series_app/data/datasources/tv_series_remote_data_source.dart';
import 'package:flutter_tv_series_app/data/models/movie_detail_model.dart';
import 'package:flutter_tv_series_app/data/models/movie_response.dart';
import 'package:flutter_tv_series_app/common/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tv_series_app/data/models/tv_series_response.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing TV Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/now_playing_tv_series.json')),
    ).tvSeriesList;

    test(
      'should return list of TV Series Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/now_playing_tv_series.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getNowPlayingTvSeries();
        // assert
        expect(result, equals(tTvSeriesList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getNowPlayingTvSeries();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Popular TV Series', () {
    final tMovieList = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/popular.json')),
    ).movieList;

    test(
      'should return list of movies when response is success (200)',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/movie/popular?$API_KEY')),
        ).thenAnswer(
          (_) async => http.Response(readJson('dummy_data/popular.json'), 200),
        );
        // act
        final result = await dataSource.getPopularTvSeries();
        // assert
        expect(result, tMovieList);
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/movie/popular?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getPopularTvSeries();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Top Rated Movies', () {
    final tMovieList = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/top_rated.json')),
    ).movieList;

    test('should return list of movies when response code is 200 ', () async {
      // arrange
      when(
        mockHttpClient.get(Uri.parse('$BASE_URL/movie/top_rated?$API_KEY')),
      ).thenAnswer(
        (_) async => http.Response(readJson('dummy_data/top_rated.json'), 200),
      );
      // act
      final result = await dataSource.getTopRatedTvSeries();
      // assert
      expect(result, tMovieList);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/movie/top_rated?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTopRatedTvSeries();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get movie detail', () {
    final tId = 1;
    final tMovieDetail = MovieDetailResponse.fromJson(
      json.decode(readJson('dummy_data/movie_detail.json')),
    );

    test('should return movie detail when the response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(Uri.parse('$BASE_URL/movie/$tId?$API_KEY')),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/movie_detail.json'), 200),
      );
      // act
      final result = await dataSource.getTvSeriesDetail(tId);
      // assert
      expect(result, equals(tMovieDetail));
    });

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/movie/$tId?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvSeriesDetail(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get movie recommendations', () {
    final tMovieList = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/movie_recommendations.json')),
    ).movieList;
    final tId = 1;

    test(
      'should return list of Movie Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$BASE_URL/movie/$tId/recommendations?$API_KEY'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/movie_recommendations.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getTvSeriesRecommendations(tId);
        // assert
        expect(result, equals(tMovieList));
      },
    );

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$BASE_URL/movie/$tId/recommendations?$API_KEY'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvSeriesRecommendations(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('search movies', () {
    final tSearchResult = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/search_spiderman_movie.json')),
    ).movieList;
    final tQuery = 'Spiderman';

    test('should return list of movies when response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse('$BASE_URL/search/movie?$API_KEY&query=$tQuery'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/search_spiderman_movie.json'),
          200,
        ),
      );
      // act
      final result = await dataSource.searchTvSeries(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$BASE_URL/search/movie?$API_KEY&query=$tQuery'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.searchTvSeries(tQuery);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
