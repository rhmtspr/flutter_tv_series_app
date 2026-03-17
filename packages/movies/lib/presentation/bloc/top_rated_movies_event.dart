// d:\computer-science\mobile-projects\flutter\flutter_tv_series_app\lib\presentation\bloc\TopRated_movies_event.dart

part of 'top_rated_movies_bloc.dart';

abstract class TopRatedMoviesEvent extends Equatable {
  const TopRatedMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedMovies extends TopRatedMoviesEvent {}
