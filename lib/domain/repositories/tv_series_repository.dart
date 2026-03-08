import 'package:dartz/dartz.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series_detail.dart';
import 'package:flutter_tv_series_app/common/failure.dart';

abstract class TvSeriesRepository {
  Future<Either<Failure, List<TvSeries>>> getNowPlayingTvSeries();
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries();
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries();
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id);
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(int id);
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query);
  Future<Either<Failure, String>> saveWatchlistTvSeries(TvSeriesDetail tv);
  Future<Either<Failure, String>> removeWatchlistTvSeries(TvSeriesDetail tv);
  Future<bool> isAddedToWatchlistTvSeries(int id);
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries();
}
