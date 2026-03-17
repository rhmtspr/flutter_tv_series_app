part of 'tv_series_detail_bloc.dart';

abstract class TvSeriesDetailEvent extends Equatable {
  const TvSeriesDetailEvent();
}

class FetchTvSeriesDetail extends TvSeriesDetailEvent {
  final int id;

  const FetchTvSeriesDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddToWatchlist extends TvSeriesDetailEvent {
  final TvSeriesDetail tv;

  const AddToWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class RemoveFromWatchlist extends TvSeriesDetailEvent {
  final TvSeriesDetail tv;

  const RemoveFromWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}
