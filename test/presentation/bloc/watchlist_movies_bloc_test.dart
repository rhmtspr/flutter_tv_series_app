import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_tv_series_app/common/failure.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_watchlist_movies.dart';
import 'package:flutter_tv_series_app/presentation/bloc/watchlist_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../provider/watchlist_movies_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late WatchlistMoviesBloc watchlistMoviesBloc;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMoviesBloc = WatchlistMoviesBloc(mockGetWatchlistMovies);
  });

  test('initial state should be empty', () async {
    expect(watchlistMoviesBloc.state, WatchlistMoviesEmpty());
  });

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(
        mockGetWatchlistMovies.execute(),
      ).thenAnswer((_) async => Right([testWatchlistMovie]));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMoviesLoading(),
      WatchlistMoviesLoaded([testWatchlistMovie]),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'should emit [Loading, Error] when data is gotten unsuccessfully',
    build: () {
      when(
        mockGetWatchlistMovies.execute(),
      ).thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMoviesLoading(),
      WatchlistMoviesError("Can't get data"),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );
}
