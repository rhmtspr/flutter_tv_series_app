import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:movies/domain/entities/movies.dart';
import 'package:movies/domain/repositories/movies_repository.dart';

class GetTopRatedMovies {
  final MovieRepository repository;

  GetTopRatedMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getTopRatedMovies();
  }
}
