part of 'movies_list_bloc.dart';

class MoviesListState extends Equatable {
  final List<Movie> nowPlayingMovies;
  final RequestState nowPlayingMoviesState;
  final List<Movie> popularMovies;
  final RequestState popularMoviesState;
  final List<Movie> topRatedMovies;
  final RequestState topRatedMoviesState;
  final String message;

  const MoviesListState({
    this.nowPlayingMovies = const [],
    this.nowPlayingMoviesState = RequestState.emptyState,
    this.popularMovies = const [],
    this.popularMoviesState = RequestState.emptyState,
    this.topRatedMovies = const [],
    this.topRatedMoviesState = RequestState.emptyState,
    this.message = '',
  });

  MoviesListState copyWith({
    List<Movie>? nowPlayingMovies,
    RequestState? nowPlayingMoviesState,
    List<Movie>? popularMovies,
    RequestState? popularMoviesState,
    List<Movie>? topRatedMovies,
    RequestState? topRatedMoviesState,
    String? message,
  }) {
    return MoviesListState(
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      nowPlayingMoviesState:
          nowPlayingMoviesState ?? this.nowPlayingMoviesState,
      popularMovies: popularMovies ?? this.popularMovies,
      popularMoviesState: popularMoviesState ?? this.popularMoviesState,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      topRatedMoviesState: topRatedMoviesState ?? this.topRatedMoviesState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
    nowPlayingMovies,
    nowPlayingMoviesState,
    popularMovies,
    popularMoviesState,
    topRatedMovies,
    topRatedMoviesState,
    message,
  ];
}
