import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_tv_series_app/common/constants.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series.dart';
import 'package:flutter_tv_series_app/presentation/pages/about_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/home_movie_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/popular_tv_series_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/search_page_tv_series.dart';
import 'package:flutter_tv_series_app/presentation/pages/top_rated_tv_series_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter_tv_series_app/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tv_series_app/presentation/pages/watchlist_tv_series_page.dart';
import 'package:flutter_tv_series_app/presentation/provider/tv_series_list_notifier.dart';
import 'package:provider/provider.dart';

class HomeTvSeriesPage extends StatefulWidget {
  static const routeName = '/home-tv-series';

  const HomeTvSeriesPage({super.key});

  @override
  _HomeTvSeriesPageState createState() => _HomeTvSeriesPageState();
}

class _HomeTvSeriesPageState extends State<HomeTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TvSeriesListNotifier>(context, listen: false)
        ..fetchNowPlayingTvSeries()
        ..fetchPopularTvSeries()
        ..fetchTopRatedTvSeries(),
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
              title: Text('Tv Series'),
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
        title: Text('TV Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPageTvSeries.routeName);
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
              Consumer<TvSeriesListNotifier>(
                builder: (context, data, child) {
                  final state = data.nowPlayingStateTvSeries;
                  if (state == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state == RequestState.Loaded) {
                    return TvSeriesList(data.nowPlayingTvSeries);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvSeriesPage.routeName),
              ),
              Consumer<TvSeriesListNotifier>(
                builder: (context, data, child) {
                  final state = data.popularTvSeriesState;
                  if (state == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state == RequestState.Loaded) {
                    return TvSeriesList(data.popularTvSeries);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(
                  context,
                  TopRatedTvSeriesPage.routeName,
                ),
              ),
              Consumer<TvSeriesListNotifier>(
                builder: (context, data, child) {
                  final state = data.topRatedTvSeriesState;
                  if (state == RequestState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state == RequestState.Loaded) {
                    return TvSeriesList(data.topRatedTvSeries);
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

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  const TvSeriesList(this.tvSeries, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvSeriesDetailPage.routeName,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${tv.posterPath}',
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
