import 'package:dartz/dartz.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series.dart';
import 'package:flutter_tv_series_app/common/failure.dart';
import 'package:flutter_tv_series_app/domain/repositories/tv_series_repository.dart';

class GetWatchlistTvSeries {
  final TvSeriesRepository _repository;

  GetWatchlistTvSeries(this._repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return _repository.getWatchlistTvSeries();
  }
}
