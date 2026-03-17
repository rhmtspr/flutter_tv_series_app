import 'dart:convert';
import 'package:core/common/exception.dart';
import 'package:http/http.dart' as http;
import 'package:movies/data/models/movies_detail_model.dart';
import 'package:movies/data/models/movies_model.dart';
import 'package:movies/data/models/movies_response.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailResponse> getMovieDetail(int id);
  Future<List<MovieModel>> getMovieRecommendations(int id);
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  static const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const baseUrl = 'https://api.themoviedb.org/3';

  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    return _fetchMoviesList('$baseUrl/movie/now_playing?$apiKey');
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    return _fetchMoviesList('$baseUrl/movie/popular?$apiKey');
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    return _fetchMoviesList('$baseUrl/movie/top_rated?$apiKey');
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    return _fetchMoviesList('$baseUrl/movie/$id/recommendations?$apiKey');
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    return _fetchMoviesList('$baseUrl/search/movie?$apiKey&query=$query');
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/movie/$id?$apiKey'));

    if (response.statusCode == 200) {
      return MovieDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  Future<List<MovieModel>> _fetchMoviesList(String url) async {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }
}
