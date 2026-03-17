import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv_series_bloc.dart';
import 'package:tv_series/presentation/pages/top_rated_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_series_page_test.mocks.dart';

@GenerateMocks([TopRatedTvSeriesBloc])
void main() {
  late MockTopRatedTvSeriesBloc mockTopRatedTvSeriesBloc;

  setUp(() {
    mockTopRatedTvSeriesBloc = MockTopRatedTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvSeriesBloc>.value(
      value: mockTopRatedTvSeriesBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(
      mockTopRatedTvSeriesBloc.stream,
    ).thenAnswer((_) => Stream.value(TopRatedTvSeriesLoading()));
    when(mockTopRatedTvSeriesBloc.state).thenReturn(TopRatedTvSeriesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(TopRatedTvSeriesPage()));
    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(
      mockTopRatedTvSeriesBloc.stream,
    ).thenAnswer((_) => Stream.value(TopRatedTvSeriesLoaded(<TvSeries>[])));
    when(
      mockTopRatedTvSeriesBloc.state,
    ).thenReturn(TopRatedTvSeriesLoaded(<TvSeries>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(TopRatedTvSeriesPage()));
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(
      mockTopRatedTvSeriesBloc.stream,
    ).thenAnswer((_) => Stream.value(TopRatedTvSeriesError('Error message')));
    when(
      mockTopRatedTvSeriesBloc.state,
    ).thenReturn(TopRatedTvSeriesError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(TopRatedTvSeriesPage()));
    expect(textFinder, findsOneWidget);
  });
}
