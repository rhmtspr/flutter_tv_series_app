import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter_tv_series_app/domain/entities/movies.dart';
import 'package:flutter_tv_series_app/presentation/bloc/movies_detail_bloc.dart';
import 'package:flutter_tv_series_app/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movies_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailBloc])
void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockMovieDetailBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      when(mockMovieDetailBloc.state).thenReturn(
        MovieDetailState(
          movieState: RequestState.loadedState,
          movie: testMovieDetail,
          recommendationState: RequestState.loadedState,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: false,
        ),
      );
      when(mockMovieDetailBloc.stream).thenAnswer(
        (_) => Stream.value(
          MovieDetailState(
            movieState: RequestState.loadedState,
            movie: testMovieDetail,
            recommendationState: RequestState.loadedState,
            movieRecommendations: <Movie>[],
            isAddedToWatchlist: false,
          ),
        ),
      );

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should dispay check icon when movie is added to wathclist',
    (WidgetTester tester) async {
      when(mockMovieDetailBloc.state).thenReturn(
        MovieDetailState(
          movieState: RequestState.loadedState,
          movie: testMovieDetail,
          recommendationState: RequestState.loadedState,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: true,
        ),
      );
      when(mockMovieDetailBloc.stream).thenAnswer(
        (_) => Stream.value(
          MovieDetailState(
            movieState: RequestState.loadedState,
            movie: testMovieDetail,
            recommendationState: RequestState.loadedState,
            movieRecommendations: <Movie>[],
            isAddedToWatchlist: true,
          ),
        ),
      );

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets('Watchlist button should trigger add to watchlist when clicked', (
    WidgetTester tester,
  ) async {
    when(mockMovieDetailBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.loadedState,
        movie: testMovieDetail,
        recommendationState: RequestState.loadedState,
        movieRecommendations: <Movie>[],
        isAddedToWatchlist: false,
      ),
    );
    when(mockMovieDetailBloc.stream).thenAnswer(
      (_) => Stream.value(
        MovieDetailState(
          movieState: RequestState.loadedState,
          movie: testMovieDetail,
          recommendationState: RequestState.loadedState,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: false,
        ),
      ),
    );

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    verify(mockMovieDetailBloc.add(AddToWatchlist(testMovieDetail)));
  });
}
