import 'package:dartz/dartz.dart';
import 'package:flutter_tv_series_app/domain/entities/movies.dart';
import 'package:flutter_tv_series_app/domain/entities/movies_detail.dart';
import 'package:flutter_tv_series_app/common/failure.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies();
  Future<Either<Failure, List<Movie>>> getPopularMovies();
  Future<Either<Failure, List<Movie>>> getTopRatedMovies();
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id);
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id);
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
  Future<Either<Failure, String>> saveWatchlistMovie(MovieDetail movie);
  Future<Either<Failure, String>> removeWatchlistMovie(MovieDetail movie);
  Future<bool> isAddedToWatchlistMovie(int id);
  Future<Either<Failure, List<Movie>>> getWatchlistMovies();
}
