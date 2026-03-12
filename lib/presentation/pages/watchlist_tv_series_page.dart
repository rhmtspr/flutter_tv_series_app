import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter_tv_series_app/common/utils.dart';
import 'package:flutter_tv_series_app/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tv_series_app/presentation/widgets/tv_series_card_list.dart';
import 'package:provider/provider.dart';

class WatchlistTvSeriesPage extends StatefulWidget {
  static const routeName = '/watchlist-tv-series';

  const WatchlistTvSeriesPage({super.key});

  @override
  WatchlistTvSeriesPageState createState() => WatchlistTvSeriesPageState();
}

class WatchlistTvSeriesPageState extends State<WatchlistTvSeriesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<WatchlistTvSeriesNotifier>(
        context,
        listen: false,
      ).fetchWatchlistTvSeries(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistTvSeriesNotifier>(
      context,
      listen: false,
    ).fetchWatchlistTvSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watchlist')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<WatchlistTvSeriesNotifier>(
          builder: (context, data, child) {
            if (data.watchlistState == RequestState.loadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (data.watchlistState == RequestState.loadedState) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data.watchlistTvSeries[index];
                  return TvSeriesCard(tv);
                },
                itemCount: data.watchlistTvSeries.length,
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
