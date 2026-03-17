import 'dart:convert';

import 'package:core/common/exception.dart';
import 'package:http/http.dart' as http;
import 'package:tv_series/data/models/tv_series_detail_model.dart';
import 'package:tv_series/data/models/tv_series_model.dart';
import 'package:tv_series/data/models/tv_series_response.dart';

abstract class TvSeriesRemoteDataSource {
  Future<List<TvSeriesModel>> getNowPlayingTvSeries();
  Future<List<TvSeriesModel>> getPopularTvSeries();
  Future<List<TvSeriesModel>> getTopRatedTvSeries();
  Future<TvSeriesDetailResponse> getTvSeriesDetail(int id);
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id);
  Future<List<TvSeriesModel>> searchTvSeries(String query);
}

class TvSeriesRemoteDataSourceImpl implements TvSeriesRemoteDataSource {
  static const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const baseUrl = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvSeriesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvSeriesModel>> getNowPlayingTvSeries() async {
    return _fetchTvSeriesList('$baseUrl/tv/airing_today?$apiKey');
  }

  @override
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id) async {
    return _fetchTvSeriesList('$baseUrl/tv/$id/recommendations?$apiKey');
  }

  @override
  Future<List<TvSeriesModel>> getPopularTvSeries() async {
    return _fetchTvSeriesList('$baseUrl/tv/popular?$apiKey');
  }

  @override
  Future<List<TvSeriesModel>> getTopRatedTvSeries() async {
    return _fetchTvSeriesList('$baseUrl/tv/top_rated?$apiKey');
  }

  @override
  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    return _fetchTvSeriesList('$baseUrl/search/tv?$apiKey&query=$query');
  }

  @override
  Future<TvSeriesDetailResponse> getTvSeriesDetail(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/tv/$id?$apiKey'));

    if (response.statusCode == 200) {
      return TvSeriesDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  Future<List<TvSeriesModel>> _fetchTvSeriesList(String url) async {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }
}
