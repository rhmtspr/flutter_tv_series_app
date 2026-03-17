part of 'movies_list_bloc.dart';

abstract class MoviesListEvent extends Equatable {
  const MoviesListEvent();
  @override
  List<Object> get props => [];
}

class FetchNowPlayingMovies extends MoviesListEvent {}

class FetchPopularMovies extends MoviesListEvent {}

class FetchTopRatedMovies extends MoviesListEvent {}
