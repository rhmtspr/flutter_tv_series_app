// d:\computer-science\mobile-projects\flutter\flutter_tv_series_app\lib\presentation\bloc\TopRated_movies_event.dart

part of 'top_rated_tv_series_bloc.dart';

abstract class TopRatedTvSeriesEvent extends Equatable {
  const TopRatedTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedTvSeries extends TopRatedTvSeriesEvent {}
