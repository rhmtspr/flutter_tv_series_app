import 'package:flutter_tv_series_app/common/network_info.dart';
import 'package:flutter_tv_series_app/common/ssl_pinning.dart';
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
import 'package:flutter_tv_series_app/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:flutter_tv_series_app/presentation/bloc/tv_series_list_bloc.dart';
import 'package:flutter_tv_series_app/presentation/bloc/watchlist_movies_bloc.dart';
import 'package:flutter_tv_series_app/presentation/bloc/watchlist_tv_series_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:movies/data/datasources/movies_local_data_source.dart';
import 'package:movies/data/datasources/movies_remote_data_source.dart';
import 'package:movies/data/repositories/movies_repository_impl.dart';
import 'package:movies/domain/repositories/movies_repository.dart';
import 'package:movies/domain/usecases/get_movies_detail.dart';
import 'package:movies/domain/usecases/get_movies_recommendations.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movies/domain/usecases/get_watchlist_movies.dart';
import 'package:movies/domain/usecases/get_watchlist_status_movie.dart';
import 'package:movies/domain/usecases/remove_watchlist.dart';
import 'package:movies/domain/usecases/save_watchlist_movie.dart';
import 'package:movies/domain/usecases/search_movies.dart';
import 'package:movies/presentation/bloc/movies_detail_bloc.dart';
import 'package:movies/presentation/bloc/movies_list_bloc.dart';
import 'package:movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:movies/presentation/bloc/search_movies_bloc.dart';
import 'package:movies/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_movies_bloc.dart';

final moviesLocator = GetIt.instance;

Future<void> initMovieInjection() async {
  moviesLocator.registerFactory(
    () => MoviesListBloc(
      getNowPlayingMovies: moviesLocator(),
      getPopularMovies: moviesLocator(),
      getTopRatedMovies: moviesLocator(),
    ),
  );
  moviesLocator.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: moviesLocator(),
      getMovieRecommendations: moviesLocator(),
      getWatchListStatusMovie: moviesLocator(),
      saveWatchlistMovie: moviesLocator(),
      removeWatchlistMovie: moviesLocator(),
    ),
  );

  moviesLocator.registerFactory(() => WatchlistMoviesBloc(moviesLocator()));
  moviesLocator.registerFactory(() => PopularMoviesBloc(moviesLocator()));
  moviesLocator.registerFactory(() => TopRatedMoviesBloc(moviesLocator()));
  moviesLocator.registerFactory(() => SearchMoviesBloc(moviesLocator()));

  // Movies Use Cases
  moviesLocator.registerLazySingleton(
    () => GetNowPlayingMovies(moviesLocator()),
  );
  moviesLocator.registerLazySingleton(() => GetPopularMovies(moviesLocator()));
  moviesLocator.registerLazySingleton(() => GetTopRatedMovies(moviesLocator()));
  moviesLocator.registerLazySingleton(() => GetMovieDetail(moviesLocator()));
  moviesLocator.registerLazySingleton(
    () => GetMovieRecommendations(moviesLocator()),
  );
  moviesLocator.registerLazySingleton(() => SearchMovies(moviesLocator()));
  moviesLocator.registerLazySingleton(
    () => GetWatchListStatusMovie(moviesLocator()),
  );
  moviesLocator.registerLazySingleton(
    () => SaveWatchlistMovie(moviesLocator()),
  );
  moviesLocator.registerLazySingleton(
    () => RemoveWatchlistMovie(moviesLocator()),
  );
  moviesLocator.registerLazySingleton(
    () => GetWatchlistMovies(moviesLocator()),
  );

  // Movie Repository
  moviesLocator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: moviesLocator(),
      localDataSource: moviesLocator(),
      networkInfo: moviesLocator(),
    ),
  );
  // Movie Data Sources
  moviesLocator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: moviesLocator()),
  );
  moviesLocator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: moviesLocator()),
  );
}
