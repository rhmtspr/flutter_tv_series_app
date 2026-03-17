import 'package:flutter_tv_series_app/domain/repositories/movies_repository.dart';

class GetWatchListStatusMovie {
  final MovieRepository repository;

  GetWatchListStatusMovie(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlistMovie(id);
  }
}
