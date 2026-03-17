import 'package:core/common/database_helper.dart';
import 'package:core/common/exception.dart';
import 'package:tv_series/data/models/tv_series_table.dart';

abstract class TvSeriesLocalDataSource {
  Future<String> insertWatchlistTv(TvSeriesTable tv);
  Future<String> removeWatchlistTv(TvSeriesTable tv);
  Future<TvSeriesTable?> getTvSeriesById(int id);
  Future<List<TvSeriesTable>> getWatchlistTvSeries();
  Future<void> cacheNowPlayingTvSeries(List<TvSeriesTable> tvSeries);
  Future<List<TvSeriesTable>> getCachedNowPlayingTvSeries();
}

class TvSeriesLocalDataSourceImpl implements TvSeriesLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvSeriesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlistTv(TvSeriesTable tv) async {
    try {
      await databaseHelper.insertWatchlistTv(tv);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlistTv(TvSeriesTable tv) async {
    try {
      await databaseHelper.removeWatchlistTv(tv);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvSeriesTable?> getTvSeriesById(int id) async {
    final result = await databaseHelper.getTvSeriesById(id);
    if (result != null) {
      return TvSeriesTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvSeriesTable>> getWatchlistTvSeries() async {
    final result = await databaseHelper.getWatchlistTvSeries();
    return result.map((data) => TvSeriesTable.fromMap(data)).toList();
  }

  @override
  Future<void> cacheNowPlayingTvSeries(List<TvSeriesTable> tvSeries) async {
    await databaseHelper.clearCacheTvSeries('now playing');
    await databaseHelper.insertCacheTransactionTvSeries(
      tvSeries,
      'now playing',
    );
  }

  @override
  Future<List<TvSeriesTable>> getCachedNowPlayingTvSeries() async {
    final result = await databaseHelper.getCacheTvSeries('now playing');
    if (result.isNotEmpty) {
      return result.map((data) => TvSeriesTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data:(");
    }
  }
}
