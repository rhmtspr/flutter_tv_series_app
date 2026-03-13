import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter_tv_series_app/domain/entities/movie.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_now_playing_movies.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_popular_movies.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_top_rated_movies.dart';

part 'movies_list_event.dart';
part 'movies_list_state.dart';

class MoviesListBloc extends Bloc<MoviesListEvent, MoviesListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MoviesListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(const MoviesListState()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(state.copyWith(nowPlayingMoviesState: RequestState.loadingState));
      final result = await getNowPlayingMovies.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            nowPlayingMoviesState: RequestState.errorState,
            message: failure.message,
          ),
        ),
        (moviesData) => emit(
          state.copyWith(
            nowPlayingMoviesState: RequestState.loadedState,
            nowPlayingMovies: moviesData,
          ),
        ),
      );
    });

    on<FetchPopularMovies>((event, emit) async {
      emit(state.copyWith(popularMoviesState: RequestState.loadingState));
      final result = await getPopularMovies.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            popularMoviesState: RequestState.errorState,
            message: failure.message,
          ),
        ),
        (moviesData) => emit(
          state.copyWith(
            popularMoviesState: RequestState.loadedState,
            popularMovies: moviesData,
          ),
        ),
      );
    });
  }
}
