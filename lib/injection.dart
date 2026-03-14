import 'package:flutter_tv_series_app/common/network_info.dart';
import 'package:flutter_tv_series_app/data/datasources/db/database_helper.dart';
import 'package:flutter_tv_series_app/data/datasources/movies_local_data_source.dart';
import 'package:flutter_tv_series_app/data/datasources/movies_remote_data_source.dart';
import 'package:flutter_tv_series_app/data/datasources/tv_series_local_data_source.dart';
import 'package:flutter_tv_series_app/data/datasources/tv_series_remote_data_source.dart';
import 'package:flutter_tv_series_app/data/repositories/movies_repository_impl.dart';
import 'package:flutter_tv_series_app/data/repositories/tv_series_repository_impl.dart';
import 'package:flutter_tv_series_app/domain/repositories/movies_repository.dart';
import 'package:flutter_tv_series_app/domain/repositories/tv_series_repository.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_movies_detail.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_movies_recommendations.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_now_playing_movies.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_now_playing_tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_popular_movies.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_popular_tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_tv_series_detail.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_tv_series_recommendations.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_watchlist_movies.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_watchlist_status_movie.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_watchlist_tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/remove_watchlist.dart';
import 'package:flutter_tv_series_app/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/save_watchlist_movie.dart';
import 'package:flutter_tv_series_app/domain/usecases/save_watchlist_tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/search_movies.dart';
import 'package:flutter_tv_series_app/domain/usecases/search_tv_series.dart';
import 'package:flutter_tv_series_app/presentation/bloc/movies_detail_bloc.dart';
import 'package:flutter_tv_series_app/presentation/bloc/movies_list_bloc.dart';
import 'package:flutter_tv_series_app/presentation/bloc/popular_movies_bloc.dart';
import 'package:flutter_tv_series_app/presentation/bloc/popular_tv_series_bloc.dart';
import 'package:flutter_tv_series_app/presentation/bloc/search_movies_bloc.dart';
import 'package:flutter_tv_series_app/presentation/bloc/search_tv_series_bloc.dart';
import 'package:flutter_tv_series_app/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:flutter_tv_series_app/presentation/bloc/top_rated_tv_series_bloc.dart';
import 'package:flutter_tv_series_app/presentation/bloc/tv_series_list_bloc.dart';
import 'package:flutter_tv_series_app/presentation/bloc/watchlist_movies_bloc.dart';
import 'package:flutter_tv_series_app/presentation/provider/popular_tv_series_notifier.dart';
import 'package:flutter_tv_series_app/presentation/provider/top_rated_movies_notifier.dart';
import 'package:flutter_tv_series_app/presentation/provider/top_rated_tv_series.dart';
import 'package:flutter_tv_series_app/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter_tv_series_app/presentation/provider/tv_series_search_notifier.dart';
import 'package:flutter_tv_series_app/presentation/provider/watchlist_movie_notifier.dart';
import 'package:flutter_tv_series_app/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

final locator = GetIt.instance;

void init() {
  // Movies Provider
  locator.registerFactory(
    () => MoviesListBloc(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatusMovie: locator(),
      saveWatchlistMovie: locator(),
      removeWatchlistMovie: locator(),
    ),
  );

  locator.registerFactory(() => WatchlistMoviesBloc(locator()));

  // locator.registerFactory(
  //   () => TopRatedMoviesNotifier(getTopRatedMovies: locator()),
  // );
  // locator.registerFactory(
  //   () => WatchlistMovieNotifier(getWatchlistMovies: locator()),
  // );

  locator.registerFactory(() => PopularMoviesBloc(locator()));
  locator.registerFactory(() => TopRatedMoviesBloc(locator()));
  locator.registerFactory(() => SearchMoviesBloc(locator()));

  // Movies Use Cases
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusMovie(locator()));
  locator.registerLazySingleton(() => SaveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // Movie Repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  // Movie Data Sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );

  // ======================================
  // TV SERIES
  // ======================================

  // Tv Series Provider
  // locator.registerFactory(
  //   () => TvSeriesListNotifier(
  //     getNowPlayingTvSeries: locator(),
  //     getPopularTvSeries: locator(),
  //     getTopRatedTvSeries: locator(),
  //   ),
  // );
  locator.registerFactory(
    () => TvSeriesListBloc(
      getNowPlayingTvSeries: locator(),
      getPopularTvSeries: locator(),
      getTopRatedTvSeries: locator(),
    ),
  );

  locator.registerFactory(() => PopularTvSeriesBloc(locator()));
  locator.registerFactory(() => TopRatedTvSeriesBloc(locator()));
  locator.registerFactory(() => SearchTvSeriesBloc(locator()));

  locator.registerFactory(
    () => TvSeriesDetailNotifier(
      getTvSeriesDetail: locator(),
      getTvSeriesRecommendations: locator(),
      getWatchListStatusTv: locator(),
      saveWatchlistTv: locator(),
      removeWatchlistTv: locator(),
    ),
  );

  // locator.registerFactory(
  //   () => TvSeriesSearchNotifier(searchTvSeries: locator()),
  // );
  // locator.registerFactory(() => PopularTvSeriesNotifier(locator()));
  locator.registerFactory(
    () => TopRatedTvSeriesNotifier(getTopRatedTvSeries: locator()),
  );
  locator.registerFactory(
    () => WatchlistTvSeriesNotifier(getWatchlistTvSeries: locator()),
  );

  // Tv Series Use Cases
  locator.registerLazySingleton(() => GetNowPlayingTvSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTv(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));

  // Tv Series Repository
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  // Tv Series Data Sources
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
    () => TvSeriesRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
    () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // network info
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  // external
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => DataConnectionChecker());
}
