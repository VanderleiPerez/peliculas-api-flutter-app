import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/models/models.dart';
import 'dart:convert';

import 'package:peliculas/models/now_playing_response.dart';
import 'package:peliculas/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {
  String _baseURL = 'api.themoviedb.org';
  String _apiKey = '8d6ed2ec2251fc94ee265133935c8d8f';
  String _language = 'es-ES';
  // Lista donde se almacenará
  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  // Paraincrementar en 1 el scroll del POPULAR
  int _popularPage = 0;
  // Para la lista de actores id: "id" es de la pelicula
  Map<int, List<Cast>> moviesCast = {};

  MoviesProvider() {
    print('Movie Provider inicializado');
    // This es opcional, pero es bueno para saber el método que se llama
    this.getOnDisplayMovie();
    this.getPopularMovie();
  }
  // OPTIMIZAR CÓDIGO
  Future<String> _getJsonData(String endPoint, [int page = 1]) async {
    final url = Uri.https(_baseURL, endPoint,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});

    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovie() async {
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    //print(response.body);
    //final Map<String, dynamic> decodedData = json.decode(response.body);
    //print("MÁS DATA");
    //print(decodedData['results'][0]);
    //print(nowPlayingResponse.results[0].title);
    onDisplayMovies = nowPlayingResponse.results;
    // Avisa a los widget que escuchen el cambio, para redibujar
    notifyListeners();
  }

  getPopularMovie() async {
    final jsonData = await _getJsonData(
      '3/movie/popular',
    );
    final popularResponse = PopularResponse.fromJson(jsonData);
    //final Map<String, dynamic> decodedData = json.decode(response.body);
    // Se desarma, porque se va a trabajar con 'page'
    popularMovies = [...popularMovies, ...popularResponse.results];
    //print(popularMovies[0]);
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    // No repetir petición. Se tiene que poner ! porque dart no lo detecta
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    print('Pidiendo info al servidor de actores');

    final jsonData = await _getJsonData(
      '3/movie/$movieId/credits',
    );
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
    print(creditsResponse.cast);
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseURL, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }
}
