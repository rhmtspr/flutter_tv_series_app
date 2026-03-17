import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:core/common/failure.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/search_tv_series.dart';
import 'package:tv_series/presentation/bloc/search_tv_series_bloc.dart';

import 'search_tv_series_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late SearchTvSeriesBloc searchTvSeriesBloc;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    searchTvSeriesBloc = SearchTvSeriesBloc(mockSearchTvSeries);
  });

  final tTvSeriesModel = TvSeries(
    backdropPath: '/bsNm9z2TJfe0WO3RedPGWQ8mG1X.jpg',
    genreIds: [18, 80],
    id: 1396,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Breaking Bad',
    overview:
        'When Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family\'s financial future at any cost as he enters the dangerous world of drugs and crime.',
    popularity: 298.884,
    posterPath: '/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
    firstAirDate: '2008-01-20',
    name: 'Breaking Bad',
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTvSeriesList = <TvSeries>[tTvSeriesModel];
  final tQuery = 'breaking bad';

  group('Search tv series', () {
    test('initial state should be empty', () {
      expect(searchTvSeriesBloc.state, SearchEmpty());
    });

    blocTest<SearchTvSeriesBloc, SearchTvSeriesState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(
          mockSearchTvSeries.execute(tQuery),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        return searchTvSeriesBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [SearchLoading(), SearchHasData(tTvSeriesList)],
      verify: (bloc) {
        verify(mockSearchTvSeries.execute(tQuery));
      },
    );

    blocTest<SearchTvSeriesBloc, SearchTvSeriesState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(
          mockSearchTvSeries.execute(tQuery),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return searchTvSeriesBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [SearchLoading(), SearchError('Server Failure')],
      verify: (bloc) {
        verify(mockSearchTvSeries.execute(tQuery));
      },
    );
  });
}
