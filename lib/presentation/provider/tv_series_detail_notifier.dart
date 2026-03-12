import 'package:flutter_tv_series_app/domain/entities/tv_series.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series_detail.dart';
import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_tv_series_detail.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_tv_series_recommendations.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tv_series_app/domain/usecases/save_watchlist_tv_series.dart';

class TvSeriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchListStatusTv getWatchListStatusTv;
  final SaveWatchlistTv saveWatchlistTv;
  final RemoveWatchlistTv removeWatchlistTv;

  TvSeriesDetailNotifier({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchListStatusTv,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  });

  late TvSeriesDetail _tv;
  TvSeriesDetail get tv => _tv;

  RequestState _tvState = RequestState.emptyState;
  RequestState get tvState => _tvState;

  List<TvSeries> _tvSeriesRecommendations = [];
  List<TvSeries> get tvSeriesRecommendations => _tvSeriesRecommendations;

  RequestState _tvSeriesRecommendationState = RequestState.emptyState;
  RequestState get tvSeriesRecommendationState => _tvSeriesRecommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlistTvSeries = false;
  bool get isAddedToWatchlistTvSeries => _isAddedtoWatchlistTvSeries;

  Future<void> fetchTvSeriesDetail(int id) async {
    _tvState = RequestState.loadingState;
    notifyListeners();
    final detailResult = await getTvSeriesDetail.execute(id);
    final recommendationResult = await getTvSeriesRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvState = RequestState.errorState;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        _tvSeriesRecommendationState = RequestState.loadingState;
        _tv = tv;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _tvSeriesRecommendationState = RequestState.errorState;
            _message = failure.message;
          },
          (tvSeries) {
            _tvSeriesRecommendationState = RequestState.loadedState;
            _tvSeriesRecommendations = tvSeries;
          },
        );
        _tvState = RequestState.loadedState;
        notifyListeners();
      },
    );
  }

  String _watchlistMessageTvSeries = '';
  String get watchlistMessageTvSeries => _watchlistMessageTvSeries;

  Future<void> addWatchlistTvSeries(TvSeriesDetail tv) async {
    final result = await saveWatchlistTv.execute(tv);

    await result.fold(
      (failure) async {
        _watchlistMessageTvSeries = failure.message;
      },
      (successMessage) async {
        _watchlistMessageTvSeries = successMessage;
      },
    );

    await loadWatchlistStatusTvSeries(tv.id);
  }

  Future<void> removeFromWatchlistTvSeries(TvSeriesDetail tv) async {
    final result = await removeWatchlistTv.execute(tv);

    await result.fold(
      (failure) async {
        _watchlistMessageTvSeries = failure.message;
      },
      (successMessage) async {
        _watchlistMessageTvSeries = successMessage;
      },
    );

    await loadWatchlistStatusTvSeries(tv.id);
  }

  Future<void> loadWatchlistStatusTvSeries(int id) async {
    final result = await getWatchListStatusTv.execute(id);
    _isAddedtoWatchlistTvSeries = result;
    notifyListeners();
  }
}
