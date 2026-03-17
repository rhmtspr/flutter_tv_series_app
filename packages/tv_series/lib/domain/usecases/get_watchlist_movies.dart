import 'package:dartz/dartz.dart';
import 'package:flutter_tv_series_app/domain/entities/movies.dart';
import 'package:flutter_tv_series_app/domain/repositories/movies_repository.dart';
import 'package:flutter_tv_series_app/common/failure.dart';

class GetWatchlistMovies {
  final MovieRepository _repository;

  GetWatchlistMovies(this._repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return _repository.getWatchlistMovies();
  }
}
