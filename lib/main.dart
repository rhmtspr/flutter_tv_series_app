import 'package:flutter_tv_series_app/common/constants.dart';
import 'package:flutter_tv_series_app/common/utils.dart';
import 'package:flutter_tv_series_app/presentation/pages/about_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/home_tv_series_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/movie_detail_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/home_movie_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/popular_movies_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/popular_tv_series_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/search_page_movies.dart';
import 'package:flutter_tv_series_app/presentation/pages/search_page_tv_series.dart';
import 'package:flutter_tv_series_app/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/top_rated_tv_series_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/watchlist_tv_series_page.dart';
import 'package:flutter_tv_series_app/presentation/provider/movie_detail_notifier.dart';
import 'package:flutter_tv_series_app/presentation/provider/movie_list_notifier.dart';
import 'package:flutter_tv_series_app/presentation/provider/movie_search_notifier.dart';
import 'package:flutter_tv_series_app/presentation/provider/popular_movies_notifier.dart';
import 'package:flutter_tv_series_app/presentation/provider/popular_tv_series_notifier.dart';
import 'package:flutter_tv_series_app/presentation/provider/top_rated_movies_notifier.dart';
import 'package:flutter_tv_series_app/presentation/provider/top_rated_tv_series.dart';
import 'package:flutter_tv_series_app/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter_tv_series_app/presentation/provider/tv_series_list_notifier.dart';
import 'package:flutter_tv_series_app/presentation/provider/watchlist_movie_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tv_series_app/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tv_series_app/injection.dart' as di;

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ========================
        // Movies Provider
        ChangeNotifierProvider(create: (_) => di.locator<MovieListNotifier>()),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),

        // ========================
        // Tv Series Provider
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeriesListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeriesDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedTvSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularTvSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistTvSeriesNotifier>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter TV Series App',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPageMovies.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPageMovies());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());

            // Tv Series
            case HomeTvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeTvSeriesPage());
            case PopularTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvSeriesPage());
            case TopRatedTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvSeriesPage());
            case SearchPageTvSeries.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPageTvSeries());
            case WatchlistTvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvSeriesPage());
            case TvSeriesDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return Scaffold(
                    body: Center(child: Text('Page not found :(')),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
