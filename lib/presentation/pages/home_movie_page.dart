import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tv_series_app/common/constants.dart';
import 'package:flutter_tv_series_app/domain/entities/movies.dart';
import 'package:flutter_tv_series_app/presentation/bloc/movies_list_bloc.dart';
import 'package:flutter_tv_series_app/presentation/pages/about_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/home_tv_series_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/movie_detail_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/popular_movies_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/search_page_movies.dart';
import 'package:flutter_tv_series_app/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/watchlist_tv_series_page.dart';
import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter/material.dart';

class HomeMoviePage extends StatefulWidget {
  static const routeName = '/home';

  const HomeMoviePage({super.key});

  @override
  HomeMoviePageState createState() => HomeMoviePageState();
}

class HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<MoviesListBloc>()
        ..add(FetchNowPlayingMovies())
        ..add(FetchPopularMovies())
        ..add(FetchTopRatedMovies()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: Text('flutter_tv_series_app'),
              accountEmail: Text('flutter_tv_series_app@dicoding.com'),
              decoration: BoxDecoration(color: Colors.grey.shade900),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pushNamed(context, HomeMoviePage.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('TV Series'),
              onTap: () {
                Navigator.pushNamed(context, HomeTvSeriesPage.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist Movies'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist Tv Series'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTvSeriesPage.routeName);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.routeName);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Movies'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPageMovies.routeName);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Now Playing', style: kHeading6),
              BlocBuilder<MoviesListBloc, MoviesListState>(
                builder: (context, state) {
                  if (state.nowPlayingMoviesState ==
                      RequestState.loadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.nowPlayingMoviesState ==
                      RequestState.loadedState) {
                    return MovieList(state.nowPlayingMovies);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularMoviesPage.routeName),
              ),
              BlocBuilder<MoviesListBloc, MoviesListState>(
                builder: (context, state) {
                  if (state.popularMoviesState == RequestState.loadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.popularMoviesState ==
                      RequestState.loadedState) {
                    return MovieList(state.popularMovies);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedMoviesPage.routeName),
              ),
              BlocBuilder<MoviesListBloc, MoviesListState>(
                builder: (context, state) {
                  if (state.topRatedMoviesState == RequestState.loadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.topRatedMoviesState ==
                      RequestState.loadedState) {
                    return MovieList(state.topRatedMovies);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.routeName,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
