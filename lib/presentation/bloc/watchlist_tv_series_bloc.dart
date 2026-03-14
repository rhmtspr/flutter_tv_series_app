import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_watchlist_tv_series.dart';

part 'watchlist_tv_series_event.dart';
part 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistTvSeriesBloc(this.getWatchlistTvSeries)
    : super(WatchlistTvSeriesEmpty()) {
    on<FetchWatchlistTvSeries>((event, emit) async {
      emit(WatchlistTvSeriesLoading());
      final result = await getWatchlistTvSeries.execute();

      result.fold(
        (failure) {
          emit(WatchlistTvSeriesError(failure.message));
        },
        (data) {
          emit(WatchlistTvSeriesLoaded(data));
        },
      );
    });
  }
}
