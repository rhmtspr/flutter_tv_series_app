import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter_tv_series_app/domain/entities/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tv_series_app/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:flutter_tv_series_app/presentation/pages/tv_series_detail_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_page_test.mocks.dart';

@GenerateMocks([TvSeriesDetailBloc])
void main() {
  late MockTvSeriesDetailBloc mockTvSeriesDetailBloc;

  setUp(() {
    mockTvSeriesDetailBloc = MockTvSeriesDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesDetailBloc>.value(
      value: mockTvSeriesDetailBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when tv series not added to watchlist',
    (WidgetTester tester) async {
      when(mockTvSeriesDetailBloc.state).thenReturn(
        TvSeriesDetailState(
          tvState: RequestState.loadedState,
          tv: testTvSeriesDetail,
          recommendationState: RequestState.loadedState,
          tvSeriesRecommendations: <TvSeries>[],
          isAddedToWatchlist: false,
        ),
      );
      when(mockTvSeriesDetailBloc.stream).thenAnswer(
        (_) => Stream.value(
          TvSeriesDetailState(
            tvState: RequestState.loadedState,
            tv: testTvSeriesDetail,
            recommendationState: RequestState.loadedState,
            tvSeriesRecommendations: <TvSeries>[],
            isAddedToWatchlist: false,
          ),
        ),
      );

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should dispay check icon when tv is added to wathclist',
    (WidgetTester tester) async {
      when(mockTvSeriesDetailBloc.state).thenReturn(
        TvSeriesDetailState(
          tvState: RequestState.loadedState,
          tv: testTvSeriesDetail,
          recommendationState: RequestState.loadedState,
          tvSeriesRecommendations: <TvSeries>[],
          isAddedToWatchlist: true,
        ),
      );
      when(mockTvSeriesDetailBloc.stream).thenAnswer(
        (_) => Stream.value(
          TvSeriesDetailState(
            tvState: RequestState.loadedState,
            tv: testTvSeriesDetail,
            recommendationState: RequestState.loadedState,
            tvSeriesRecommendations: <TvSeries>[],
            isAddedToWatchlist: true,
          ),
        ),
      );

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets('Watchlist button should trigger add to watchlist when clicked', (
    WidgetTester tester,
  ) async {
    when(mockTvSeriesDetailBloc.state).thenReturn(
      TvSeriesDetailState(
        tvState: RequestState.loadedState,
        tv: testTvSeriesDetail,
        recommendationState: RequestState.loadedState,
        tvSeriesRecommendations: <TvSeries>[],
        isAddedToWatchlist: false,
      ),
    );
    when(mockTvSeriesDetailBloc.stream).thenAnswer(
      (_) => Stream.value(
        TvSeriesDetailState(
          tvState: RequestState.loadedState,
          tv: testTvSeriesDetail,
          recommendationState: RequestState.loadedState,
          tvSeriesRecommendations: <TvSeries>[],
          isAddedToWatchlist: false,
        ),
      ),
    );

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    verify(mockTvSeriesDetailBloc.add(AddToWatchlist(testTvSeriesDetail)));
  });
}
