import 'package:dartz/dartz.dart';
import 'package:flutter_tv_series_app/common/failure.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_tv_series_detail.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_tv_series_recommendations.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/save_watchlist_tv_series.dart';
import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tv_series_app/presentation/provider/tv_series_detail_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchListStatusTv,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late TvSeriesDetailNotifier provider;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchListStatusTv mockGetWatchlistStatusTv;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchlistStatusTv = MockGetWatchListStatusTv();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    provider =
        TvSeriesDetailNotifier(
          getTvSeriesDetail: mockGetTvSeriesDetail,
          getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
          getWatchListStatusTv: mockGetWatchlistStatusTv,
          saveWatchlistTv: mockSaveWatchlistTv,
          removeWatchlistTv: mockRemoveWatchlistTv,
        )..addListener(() {
          listenerCallCount += 1;
        });
  });

  final tId = 1;

  final tTvSeries = TvSeries(
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: ['originCountry'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvSeriesList = <TvSeries>[tTvSeries];

  void _arrangeUsecase() {
    when(
      mockGetTvSeriesDetail.execute(tId),
    ).thenAnswer((_) async => Right(testTvSeriesDetail));
    when(
      mockGetTvSeriesRecommendations.execute(tId),
    ).thenAnswer((_) async => Right(tTvSeriesList));
  }

  group('Get Movie Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      verify(mockGetTvSeriesDetail.execute(tId));
      verify(mockGetTvSeriesRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchTvSeriesDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change movie when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Loaded);
      expect(provider.tv, testTvSeriesDetail);
      expect(listenerCallCount, 3);
    });

    test(
      'should change recommendation movies when data is gotten successfully',
      () async {
        // arrange
        _arrangeUsecase();
        // act
        await provider.fetchTvSeriesDetail(tId);
        // assert
        expect(provider.tvState, RequestState.Loaded);
        expect(provider.tvSeriesRecommendations, tTvSeriesList);
      },
    );
  });

  group('Get Movie Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      verify(mockGetTvSeriesRecommendations.execute(tId));
      expect(provider.tvSeriesRecommendations, tTvSeriesList);
    });

    test(
      'should update recommendation state when data is gotten successfully',
      () async {
        // arrange
        _arrangeUsecase();
        // act
        await provider.fetchTvSeriesDetail(tId);
        // assert
        expect(provider.tvSeriesRecommendationState, RequestState.Loaded);
        expect(provider.tvSeriesRecommendations, tTvSeriesList);
      },
    );

    test('should update error message when request in successful', () async {
      // arrange
      when(
        mockGetTvSeriesDetail.execute(tId),
      ).thenAnswer((_) async => Right(testTvSeriesDetail));
      when(
        mockGetTvSeriesRecommendations.execute(tId),
      ).thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      expect(provider.tvSeriesRecommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatusTv.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatusTvSeries(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(
        mockSaveWatchlistTv.execute(testTvSeriesDetail),
      ).thenAnswer((_) async => Right('Success'));
      when(
        mockGetWatchlistStatusTv.execute(testTvSeriesDetail.id),
      ).thenAnswer((_) async => true);
      // act
      await provider.addWatchlistTvSeries(testTvSeriesDetail);
      // assert
      verify(mockSaveWatchlistTv.execute(testTvSeriesDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(
        mockRemoveWatchlistTv.execute(testTvSeriesDetail),
      ).thenAnswer((_) async => Right('Removed'));
      when(
        mockGetWatchlistStatusTv.execute(testTvSeriesDetail.id),
      ).thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlistTvSeries(testTvSeriesDetail);
      // assert
      verify(mockRemoveWatchlistTv.execute(testTvSeriesDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(
        mockSaveWatchlistTv.execute(testTvSeriesDetail),
      ).thenAnswer((_) async => Right('Added to Watchlist'));
      when(
        mockGetWatchlistStatusTv.execute(testTvSeriesDetail.id),
      ).thenAnswer((_) async => true);
      // act
      await provider.addWatchlistTvSeries(testTvSeriesDetail);
      // assert
      verify(mockGetWatchlistStatusTv.execute(testTvSeriesDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(
        mockSaveWatchlistTv.execute(testTvSeriesDetail),
      ).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(
        mockGetWatchlistStatusTv.execute(testTvSeriesDetail.id),
      ).thenAnswer((_) async => false);
      // act
      await provider.addWatchlistTvSeries(testTvSeriesDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetTvSeriesDetail.execute(tId),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(
        mockGetTvSeriesRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
