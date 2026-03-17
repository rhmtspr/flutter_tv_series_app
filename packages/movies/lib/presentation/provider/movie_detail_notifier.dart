import 'package:flutter_tv_series_app/domain/entities/movies.dart';
import 'package:flutter_tv_series_app/domain/entities/movies_detail.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_movies_detail.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_movies_recommendations.dart';
import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_watchlist_status_movie.dart';
import 'package:flutter_tv_series_app/domain/usecases/remove_watchlist.dart';
import 'package:flutter_tv_series_app/domain/usecases/save_watchlist_movie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MovieDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatusMovie getWatchListStatusMovie;
  final SaveWatchlistMovie saveWatchlistMovie;
  final RemoveWatchlistMovie removeWatchlistMovie;

  MovieDetailNotifier({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatusMovie,
    required this.saveWatchlistMovie,
    required this.removeWatchlistMovie,
  });

  late MovieDetail _movie;
  MovieDetail get movie => _movie;

  RequestState _movieState = RequestState.emptyState;
  RequestState get movieState => _movieState;

  List<Movie> _movieRecommendations = [];
  List<Movie> get movieRecommendations => _movieRecommendations;

  RequestState _recommendationState = RequestState.emptyState;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchMovieDetail(int id) async {
    _movieState = RequestState.loadingState;
    notifyListeners();
    final detailResult = await getMovieDetail.execute(id);
    final recommendationResult = await getMovieRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _movieState = RequestState.errorState;
        _message = failure.message;
        notifyListeners();
      },
      (movie) {
        _recommendationState = RequestState.loadingState;
        _movie = movie;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.errorState;
            _message = failure.message;
          },
          (movies) {
            _recommendationState = RequestState.loadedState;
            _movieRecommendations = movies;
          },
        );
        _movieState = RequestState.loadedState;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(MovieDetail movie) async {
    final result = await saveWatchlistMovie.execute(movie);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    final result = await removeWatchlistMovie.execute(movie);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatusMovie.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
