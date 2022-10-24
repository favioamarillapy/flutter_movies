import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_movies/src/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = "api.themoviedb.org";
  final String _apiLanguage = "es-ES";
  final String _apiKey = "e50941327d527edb5a092d21da38c824";

  List<Movie> nowPlayMovies = [];
  List<Movie> popularMovies = [];
  int popularPage = 0;
  bool isLoading = false;

  MoviesProvider() {
    getNowPlayMovies();
    getPopular();
  }

  _getJsonData(String endpoint, int page) async {
    var url = Uri.https(_baseUrl, endpoint, {
      "api_key": _apiKey,
      "language": _apiLanguage,
      "page": page.toString()
    });

    final response = await http.get(url);
    return response.body;
  }

  getNowPlayMovies() async {
    final response = await _getJsonData("3/movie/now_playing", 1);
    final nowPlayingResponse = NowPlayingResponse.fromJson(response);
    nowPlayMovies = nowPlayingResponse.results;

    notifyListeners();
  }

  getPopular() async {
    if (isLoading) return;

    popularPage++;
    isLoading = true;
    final response = await _getJsonData("3/movie/popular", popularPage);
    final popularResponse = PopularResponse.fromJson(response);
    isLoading = false;
    popularMovies = [...popularMovies, ...popularResponse.results];
    print(popularMovies.length);

    notifyListeners();
  }
}
