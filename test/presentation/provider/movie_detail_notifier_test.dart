import 'package:dartz/dartz.dart';
import 'package:flutter_tv_series_app/domain/entities/movie.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_movie_detail.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_movie_recommendations.dart';
import 'package:flutter_tv_series_app/common/failure.dart';
import 'package:flutter_tv_series_app/domain/usecases/get_watchlist_status_movie.dart';
import 'package:flutter_tv_series_app/domain/usecases/remove_watchlist.dart';
import 'package:flutter_tv_series_app/domain/usecases/save_watchlist_movie.dart';
import 'package:flutter_tv_series_app/presentation/provider/movie_detail_notifier.dart';
import 'package:flutter_tv_series_app/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatusMovie,
  SaveWatchlistMovie,
  RemoveWatchlistMovie,
])
void main() {
  late MovieDetailNotifier provider;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatusMovie mockGetWatchlistStatusMovie;
  late MockSaveWatchlistMovie mockSaveWatchlistMovie;
  late MockRemoveWatchlistMovie mockRemoveWatchlistMovie;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatusMovie = MockGetWatchListStatusMovie();
    mockSaveWatchlistMovie = MockSaveWatchlistMovie();
    mockRemoveWatchlistMovie = MockRemoveWatchlistMovie();
    provider =
        MovieDetailNotifier(
          getMovieDetail: mockGetMovieDetail,
          getMovieRecommendations: mockGetMovieRecommendations,
          getWatchListStatusMovie: mockGetWatchlistStatusMovie,
          saveWatchlistMovie: mockSaveWatchlistMovie,
          removeWatchlistMovie: mockRemoveWatchlistMovie,
        )..addListener(() {
          listenerCallCount += 1;
        });
  });

  final tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  void _arrangeUsecase() {
    when(
      mockGetMovieDetail.execute(tId),
    ).thenAnswer((_) async => Right(testMovieDetail));
    when(
      mockGetMovieRecommendations.execute(tId),
    ).thenAnswer((_) async => Right(tMovies));
  }

  group('Get Movie Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchMovieDetail(tId);
      // assert
      expect(provider.movieState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change movie when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      expect(provider.movieState, RequestState.Loaded);
      expect(provider.movie, testMovieDetail);
      expect(listenerCallCount, 3);
    });

    test(
      'should change recommendation movies when data is gotten successfully',
      () async {
        // arrange
        _arrangeUsecase();
        // act
        await provider.fetchMovieDetail(tId);
        // assert
        expect(provider.movieState, RequestState.Loaded);
        expect(provider.movieRecommendations, tMovies);
      },
    );
  });

  group('Get Movie Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      verify(mockGetMovieRecommendations.execute(tId));
      expect(provider.movieRecommendations, tMovies);
    });

    test(
      'should update recommendation state when data is gotten successfully',
      () async {
        // arrange
        _arrangeUsecase();
        // act
        await provider.fetchMovieDetail(tId);
        // assert
        expect(provider.recommendationState, RequestState.Loaded);
        expect(provider.movieRecommendations, tMovies);
      },
    );

    test('should update error message when request in successful', () async {
      // arrange
      when(
        mockGetMovieDetail.execute(tId),
      ).thenAnswer((_) async => Right(testMovieDetail));
      when(
        mockGetMovieRecommendations.execute(tId),
      ).thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(
        mockGetWatchlistStatusMovie.execute(1),
      ).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(
        mockSaveWatchlistMovie.execute(testMovieDetail),
      ).thenAnswer((_) async => Right('Success'));
      when(
        mockGetWatchlistStatusMovie.execute(testMovieDetail.id),
      ).thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testMovieDetail);
      // assert
      verify(mockSaveWatchlistMovie.execute(testMovieDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(
        mockRemoveWatchlistMovie.execute(testMovieDetail),
      ).thenAnswer((_) async => Right('Removed'));
      when(
        mockGetWatchlistStatusMovie.execute(testMovieDetail.id),
      ).thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(testMovieDetail);
      // assert
      verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(
        mockSaveWatchlistMovie.execute(testMovieDetail),
      ).thenAnswer((_) async => Right('Added to Watchlist'));
      when(
        mockGetWatchlistStatusMovie.execute(testMovieDetail.id),
      ).thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testMovieDetail);
      // assert
      verify(mockGetWatchlistStatusMovie.execute(testMovieDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(
        mockSaveWatchlistMovie.execute(testMovieDetail),
      ).thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(
        mockGetWatchlistStatusMovie.execute(testMovieDetail.id),
      ).thenAnswer((_) async => false);
      // act
      await provider.addWatchlist(testMovieDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetMovieDetail.execute(tId),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(
        mockGetMovieRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(tMovies));
      // act
      await provider.fetchMovieDetail(tId);
      // assert
      expect(provider.movieState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
