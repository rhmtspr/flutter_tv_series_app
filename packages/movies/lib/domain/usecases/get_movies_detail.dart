import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:movies/domain/entities/movies_detail.dart';
import 'package:movies/domain/repositories/movies_repository.dart';

class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
