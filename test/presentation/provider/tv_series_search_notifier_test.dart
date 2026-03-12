import 'package:dartz/dartz.dart';
import 'package:flutter_tv_series_app/common/failure.dart';
import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/search_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tv_series_app/presentation/provider/tv_series_search_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late TvSeriesSearchNotifier provider;
  late MockSearchTvSeries mockSearchTvSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTvSeries = MockSearchTvSeries();
    provider = TvSeriesSearchNotifier(searchTvSeries: mockSearchTvSeries)
      ..addListener(() {
        listenerCallCount += 1;
      });
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
  final tQuery = 'spiderman';

  group('search TV Series', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(
        mockSearchTvSeries.execute(tQuery),
      ).thenAnswer((_) async => Right(tTvSeriesList));
      // act
      provider.fetchTvSeriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.loadingState);
    });

    test(
      'should change search result data when data is gotten successfully',
      () async {
        // arrange
        when(
          mockSearchTvSeries.execute(tQuery),
        ).thenAnswer((_) async => Right(tTvSeriesList));
        // act
        await provider.fetchTvSeriesSearch(tQuery);
        // assert
        expect(provider.state, RequestState.loadedState);
        expect(provider.searchResult, tTvSeriesList);
        expect(listenerCallCount, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockSearchTvSeries.execute(tQuery),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvSeriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.errorState);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
