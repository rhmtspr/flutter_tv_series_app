import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter_tv_series_app/domain/entities/movies.dart';
import 'package:flutter_tv_series_app/domain/entities/movies_detail.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_movies_detail.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_movies_recommendations.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_watchlist_status_movie.dart';
import 'package:flutter_tv_series_app/domain/usecases/remove_watchlist.dart';
import 'package:flutter_tv_series_app/domain/usecases/save_watchlist_movie.dart';

part 'movies_detail_event.dart';
part 'movies_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatusMovie getWatchListStatusMovie;
  final SaveWatchlistMovie saveWatchlistMovie;
  final RemoveWatchlistMovie removeWatchlistMovie;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatusMovie,
    required this.saveWatchlistMovie,
    required this.removeWatchlistMovie,
  }) : super(const MovieDetailState()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(state.copyWith(movieState: RequestState.loadingState));

      final detailResult = await getMovieDetail.execute(event.id);
      final recommendationResult = await getMovieRecommendations.execute(
        event.id,
      );
      final watchlistStatus = await getWatchListStatusMovie.execute(event.id);

      detailResult.fold(
        (failure) {
          emit(
            state.copyWith(
              movieState: RequestState.errorState,
              message: failure.message,
            ),
          );
        },
        (movie) {
          recommendationResult.fold(
            (failure) {
              emit(
                state.copyWith(
                  movieState: RequestState.loadedState,
                  movie: movie,
                  recommendationState: RequestState.errorState,
                  message: failure.message,
                  isAddedToWatchlist: watchlistStatus,
                ),
              );
            },
            (movies) {
              emit(
                state.copyWith(
                  recommendationState: RequestState.loadedState,
                  movieRecommendations: movies,
                  movieState: RequestState.loadedState,
                  movie: movie,
                  isAddedToWatchlist: watchlistStatus,
                ),
              );
            },
          );
        },
      );
    });

    on<AddToWatchlist>((event, emit) async {
      final result = await saveWatchlistMovie.execute(event.movie);

      await result.fold(
        (failure) async {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) async {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      final resultStatus = await getWatchListStatusMovie.execute(
        event.movie.id,
      );
      emit(state.copyWith(isAddedToWatchlist: resultStatus));
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final result = await removeWatchlistMovie.execute(event.movie);

      await result.fold(
        (failure) async {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) async {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      final resultStatus = await getWatchListStatusMovie.execute(
        event.movie.id,
      );
      emit(state.copyWith(isAddedToWatchlist: resultStatus));
    });
  }
}
