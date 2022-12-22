import 'dart:async';

import 'package:flutter/material.dart';
import 'package:motchill/models/detail_movie_model.dart';
import 'package:motchill/models/genres_movie_model.dart';
import 'package:motchill/models/movie_model.dart';
import 'package:motchill/models/now_playing_model.dart';
import 'package:http/http.dart' as http;
import 'package:motchill/models/search_model.dart';

import '../models/get_video_model.dart';
import '../models/video_model.dart';

class MovieProvide extends ChangeNotifier {
  final String _apiKey = 'd8f8edbbdc27ab9a16942772f29aa16c';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'vi';
  // late DetailMovieModel detailMovie = [] ;
  List<Movie> onDisplayMovies = [];
  List<Movie> onDisplayTvShows = [];
  List<Video> dataVideos = [];
  List<Movie> onDisplayMoviesGenres = [];
  DetailMovieModel dataDetail = new DetailMovieModel();
  Future<String> _getJsonData(String category, String endPoint,
      [int page = 1]) async {
    final url = Uri.https(_baseUrl, '3/${category}/${endPoint}', {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });

    final response = await http.get(url);
    return response.body;
  }

  Future<String> _getJsonData_Discover(String category, [int page = 1]) async {
    final url = Uri.https(_baseUrl, '3/discover/${category}', {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });

    final response = await http.get(url);
    return response.body;
  }

  getOnDiaplayMovies() async {
    final jsonData = await _getJsonData('movie', 'now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPlayingResponse.results!;
    notifyListeners();
  }

  Future<String> _getJsonData_Video(String category, String id,
      [int page = 1]) async {
    final url = Uri.https(_baseUrl, '3/${category}/${id}/videos', {
      'api_key': _apiKey,
      'language': "en",
      'page': '$page',
    });

    final response = await http.get(url);
    return response.body;
  }

  getVideo(String category, String? id) async {
    final jsonData = await _getJsonData_Video(category, id.toString());
    final getvideoData = GetVideoModel.fromJson(jsonData);
    dataVideos = getvideoData.results!;
    notifyListeners();
  }

  Future<String> _getJsonData_Detail(String category, String id) async {
    final url = Uri.https(_baseUrl, '3/movie/${id}', {
      'api_key': _apiKey,
      'language': "vi",
    });
// https://api.themoviedb.org/3/movie/982620?api_key=d8f8edbbdc27ab9a16942772f29aa16c&language=vi
    final response = await http.get(url);
    return response.body;
  }

  getDetail(String category, String? id) async {
    final jsonData = await _getJsonData_Detail(category, id.toString());
    final getvideoData = DetailMovieModel.fromJson(jsonData);
    dataDetail = getvideoData;
    notifyListeners();
  }

  Future<String> _getJsonData_Genres(
      String category, String genres, int page) async {
    // final url = Uri.https(_baseUrl, '3/movie', {
    //   'api_key': _apiKey,
    //   'with_genres': genres,
    //   'language': "vi",
    // });
    final url = Uri.https(_baseUrl, '3/discover/movie', {
      'api_key': _apiKey,
      'with_genres': genres,
      'language': "vi",
      'page': '$page',
    });
    print(url);

// https://api.themoviedb.org/3/movie/982620?api_key=d8f8edbbdc27ab9a16942772f29aa16c&language=vi
    final response = await http.get(url);
    return response.body;
  }

  getGenresFilm(String category, String? genres) async {
    print("-----------------$genres");
    onDisplayMoviesGenres.clear();
    int pageFetch = 3;
    for (int i = 1; i <= pageFetch; i++) {
      final jsonData =
          await _getJsonData_Genres(category, genres.toString(), i);
      final getMovieData = GenresMovieModel.fromJson(jsonData);
      onDisplayMoviesGenres = [
        ...onDisplayMoviesGenres,
        ...getMovieData.results!,
      ];
    }
    // ${baseURL}/discover/${category}?api_key=${api_key}&with_genres=${genres}&language=vi

    // final jsonData2 = await _getJsonData_Genres(category, genres.toString(), 2);

    // onDisplayMoviesGenres = getMovieData.results!;
    notifyListeners();
  }

  Future<List<Movie>> searchMovie(String query) async {
    int page = 10;
    List<Movie> searchResult = [];
    for (int i = 1; i <= page; i++) {
      final url = Uri.https(_baseUrl, '3/search/movie', {
        'api_key': _apiKey,
        'language': _language,
        'page': i.toString(),
        'query': query,
      });
      final response = await http.get(url);
      final searchResponse = SearchModel.fromJson(response.body);
      //  searchResult = searchResponse.results as Movie ;
      searchResult = [
        ...searchResult,
        ...searchResponse.results,
      ];
    }
    return searchResult;
  }

  MovieProvide() {
    getOnDiaplayMovies();
  }
}
