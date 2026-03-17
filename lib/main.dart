import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core_injection.dart';
import 'package:movies/movies_injection.dart';
import 'package:tv_series/tv_series_injection.dart';
import 'package:core/common/constants.dart';
import 'package:core/common/utils.dart';

import 'package:movies/presentation/bloc/movies_detail_bloc.dart';
import 'package:movies/presentation/bloc/movies_list_bloc.dart';
import 'package:movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:movies/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:movies/presentation/bloc/search_movies_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_movies_bloc.dart';

import 'package:movies/presentation/pages/home_movie_page.dart';
import 'package:movies/presentation/pages/movie_detail_page.dart';
import 'package:movies/presentation/pages/popular_movies_page.dart';
import 'package:movies/presentation/pages/search_page_movies.dart';
import 'package:movies/presentation/pages/top_rated_movies_page.dart';
import 'package:movies/presentation/pages/watchlist_movies_page.dart';

import 'package:tv_series/presentation/bloc/search_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series_bloc.dart';

import 'package:tv_series/presentation/pages/about_page.dart';
import 'package:tv_series/presentation/pages/home_tv_series_page.dart';
import 'package:tv_series/presentation/pages/popular_tv_series_page.dart';
import 'package:tv_series/presentation/pages/search_page_tv_series.dart';
import 'package:tv_series/presentation/pages/top_rated_tv_series_page.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:tv_series/presentation/pages/watchlist_tv_series_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initCoreInjection();
  initMoviesInjection();
  initTvSeriesInjection();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => locator<MoviesListBloc>()),
        BlocProvider(create: (_) => locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => locator<SearchMoviesBloc>()),
        BlocProvider(create: (_) => locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => locator<WatchlistMoviesBloc>()),

        BlocProvider(create: (_) => locator<TvSeriesListBloc>()),
        BlocProvider(create: (_) => locator<PopularTvSeriesBloc>()),
        BlocProvider(create: (_) => locator<TopRatedTvSeriesBloc>()),
        BlocProvider(create: (_) => locator<SearchTvSeriesBloc>()),
        BlocProvider(create: (_) => locator<TvSeriesDetailBloc>()),
        BlocProvider(create: (_) => locator<WatchlistTvSeriesBloc>()),
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
            case PopularMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPageMovies.routeName:
              return CupertinoPageRoute(builder: (_) => SearchPageMovies());
            case WatchlistMoviesPage.routeName:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case AboutPage.routeName:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case HomeTvSeriesPage.routeName:
              return MaterialPageRoute(builder: (_) => HomeTvSeriesPage());
            case PopularTvSeriesPage.routeName:
              return CupertinoPageRoute(builder: (_) => PopularTvSeriesPage());
            case TopRatedTvSeriesPage.routeName:
              return CupertinoPageRoute(builder: (_) => TopRatedTvSeriesPage());
            case SearchPageTvSeries.routeName:
              return CupertinoPageRoute(builder: (_) => SearchPageTvSeries());
            case WatchlistTvSeriesPage.routeName:
              return MaterialPageRoute(builder: (_) => WatchlistTvSeriesPage());
            case TvSeriesDetailPage.routeName:
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
