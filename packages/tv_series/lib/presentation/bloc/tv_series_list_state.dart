part of 'tv_series_list_bloc.dart';

class TvSeriesListState extends Equatable {
  final List<TvSeries> nowPlayingTvSeries;
  final RequestState nowPlayingTvSeriesState;
  final List<TvSeries> popularTvSeries;
  final RequestState popularTvSeriesState;
  final List<TvSeries> topRatedTvSeries;
  final RequestState topRatedTvSeriesState;
  final String message;

  const TvSeriesListState({
    this.nowPlayingTvSeries = const [],
    this.nowPlayingTvSeriesState = RequestState.emptyState,
    this.popularTvSeries = const [],
    this.popularTvSeriesState = RequestState.emptyState,
    this.topRatedTvSeries = const [],
    this.topRatedTvSeriesState = RequestState.emptyState,
    this.message = '',
  });

  TvSeriesListState copyWith({
    List<TvSeries>? nowPlayingTvSeries,
    RequestState? nowPlayingTvSeriesState,
    List<TvSeries>? popularTvSeries,
    RequestState? popularTvSeriesState,
    List<TvSeries>? topRatedTvSeries,
    RequestState? topRatedTvSeriesState,
    String? message,
  }) {
    return TvSeriesListState(
      nowPlayingTvSeries: nowPlayingTvSeries ?? this.nowPlayingTvSeries,
      nowPlayingTvSeriesState:
          nowPlayingTvSeriesState ?? this.nowPlayingTvSeriesState,
      popularTvSeries: popularTvSeries ?? this.popularTvSeries,
      popularTvSeriesState: popularTvSeriesState ?? this.popularTvSeriesState,
      topRatedTvSeries: topRatedTvSeries ?? this.topRatedTvSeries,
      topRatedTvSeriesState:
          topRatedTvSeriesState ?? this.topRatedTvSeriesState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
    nowPlayingTvSeries,
    nowPlayingTvSeriesState,
    popularTvSeries,
    popularTvSeriesState,
    topRatedTvSeries,
    topRatedTvSeriesState,
    message,
  ];
}
