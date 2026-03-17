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

  moviesLocator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: moviesLocator(),
      localDataSource: moviesLocator(),
      networkInfo: moviesLocator(),
    ),
  );

  moviesLocator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: moviesLocator()),
  );
  moviesLocator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: moviesLocator()),
  );
}
