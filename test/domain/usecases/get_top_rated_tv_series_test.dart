import 'package:dartz/dartz.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_top_rated_tv_series.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTopRatedTvSeries(mockTvSeriesRepository);
  });

  final tTvSeries = <TvSeries>[];

  test('should get list of TvSeries from repository', () async {
    // arrange
    when(
      mockTvSeriesRepository.getTopRatedTvSeries(),
    ).thenAnswer((_) async => Right(tTvSeries));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvSeries));
  });
}
