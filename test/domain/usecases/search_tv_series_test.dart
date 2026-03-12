import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series.dart';
import 'package:flutter_tv_series_app/domain/usecases/search_tv_series.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SearchTvSeries(mockTvSeriesRepository);
  });

  final tTvSeries = <TvSeries>[];
  final tQuery = 'Breaking Bad';

  test('should get list of movies from the repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.searchTvSeries(tQuery),
    ).thenAnswer((_) async => Right(tTvSeries));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tTvSeries));
  });
}
