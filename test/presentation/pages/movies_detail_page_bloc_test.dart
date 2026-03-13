import 'package:bloc_test/bloc_test.dart'; // Add this for whenListen
import 'package:flutter_tv_series_app/presentation/bloc/movie_detail_bloc.dart'; // Your BLoC path
import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter_tv_series_app/domain/entities/movie.dart';
import 'package:flutter_tv_series_app/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_bloc_test.mocks.dart';

@GenerateMocks([MovieDetailBloc])
void main() {
  late MockMovieDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieDetailBloc();
    when(mockBloc.stream).thenAnswer((_) => Stream.empty());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  // Helper to create a base state to reduce boilerplate
  final initialState = const MovieDetailState();

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      // Arrange: Stub the state
      when(mockBloc.state).thenReturn(
        initialState.copyWith(
          movieState: RequestState.loadedState,
          movie: testMovieDetail,
          recommendationState: RequestState.loadedState,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: false,
        ),
      );

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when movie is added to watchlist',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(
        initialState.copyWith(
          movieState: RequestState.loadedState,
          movie: testMovieDetail,
          recommendationState: RequestState.loadedState,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: true,
        ),
      );

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.check), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      // Arrange
      final loadedState = initialState.copyWith(
        movieState: RequestState.loadedState,
        movie: testMovieDetail,
        recommendationState: RequestState.loadedState,
        movieRecommendations: <Movie>[],
        isAddedToWatchlist: false,
      );

      // Use whenListen to simulate the state change after clicking the button
      whenListen(
        mockBloc,
        Stream.fromIterable([
          loadedState,
          loadedState.copyWith(watchlistMessage: 'Added to Watchlist'),
        ]),
        initialState: loadedState,
      );

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      // Act
      await tester.tap(find.byType(FilledButton));
      await tester.pump(); // Trigger the BlocListener

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      final loadedState = initialState.copyWith(
        movieState: RequestState.loadedState,
        movie: testMovieDetail,
        recommendationState: RequestState.loadedState,
        movieRecommendations: <Movie>[],
        isAddedToWatchlist: false,
      );

      when(mockBloc.state).thenReturn(loadedState);

      whenListen(
        mockBloc,
        Stream.fromIterable([
          loadedState,
          loadedState.copyWith(watchlistMessage: 'Failed'),
        ]),
        initialState: loadedState,
      );

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}
