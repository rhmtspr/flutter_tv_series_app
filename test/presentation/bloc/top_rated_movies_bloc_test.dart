import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_tv_series_app/common/failure.dart';
import 'package:flutter_tv_series_app/domain/entities/movies.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tv_series_app/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMoviesBloc topRatedMoviesBloc;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesBloc = TopRatedMoviesBloc(mockGetTopRatedMovies);
  });

  final tMovies = Movie(
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

  final tMoviesList = <Movie>[tMovies];

  test('initial state should be empty', () async {
    expect(topRatedMoviesBloc.state, TopRatedMoviesEmpty());
  });

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(
        mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => Right(tMoviesList));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovies()),
    expect: () => [TopRatedMoviesLoading(), TopRatedMoviesLoaded(tMoviesList)],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'should emit [Loading, Error] when data is gotten unsuccessfully',
    build: () {
      when(
        mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovies()),
    expect: () => [
      TopRatedMoviesLoading(),
      TopRatedMoviesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );
}
