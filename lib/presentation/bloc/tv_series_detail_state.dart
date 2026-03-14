part of 'tv_series_detail_bloc.dart';

class TvSeriesDetailState extends Equatable {
  final TvSeriesDetail? tv;
  final RequestState tvState;
  final List<TvSeries> tvSeriesRecommendations;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TvSeriesDetailState({
    this.tv,
    this.tvState = RequestState.emptyState,
    this.tvSeriesRecommendations = const [],
    this.recommendationState = RequestState.emptyState,
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  TvSeriesDetailState copyWith({
    TvSeriesDetail? tv,
    RequestState? tvState,
    List<TvSeries>? tvSeriesRecommendations,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TvSeriesDetailState(
      tv: tv ?? this.tv,
      tvState: tvState ?? this.tvState,
      tvSeriesRecommendations:
          tvSeriesRecommendations ?? this.tvSeriesRecommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    tv,
    tvState,
    tvSeriesRecommendations,
    recommendationState,
    message,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}
