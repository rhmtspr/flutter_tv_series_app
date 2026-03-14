import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series_detail.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_tv_series_detail.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_tv_series_recommendations.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/save_watchlist_tv_series.dart';

part 'tv_series_detail_event.dart';
part 'tv_series_detail_state.dart';

class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchListStatusTv getWatchListStatusTv;
  final SaveWatchlistTv saveWatchlistTv;
  final RemoveWatchlistTv removeWatchlistTv;

  TvSeriesDetailBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchListStatusTv,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  }) : super(const TvSeriesDetailState()) {
    on<FetchTvSeriesDetail>((event, emit) async {
      emit(state.copyWith(tvState: RequestState.loadingState));

      final detailResult = await getTvSeriesDetail.execute(event.id);
      final recommendationResult = await getTvSeriesRecommendations.execute(
        event.id,
      );
      final watchlistStatus = await getWatchListStatusTv.execute(event.id);

      detailResult.fold(
        (failure) {
          emit(
            state.copyWith(
              tvState: RequestState.errorState,
              message: failure.message,
            ),
          );
        },
        (tv) {
          recommendationResult.fold(
            (failure) {
              emit(
                state.copyWith(
                  tvState: RequestState.loadedState,
                  tv: tv,
                  recommendationState: RequestState.errorState,
                  message: failure.message,
                  isAddedToWatchlist: watchlistStatus,
                ),
              );
            },
            (tvSeries) {
              emit(
                state.copyWith(
                  recommendationState: RequestState.loadedState,
                  tvSeriesRecommendations: tvSeries,
                  tvState: RequestState.loadedState,
                  tv: tv,
                  isAddedToWatchlist: watchlistStatus,
                ),
              );
            },
          );
        },
      );
    });

    on<AddToWatchlist>((event, emit) async {
      final result = await saveWatchlistTv.execute(event.tv);

      await result.fold(
        (failure) async {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) async {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      final resultStatus = await getWatchListStatusTv.execute(event.tv.id);
      emit(state.copyWith(isAddedToWatchlist: resultStatus));
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final result = await removeWatchlistTv.execute(event.tv);

      await result.fold(
        (failure) async {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) async {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      final resultStatus = await getWatchListStatusTv.execute(event.tv.id);
      emit(state.copyWith(isAddedToWatchlist: resultStatus));
    });
  }
}
