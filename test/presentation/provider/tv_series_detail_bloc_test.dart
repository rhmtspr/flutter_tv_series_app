import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tv_series_app/common/failure.dart';
import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_tv_series_detail.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_tv_series_recommendations.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/save_watchlist_tv_series.dart';
import 'package:flutter_tv_series_app/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchListStatusTv,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late TvSeriesDetailBloc tvSeriesDetailBloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchListStatusTv mockGetWatchListStatusTv;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchListStatusTv = MockGetWatchListStatusTv();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    tvSeriesDetailBloc = TvSeriesDetailBloc(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      getWatchListStatusTv: mockGetWatchListStatusTv,
      saveWatchlistTv: mockSaveWatchlistTv,
      removeWatchlistTv: mockRemoveWatchlistTv,
    );
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

  void arrangeUsecase() {
    when(
      mockGetTvSeriesDetail.execute(tId),
    ).thenAnswer((_) async => Right(testTvSeriesDetail));
    when(
      mockGetTvSeriesRecommendations.execute(tId),
    ).thenAnswer((_) async => Right(tTvSeriesList));
    when(mockGetWatchListStatusTv.execute(tId)).thenAnswer((_) async => false);
  }

  group('Get TV Series Detail', () {
    test('initial state should be empty', () {
      expect(tvSeriesDetailBloc.state, const TvSeriesDetailState());
    });

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        arrangeUsecase();
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(tvState: RequestState.loadingState),
        TvSeriesDetailState(
          tvState: RequestState.loadedState,
          tv: testTvSeriesDetail,
          recommendationState: RequestState.loadedState,
          tvSeriesRecommendations: tTvSeriesList,
          isAddedToWatchlist: false,
        ),
      ],
      verify: (bloc) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
        verify(mockGetWatchListStatusTv.execute(tId));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'Should emit [Loading, Error] when get movie detail is unsuccessful',
      build: () {
        when(
          mockGetTvSeriesDetail.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(
          mockGetTvSeriesRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        when(
          mockGetWatchListStatusTv.execute(tId),
        ).thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(tvState: RequestState.loadingState),
        const TvSeriesDetailState(
          tvState: RequestState.errorState,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
        verify(mockGetWatchListStatusTv.execute(tId));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'Should emit [Loading, Loaded] when get recommendation is unsuccessful',
      build: () {
        when(
          mockGetTvSeriesDetail.execute(tId),
        ).thenAnswer((_) async => Right(testTvSeriesDetail));
        when(
          mockGetTvSeriesRecommendations.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(
          mockGetWatchListStatusTv.execute(tId),
        ).thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailState(tvState: RequestState.loadingState),
        TvSeriesDetailState(
          tvState: RequestState.loadedState,
          tv: testTvSeriesDetail,
          recommendationState: RequestState.errorState,
          message: 'Server Failure',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (bloc) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
        verify(mockGetWatchListStatusTv.execute(tId));
      },
    );
  });

  group('Watchlist', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [watchlistMessage, isAddedToWatchlist] when add watchlist is success',
      build: () {
        when(
          mockSaveWatchlistTv.execute(testTvSeriesDetail),
        ).thenAnswer((_) async => Right('Added to Watchlist'));
        when(
          mockGetWatchListStatusTv.execute(testTvSeriesDetail.id),
        ).thenAnswer((_) async => true);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(watchlistMessage: 'Added to Watchlist'),
        const TvSeriesDetailState(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTv.execute(testTvSeriesDetail));
        verify(mockGetWatchListStatusTv.execute(testTvSeriesDetail.id));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [watchlistMessage] when add watchlist is failed',
      build: () {
        when(
          mockSaveWatchlistTv.execute(testTvSeriesDetail),
        ).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(
          mockGetWatchListStatusTv.execute(testTvSeriesDetail.id),
        ).thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testTvSeriesDetail)),
      expect: () => [const TvSeriesDetailState(watchlistMessage: 'Failed')],
      verify: (bloc) {
        verify(mockSaveWatchlistTv.execute(testTvSeriesDetail));
        verify(mockGetWatchListStatusTv.execute(testTvSeriesDetail.id));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [watchlistMessage, isAddedToWatchlist] when remove watchlist is success',
      build: () {
        when(
          mockRemoveWatchlistTv.execute(testTvSeriesDetail),
        ).thenAnswer((_) async => Right('Removed from Watchlist'));
        when(
          mockGetWatchListStatusTv.execute(testTvSeriesDetail.id),
        ).thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(watchlistMessage: 'Removed from Watchlist'),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTv.execute(testTvSeriesDetail));
        verify(mockGetWatchListStatusTv.execute(testTvSeriesDetail.id));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [watchlistMessage] when remove watchlist is failed',
      build: () {
        when(
          mockRemoveWatchlistTv.execute(testTvSeriesDetail),
        ).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(
          mockGetWatchListStatusTv.execute(testTvSeriesDetail.id),
        ).thenAnswer((_) async => true);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testTvSeriesDetail)),
      expect: () => [
        const TvSeriesDetailState(watchlistMessage: 'Failed'),
        const TvSeriesDetailState(
          watchlistMessage: 'Failed',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTv.execute(testTvSeriesDetail));
        verify(mockGetWatchListStatusTv.execute(testTvSeriesDetail.id));
      },
    );
  });
}
