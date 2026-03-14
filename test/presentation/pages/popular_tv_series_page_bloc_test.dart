import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series.dart';
import 'package:flutter_tv_series_app/presentation/bloc/popular_tv_series_bloc.dart';
import 'package:flutter_tv_series_app/presentation/pages/popular_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_series_page_bloc_test.mocks.dart';

@GenerateMocks([PopularTvSeriesBloc])
void main() {
  late MockPopularTvSeriesBloc mockPopularTvSeriesBloc;

  setUp(() {
    mockPopularTvSeriesBloc = MockPopularTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvSeriesBloc>.value(
      value: mockPopularTvSeriesBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(
      mockPopularTvSeriesBloc.stream,
    ).thenAnswer((_) => Stream.value(PopularTvSeriesLoading()));
    when(mockPopularTvSeriesBloc.state).thenReturn(PopularTvSeriesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(PopularTvSeriesPage()));
    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(
      mockPopularTvSeriesBloc.stream,
    ).thenAnswer((_) => Stream.value(PopularTvSeriesLoaded(<TvSeries>[])));
    when(
      mockPopularTvSeriesBloc.state,
    ).thenReturn(PopularTvSeriesLoaded(<TvSeries>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(PopularTvSeriesPage()));
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(
      mockPopularTvSeriesBloc.stream,
    ).thenAnswer((_) => Stream.value(PopularTvSeriesError('Error message')));
    when(
      mockPopularTvSeriesBloc.state,
    ).thenReturn(PopularTvSeriesError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(PopularTvSeriesPage()));
    expect(textFinder, findsOneWidget);
  });
}
