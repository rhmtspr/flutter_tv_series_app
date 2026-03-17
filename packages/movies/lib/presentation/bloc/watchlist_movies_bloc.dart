import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/domain/entities/movies.dart';
import 'package:movies/domain/usecases/get_watchlist_movies.dart';

part 'watchlist_movies_event.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMoviesBloc(this.getWatchlistMovies) : super(WatchlistMoviesEmpty()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(WatchlistMoviesLoading());
      final result = await getWatchlistMovies.execute();

      result.fold(
        (failure) {
          emit(WatchlistMoviesError(failure.message));
        },
        (data) {
          emit(WatchlistMoviesLoaded(data));
        },
      );
    });
  }
}
