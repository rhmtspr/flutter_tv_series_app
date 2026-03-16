import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_tv_series_app/common/failure.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_watchlist_tv_series.dart';
import 'package:flutter_tv_series_app/presentation/bloc/watchlist_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../provider/watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;
  late WatchlistTvSeriesBloc watchlistTvSeriesBloc;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    watchlistTvSeriesBloc = WatchlistTvSeriesBloc(mockGetWatchlistTvSeries);
  });

  test('initial state should be empty', () async {
    expect(watchlistTvSeriesBloc.state, WatchlistTvSeriesEmpty());
  });

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(
        mockGetWatchlistTvSeries.execute(),
      ).thenAnswer((_) async => Right([testWatchlistTvSeries]));
      return watchlistTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
    expect: () => [
      WatchlistTvSeriesLoading(),
      WatchlistTvSeriesLoaded([testWatchlistTvSeries]),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTvSeries.execute());
    },
  );

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'should emit [Loading, Error] when data is gotten unsuccessfully',
    build: () {
      when(
        mockGetWatchlistTvSeries.execute(),
      ).thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      return watchlistTvSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
    expect: () => [
      WatchlistTvSeriesLoading(),
      WatchlistTvSeriesError("Can't get data"),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTvSeries.execute());
    },
  );
}
