import 'package:tv_series/domain/repositories/tv_series_repository.dart';

class GetWatchListStatusTv {
  final TvSeriesRepository repository;

  GetWatchListStatusTv(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlistTvSeries(id);
  }
}
