import 'package:tv_series/domain/entities/genre.dart';
import 'package:tv_series/data/models/tv_series_table.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';

final testTvSeries = TvSeries(
  backdropPath: '/mAJ84W6I8I272Da87qplS2Dp9ST.jpg',
  firstAirDate: '2023-01-23',
  genreIds: [9648, 18],
  id: 202250,
  name: 'Dirty Linen',
  originCountry: ['PH'],
  originalLanguage: 'tl',
  originalName: 'Dirty Linen',
  overview:
      'To exact vengeance, a young woman infiltrates the household of an influential family as a housemaid to expose their dirty secrets. However, love will get in the way of her revenge plot.',
  popularity: 2797.914,
  posterPath: '/aoAZgnmMzY9vVy9VWnO3U5PZENh.jpg',
  voteAverage: 5,
  voteCount: 13,
);

final testTvSeriesList = [testTvSeries];

final testTvSeriesDetail = TvSeriesDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  name: 'name',
  numberOfEpisodes: 1,
  numberOfSeasons: 1,
  overview: 'overview',
  posterPath: 'posterPath',
  voteAverage: 1,
  voteCount: 1,
);

final testTvSeriesCache = TvSeriesTable(
  id: 202250,
  overview:
      'To exact vengeance, a young woman infiltrates the household of an influential family as a housemaid to expose their dirty secrets. However, love will get in the way of her revenge plot.',
  posterPath: '/aoAZgnmMzY9vVy9VWnO3U5PZENh.jpg',
  name: 'Dirty Linen',
);

final testTvSeriesCacheMap = {
  'id': 202250,
  'overview':
      'To exact vengeance, a young woman infiltrates the household of an influential family as a housemaid to expose their dirty secrets. However, love will get in the way of her revenge plot.',
  'posterPath': '/aoAZgnmMzY9vVy9VWnO3U5PZENh.jpg',
  'name': 'Dirty Linen',
};

final testTvSeriesFromCache = TvSeries.watchlist(
  id: 202250,
  overview:
      'To exact vengeance, a young woman infiltrates the household of an influential family as a housemaid to expose their dirty secrets. However, love will get in the way of her revenge plot.',
  posterPath: '/aoAZgnmMzY9vVy9VWnO3U5PZENh.jpg',
  name: 'Dirty Linen',
);

final testWatchlistTvSeries = TvSeries.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeriesTable = TvSeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
