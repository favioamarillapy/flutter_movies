import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_movies/src/helpers/debouncer.dart';
import 'package:flutter_movies/src/models/search_movies_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_movies/src/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = "api.themoviedb.org";
  final String _apiLanguage = "es-ES";
  final String _apiKey = "e50941327d527edb5a092d21da38c824";

  List<Movie> nowPlayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> moviesCast = {};

  int popularPage = 0;
  bool isLoading = false;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
    onValue: (value) {},
  );

  final StreamController<List<Movie>> _streamController =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _streamController.stream;

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

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final response = await _getJsonData("3/movie/${movieId}/credits", 1);
    final creditsResponse = CreditsResponse.fromJson(response);
    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> getSearchMovies(String query) async {
    var url = Uri.https(_baseUrl, "3/search/movie",
        {"api_key": _apiKey, "language": _apiLanguage, "query": query});

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionByQuery(String query) {
    debouncer.value = "";
    debouncer.onValue = (value) async {
      final results = await getSearchMovies(query);
      _streamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      debouncer.value = query;
    });

    Future.delayed(Duration(milliseconds: 301)).then((value) => timer.cancel());
  }
}
