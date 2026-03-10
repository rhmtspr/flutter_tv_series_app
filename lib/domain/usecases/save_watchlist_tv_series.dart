import 'package:dartz/dartz.dart';
import 'package:flutter_tv_series_app/common/failure.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series_detail.dart';
import 'package:flutter_tv_series_app/domain/repositories/tv_series_repository.dart';

class SaveWatchlistTv {
  final TvSeriesRepository repository;

  SaveWatchlistTv(this.repository);

  Future<Either<Failure, String>> execute(TvSeriesDetail tv) {
    return repository.saveWatchlistTvSeries(tv);
  }
}
