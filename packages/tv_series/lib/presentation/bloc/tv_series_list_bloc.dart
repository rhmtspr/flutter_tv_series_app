import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:core/common/state_enum.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_now_playing_tv_series.dart';
import 'package:tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv_series.dart';

part 'tv_series_list_event.dart';
part 'tv_series_list_state.dart';

class TvSeriesListBloc extends Bloc<TvSeriesListEvent, TvSeriesListState> {
  final GetNowPlayingTvSeries getNowPlayingTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TvSeriesListBloc({
    required this.getNowPlayingTvSeries,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  }) : super(const TvSeriesListState()) {
    on<FetchNowPlayingTvSeries>((event, emit) async {
      emit(state.copyWith(nowPlayingTvSeriesState: RequestState.loadingState));
      final result = await getNowPlayingTvSeries.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            nowPlayingTvSeriesState: RequestState.errorState,
            message: failure.message,
          ),
        ),
        (tvSeriesData) => emit(
          state.copyWith(
            nowPlayingTvSeriesState: RequestState.loadedState,
            nowPlayingTvSeries: tvSeriesData,
          ),
        ),
      );
    });

    on<FetchPopularTvSeries>((event, emit) async {
      emit(state.copyWith(popularTvSeriesState: RequestState.loadingState));
      final result = await getPopularTvSeries.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            popularTvSeriesState: RequestState.errorState,
            message: failure.message,
          ),
        ),
        (tvSeriesData) => emit(
          state.copyWith(
            popularTvSeriesState: RequestState.loadedState,
            popularTvSeries: tvSeriesData,
          ),
        ),
      );
    });

    on<FetchTopRatedTvSeries>((event, emit) async {
      emit(state.copyWith(topRatedTvSeriesState: RequestState.loadingState));
      final result = await getTopRatedTvSeries.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            topRatedTvSeriesState: RequestState.errorState,
            message: failure.message,
          ),
        ),
        (tvSeriesData) => emit(
          state.copyWith(
            topRatedTvSeriesState: RequestState.loadedState,
            topRatedTvSeries: tvSeriesData,
          ),
        ),
      );
    });
  }
}
