import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series.dart';
import 'package:flutter_tv_series_app/common/failure.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_now_playing_tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_popular_tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tv_series_app/presentation/bloc/tv_series_list_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvSeries, GetPopularTvSeries, GetTopRatedTvSeries])
void main() {
  late TvSeriesListBloc tvSeriesListBloc;
  late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    tvSeriesListBloc = TvSeriesListBloc(
      getNowPlayingTvSeries: mockGetNowPlayingTvSeries,
      getPopularTvSeries: mockGetPopularTvSeries,
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    );
  });

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
  test('initialState should be Empty', () {
    expect(tvSeriesListBloc.state, const TvSeriesListState());
  });

  group('Now Playing TV Series', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetNowPlayingTvSeries.execute(),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        return tvSeriesListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTvSeries()),
      expect: () => [
        const TvSeriesListState(
          nowPlayingTvSeriesState: RequestState.loadingState,
        ),
        TvSeriesListState(
          nowPlayingTvSeriesState: RequestState.loadedState,
          nowPlayingTvSeries: tTvSeriesList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingTvSeries.execute());
      },
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [Loading, Error] when data is gotten unsuccessfully',
      build: () {
        when(
          mockGetNowPlayingTvSeries.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvSeriesListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTvSeries()),
      expect: () => [
        const TvSeriesListState(
          nowPlayingTvSeriesState: RequestState.loadingState,
        ),
        TvSeriesListState(
          nowPlayingTvSeriesState: RequestState.errorState,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingTvSeries.execute());
      },
    );
  });

  group('Popular TvSeries', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetPopularTvSeries.execute(),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        return tvSeriesListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        const TvSeriesListState(
          popularTvSeriesState: RequestState.loadingState,
        ),
        TvSeriesListState(
          popularTvSeriesState: RequestState.loadedState,
          popularTvSeries: tTvSeriesList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetPopularTvSeries.execute());
      },
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [Loading, Error] when data is gotten unsuccessfully',
      build: () {
        when(
          mockGetPopularTvSeries.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvSeriesListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        const TvSeriesListState(
          popularTvSeriesState: RequestState.loadingState,
        ),
        TvSeriesListState(
          popularTvSeriesState: RequestState.errorState,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetPopularTvSeries.execute());
      },
    );
  });

  group('Top Rated TvSeries', () {
    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetTopRatedTvSeries.execute(),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        return tvSeriesListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        const TvSeriesListState(
          topRatedTvSeriesState: RequestState.loadingState,
        ),
        TvSeriesListState(
          topRatedTvSeriesState: RequestState.loadedState,
          topRatedTvSeries: tTvSeriesList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvSeries.execute());
      },
    );

    blocTest<TvSeriesListBloc, TvSeriesListState>(
      'should emit [Loading, Error] when data is gotten unsuccessfully',
      build: () {
        when(
          mockGetTopRatedTvSeries.execute(),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvSeriesListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        const TvSeriesListState(
          topRatedTvSeriesState: RequestState.loadingState,
        ),
        TvSeriesListState(
          topRatedTvSeriesState: RequestState.errorState,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvSeries.execute());
      },
    );
  });
}
