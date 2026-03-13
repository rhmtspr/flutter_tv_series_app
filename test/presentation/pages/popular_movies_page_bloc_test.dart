import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tv_series_app/domain/entities/movie.dart';
import 'package:flutter_tv_series_app/presentation/bloc/popular_movies_bloc.dart';
import 'package:flutter_tv_series_app/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_page_bloc_test.mocks.dart';

@GenerateMocks([PopularMoviesBloc])
void main() {
  late MockPopularMoviesBloc mockPopularMoviesBloc;

  setUp(() {
    mockPopularMoviesBloc = MockPopularMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>.value(
      value: mockPopularMoviesBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(
      mockPopularMoviesBloc.stream,
    ).thenAnswer((_) => Stream.value(PopularMoviesLoading()));
    when(mockPopularMoviesBloc.state).thenReturn(PopularMoviesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));
    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(
      mockPopularMoviesBloc.stream,
    ).thenAnswer((_) => Stream.value(PopularMoviesLoaded(<Movie>[])));
    when(
      mockPopularMoviesBloc.state,
    ).thenReturn(PopularMoviesLoaded(<Movie>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(
      mockPopularMoviesBloc.stream,
    ).thenAnswer((_) => Stream.value(PopularMoviesError('Error message')));
    when(
      mockPopularMoviesBloc.state,
    ).thenReturn(PopularMoviesError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));
    expect(textFinder, findsOneWidget);
  });
}
