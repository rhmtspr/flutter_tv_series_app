import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter_tv_series_app/presentation/provider/top_rated_movies_notifier.dart';
import 'package:flutter_tv_series_app/presentation/provider/top_rated_tv_series.dart';
import 'package:flutter_tv_series_app/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tv_series_app/presentation/widgets/tv_series_card_list.dart';
import 'package:provider/provider.dart';

class TopRatedTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv-series';

  @override
  _TopRatedTvSeriesPageState createState() => _TopRatedTvSeriesPageState();
}

class _TopRatedTvSeriesPageState extends State<TopRatedTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TopRatedTvSeriesNotifier>(
        context,
        listen: false,
      ).fetchTopRatedTvSeries(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedTvSeriesNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data.tvSeries[index];
                  return TvSeriesCard(tv);
                },
                itemCount: data.tvSeries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
