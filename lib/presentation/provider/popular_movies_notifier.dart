import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter_tv_series_app/domain/entities/movie.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_popular_movies.dart';
import 'package:flutter/foundation.dart';

class PopularMoviesNotifier extends ChangeNotifier {
  final GetPopularMovies getPopularMovies;

  PopularMoviesNotifier(this.getPopularMovies);

  RequestState _state = RequestState.emptyState;
  RequestState get state => _state;

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularMovies() async {
    _state = RequestState.loadingState;
    notifyListeners();

    final result = await getPopularMovies.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.errorState;
        notifyListeners();
      },
      (moviesData) {
        _movies = moviesData;
        _state = RequestState.loadedState;
        notifyListeners();
      },
    );
  }
}
