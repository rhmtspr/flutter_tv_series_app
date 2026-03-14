import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tv_series_app/presentation/bloc/top_rated_tv_series_bloc.dart';
import 'package:flutter_tv_series_app/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';

class TopRatedTvSeriesPage extends StatefulWidget {
  static const routeName = '/top-rated-tv-series';

  const TopRatedTvSeriesPage({super.key});

  @override
  TopRatedTvSeriesPageState createState() => TopRatedTvSeriesPageState();
}

class TopRatedTvSeriesPageState extends State<TopRatedTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;

      context.read<TopRatedTvSeriesBloc>().add(FetchTopRatedTvSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated TvSeries')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
          builder: (context, state) {
            if (state is TopRatedTvSeriesLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TopRatedTvSeriesLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvSeries[index];
                  return TvSeriesCard(tv);
                },
                itemCount: state.tvSeries.length,
              );
            } else if (state is TopRatedTvSeriesError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center();
            }
          },
        ),
      ),
    );
  }
}
