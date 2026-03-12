import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tv_series_app/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTv usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = RemoveWatchlistTv(mockTvSeriesRepository);
  });

  test('should remove watchlist movie from repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.removeWatchlistTvSeries(testTvSeriesDetail),
    ).thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    verify(mockTvSeriesRepository.removeWatchlistTvSeries(testTvSeriesDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
