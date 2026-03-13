import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_tv_series_app/domain/entities/movie.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_now_playing_movies.dart';
import 'package:flutter_tv_series_app/common/failure.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_popular_movies.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_tv_series_app/presentation/bloc/movies_list_bloc.dart';
import 'package:flutter_tv_series_app/presentation/provider/movie_list_notifier.dart';
import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movies_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MoviesListBloc moviesListBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    moviesListBloc = MoviesListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  test('initial state should be empty', () {
    expect(moviesListBloc.state, const MoviesListState());
  });

  group('Now Playing Movies', () {
    blocTest<MoviesListBloc, MoviesListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return moviesListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        const MoviesListState(nowPlayingState: RequestState.loadingState),
        MoviesListState(
          nowPlayingState: RequestState.loadedState,
          nowPlayingMovies: tMovieList,
        ),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );
  });
}
