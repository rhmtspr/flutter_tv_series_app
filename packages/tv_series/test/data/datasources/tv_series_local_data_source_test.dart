import 'package:core/common/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/data/datasources/tv_series_local_data_source.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvSeriesLocalDataSourceImpl(
      databaseHelper: mockDatabaseHelper,
    );
  });

  group('save watchlist', () {
    test(
      'should return success message when insert to database is success',
      () async {
        // arrange
        when(
          mockDatabaseHelper.insertWatchlistTv(testTvSeriesTable),
        ).thenAnswer((_) async => 1);
        // act
        final result = await dataSource.insertWatchlistTv(testTvSeriesTable);
        // assert
        expect(result, 'Added to Watchlist');
      },
    );

    test(
      'should throw DatabaseException when insert to database is failed',
      () async {
        // arrange
        when(
          mockDatabaseHelper.insertWatchlistTv(testTvSeriesTable),
        ).thenThrow(Exception());
        // act
        final call = dataSource.insertWatchlistTv(testTvSeriesTable);
        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('remove watchlist', () {
    test(
      'should return success message when remove from database is success',
      () async {
        // arrange
        when(
          mockDatabaseHelper.removeWatchlistTv(testTvSeriesTable),
        ).thenAnswer((_) async => 1);
        // act
        final result = await dataSource.removeWatchlistTv(testTvSeriesTable);
        // assert
        expect(result, 'Removed from Watchlist');
      },
    );

    test(
      'should throw DatabaseException when remove from database is failed',
      () async {
        // arrange
        when(
          mockDatabaseHelper.removeWatchlistTv(testTvSeriesTable),
        ).thenThrow(Exception());
        // act
        final call = dataSource.removeWatchlistTv(testTvSeriesTable);
        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('Get TV Series Detail By Id', () {
    final tId = 1;

    test('should return TV Series Detail Table when data is found', () async {
      // arrange
      when(
        mockDatabaseHelper.getTvSeriesById(tId),
      ).thenAnswer((_) async => testTvSeriesMap);
      // act
      final result = await dataSource.getTvSeriesById(tId);
      // assert
      expect(result, testTvSeriesTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(
        mockDatabaseHelper.getTvSeriesById(tId),
      ).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTvSeriesById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist TV Series', () {
    test('should return list of TvSeriesTable from database', () async {
      // arrange
      when(
        mockDatabaseHelper.getWatchlistTvSeries(),
      ).thenAnswer((_) async => [testTvSeriesMap]);
      // act
      final result = await dataSource.getWatchlistTvSeries();
      // assert
      expect(result, [testTvSeriesTable]);
    });
  });

  group('cache now playing TV Series', () {
    test('should call database helper to save data', () async {
      // arrange
      when(
        mockDatabaseHelper.clearCacheTvSeries('now playing'),
      ).thenAnswer((_) async => 1);
      // act
      await dataSource.cacheNowPlayingTvSeries([testTvSeriesCache]);
      // assert
      verify(mockDatabaseHelper.clearCacheTvSeries('now playing'));
      verify(
        mockDatabaseHelper.insertCacheTransactionTvSeries([
          testTvSeriesCache,
        ], 'now playing'),
      );
    });

    test('should return list of TV Series from db when data exist', () async {
      // arrange
      when(
        mockDatabaseHelper.getCacheTvSeries('now playing'),
      ).thenAnswer((_) async => [testTvSeriesCacheMap]);
      // act
      final result = await dataSource.getCachedNowPlayingTvSeries();
      // assert
      expect(result, [testTvSeriesCache]);
    });

    test('should throw CacheException when cache data is not exist', () async {
      // arrange
      when(
        mockDatabaseHelper.getCacheTvSeries('now playing'),
      ).thenAnswer((_) async => []);
      // act
      final call = dataSource.getCachedNowPlayingTvSeries();
      // assert
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });
}
