import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tv_series_app/common/constants.dart';
import 'package:flutter_tv_series_app/domain/entities/genre.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series_detail.dart';
import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_tv_series_app/presentation/bloc/tv_series_detail_bloc.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const routeName = '/detail-tv-series';

  final int id;
  const TvSeriesDetailPage({super.key, required this.id});

  @override
  TvSeriesDetailPageState createState() => TvSeriesDetailPageState();
}

class TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;

      context.read<TvSeriesDetailBloc>().add(FetchTvSeriesDetail(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TvSeriesDetailBloc, TvSeriesDetailState>(
        listenWhen: (previous, current) =>
            previous.watchlistMessage != current.watchlistMessage &&
            current.watchlistMessage != '',
        listener: (context, state) {
          if (state.watchlistMessage ==
                  TvSeriesDetailBloc.watchlistAddSuccessMessage ||
              state.watchlistMessage ==
                  TvSeriesDetailBloc.watchlistRemoveSuccessMessage) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.watchlistMessage)));
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(content: Text(state.watchlistMessage));
              },
            );
          }
        },
        child: BlocBuilder<TvSeriesDetailBloc, TvSeriesDetailState>(
          builder: (context, state) {
            if (state.tvState == RequestState.loadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state.tvState == RequestState.loadedState) {
              final tv = state.tv!;
              return SafeArea(
                child: DetailContent(
                  tv,
                  state.tvSeriesRecommendations,
                  state.isAddedToWatchlist,
                ),
              );
            } else if (state.tvState == RequestState.errorState) {
              return Text(state.message);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvSeriesDetail tv;
  final List<TvSeries> tvSeriesRecommendations;
  final bool isAddedWatchlist;

  const DetailContent(
    this.tv,
    this.tvSeriesRecommendations,
    this.isAddedWatchlist, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tv.name, style: kHeading5),
                            FilledButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context.read<TvSeriesDetailBloc>().add(
                                    AddToWatchlist(tv),
                                  );
                                } else {
                                  context.read<TvSeriesDetailBloc>().add(
                                    RemoveFromWatchlist(tv),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(_showGenres(tv.genres)),
                            // Text(_showDuration(movie.runtime)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      Icon(Icons.star, color: kMikadoYellow),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage.roundToDouble()}'),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(tv.overview),
                            Text('Episodes'),
                            Text('${tv.numberOfEpisodes}'),
                            Text('Seasons'),
                            Text('${tv.numberOfSeasons}'),
                            SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            BlocBuilder<
                              TvSeriesDetailBloc,
                              TvSeriesDetailState
                            >(
                              builder: (context, state) {
                                if (state.recommendationState ==
                                    RequestState.loadingState) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state.recommendationState ==
                                    RequestState.errorState) {
                                  return Text(state.message);
                                } else if (state.recommendationState ==
                                    RequestState.loadedState) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv =
                                            tvSeriesRecommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvSeriesDetailPage.routeName,
                                                arguments: tv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: tvSeriesRecommendations.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  // String _showDuration(int runtime) {
  //   final int hours = runtime ~/ 60;
  //   final int minutes = runtime % 60;

  //   if (hours > 0) {
  //     return '${hours}h ${minutes}m';
  //   } else {
  //     return '${minutes}m';
  //   }
  // }
}
