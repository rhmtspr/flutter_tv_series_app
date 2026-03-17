// d:\computer-science\mobile-projects\flutter\flutter_tv_series_app\lib\presentation\bloc\popular_movies_event.dart

part of 'popular_movies_bloc.dart';

abstract class PopularMoviesEvent extends Equatable {
  const PopularMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularMovies extends PopularMoviesEvent {}
