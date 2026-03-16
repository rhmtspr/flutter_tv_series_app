import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tv_series_app/common/constants.dart';
import 'package:flutter_tv_series_app/common/utils.dart';
import 'package:flutter_tv_series_app/firebase_options.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tv_series_app/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<MoviesListBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<SearchMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMoviesBloc>()),

        BlocProvider(create: (_) => di.locator<TvSeriesListBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<SearchTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<TvSeriesDetailBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTvSeriesBloc>()),
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
