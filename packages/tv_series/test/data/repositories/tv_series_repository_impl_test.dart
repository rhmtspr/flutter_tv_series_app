import 'dart:io';
import 'package:dartz/dartz.dart';

import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:tv_series/data/models/genre_model.dart';
import 'package:tv_series/data/models/tv_series_detail_model.dart';
import 'package:tv_series/data/models/tv_series_model.dart';
import 'package:tv_series/data/repositories/tv_series_repository_impl.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;
  late MockTvSeriesLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockLocalDataSource = MockTvSeriesLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tTvSeriesModel = TvSeriesModel(
    backdropPath: '/mAJ84W6I8I272Da87qplS2Dp9ST.jpg',
    firstAirDate: '2023-01-23',
    genreIds: [9648, 18],
    id: 202250,
    name: 'Dirty Linen',
    originCountry: ['PH'],
    originalLanguage: 'tl',
    originalName: 'Dirty Linen',
    overview:
        'To exact vengeance, a young woman infiltrates the household of an influential family as a housemaid to expose their dirty secrets. However, love will get in the way of her revenge plot.',
    popularity: 2797.914,
    posterPath: '/aoAZgnmMzY9vVy9VWnO3U5PZENh.jpg',
    voteAverage: 5,
    voteCount: 13,
  );

  final tTvSeries = TvSeries(
    backdropPath: '/mAJ84W6I8I272Da87qplS2Dp9ST.jpg',
    firstAirDate: '2023-01-23',
    genreIds: [9648, 18],
    id: 202250,
    name: 'Dirty Linen',
    originCountry: ['PH'],
    originalLanguage: 'tl',
    originalName: 'Dirty Linen',
    overview:
        'To exact vengeance, a young woman infiltrates the household of an influential family as a housemaid to expose their dirty secrets. However, love will get in the way of her revenge plot.',
    popularity: 2797.914,
    posterPath: '/aoAZgnmMzY9vVy9VWnO3U5PZENh.jpg',
    voteAverage: 5,
    voteCount: 13,
  );

  final tTvSeriesModelList = <TvSeriesModel>[tTvSeriesModel];
  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('Now Playing TV Series', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.getNowPlayingTvSeries(),
      ).thenAnswer((_) async => []);
      // act
      await repository.getNowPlayingTvSeries();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getNowPlayingTvSeries(),
          ).thenAnswer((_) async => tTvSeriesModelList);
          // act
          final result = await repository.getNowPlayingTvSeries();
          // assert
          verify(mockRemoteDataSource.getNowPlayingTvSeries());
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvSeriesList);
        },
      );

      test(
        'should cache data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getNowPlayingTvSeries(),
          ).thenAnswer((_) async => tTvSeriesModelList);
          // act
          await repository.getNowPlayingTvSeries();
          // assert
          verify(mockRemoteDataSource.getNowPlayingTvSeries());
          verify(
            mockLocalDataSource.cacheNowPlayingTvSeries([testTvSeriesCache]),
          );
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getNowPlayingTvSeries(),
          ).thenThrow(ServerException());
          // act
          final result = await repository.getNowPlayingTvSeries();
          // assert
          verify(mockRemoteDataSource.getNowPlayingTvSeries());
          expect(result, equals(Left(ServerFailure(''))));
        },
      );
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(
          mockLocalDataSource.getCachedNowPlayingTvSeries(),
        ).thenAnswer((_) async => [testTvSeriesCache]);
        // act
        final result = await repository.getNowPlayingTvSeries();
        // assert
        verify(mockLocalDataSource.getCachedNowPlayingTvSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testTvSeriesFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(
          mockLocalDataSource.getCachedNowPlayingTvSeries(),
        ).thenThrow(CacheException('No Cache'));
        // act
        final result = await repository.getNowPlayingTvSeries();
        // assert
        verify(mockLocalDataSource.getCachedNowPlayingTvSeries());
        expect(result, Left(CacheFailure('No Cache')));
      });
    });
  });

  group('Popular TV Series', () {
    test(
      'should return movie list when call to data source is success',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTvSeries(),
        ).thenAnswer((_) async => tTvSeriesModelList);
        // act
        final result = await repository.getPopularTvSeries();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      },
    );

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTvSeries(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getPopularTvSeries();
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTvSeries(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getPopularTvSeries();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Top Rated TV Series', () {
    test(
      'should return movie list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTvSeries(),
        ).thenAnswer((_) async => tTvSeriesModelList);
        // act
        final result = await repository.getTopRatedTvSeries();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTvSeries(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTopRatedTvSeries();
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTvSeries(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTopRatedTvSeries();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Get TV Series Detail', () {
    final tId = 1;
    final tTvSeriesResponse = TvSeriesDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      episodeRunTime: const [60],
      firstAirDate: '2022-01-01',
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      inProduction: false,
      languages: const ['en'],
      lastAirDate: '2022-01-01',
      name: 'name',
      nextEpisodeToAir: null,
      numberOfEpisodes: 1,
      numberOfSeasons: 1,
      originCountry: const ['US'],
      originalLanguage: 'en',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1.0,
      posterPath: 'posterPath',
      status: 'Status',
      tagline: 'Tagline',
      type: 'Scripted',
      voteAverage: 1.0,
      voteCount: 1,
    );

    test(
      'should return Movie data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesDetail(tId),
        ).thenAnswer((_) async => tTvSeriesResponse);
        // act
        final result = await repository.getTvSeriesDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesDetail(tId));
        expect(result, equals(Right(testTvSeriesDetail)));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesDetail(tId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTvSeriesDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesDetail(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesDetail(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvSeriesDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesDetail(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Get TV Series Recommendations', () {
    final tTvSeriesList = <TvSeriesModel>[];
    final tId = 1;

    test(
      'should return data (tv series list) when the call is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesRecommendations(tId),
        ).thenAnswer((_) async => tTvSeriesList);
        // act
        final result = await repository.getTvSeriesRecommendations(tId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesRecommendations(tId));
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tTvSeriesList));
      },
    );

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesRecommendations(tId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTvSeriesRecommendations(tId);
        // assertbuild runner
        verify(mockRemoteDataSource.getTvSeriesRecommendations(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTvSeriesRecommendations(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvSeriesRecommendations(tId);
        // assert
        verify(mockRemoteDataSource.getTvSeriesRecommendations(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Seach TV Series', () {
    final tQuery = 'Dirty Linen';

    test(
      'should return movie list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvSeries(tQuery),
        ).thenAnswer((_) async => tTvSeriesModelList);
        // act
        final result = await repository.searchTvSeries(tQuery);
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvSeriesList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvSeries(tQuery),
        ).thenThrow(ServerException());
        // act
        final result = await repository.searchTvSeries(tQuery);
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTvSeries(tQuery),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.searchTvSeries(tQuery);
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(
        mockLocalDataSource.insertWatchlistTv(testTvSeriesTable),
      ).thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlistTvSeries(testTvSeriesDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(
        mockLocalDataSource.insertWatchlistTv(testTvSeriesTable),
      ).thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlistTvSeries(testTvSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(
        mockLocalDataSource.removeWatchlistTv(testTvSeriesTable),
      ).thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlistTvSeries(
        testTvSeriesDetail,
      );
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(
        mockLocalDataSource.removeWatchlistTv(testTvSeriesTable),
      ).thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlistTvSeries(
        testTvSeriesDetail,
      );
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(
        mockLocalDataSource.getTvSeriesById(tId),
      ).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlistTvSeries(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist TV Series', () {
    test('should return list of Movies', () async {
      // arrange
      when(
        mockLocalDataSource.getWatchlistTvSeries(),
      ).thenAnswer((_) async => [testTvSeriesTable]);
      // act
      final result = await repository.getWatchlistTvSeries();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTvSeries]);
    });
  });
}
