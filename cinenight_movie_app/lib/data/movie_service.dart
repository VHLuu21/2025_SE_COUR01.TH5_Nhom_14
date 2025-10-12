
import 'dart:convert';

import 'package:cinenight_movie_app/core/api/tmdb_api.dart';
import 'package:cinenight_movie_app/data/cast.dart';
import 'package:cinenight_movie_app/data/movie.dart';
import 'package:http/http.dart' as http;

class MovieService {

  static Future<List<Movie>> fetchPopularMovies(String lang) async{
    final response = await http.get(Uri.parse(TMDBApi.getPopularMovies(lang)));

    if(response.statusCode == 200){
      final data = json.decode(response.body);
      List movies = data["results"];
      return movies.map((json) => Movie.fromJson(json)).toList();
    }else{
      throw Exception("Failed to load movies");
    }
  }

  static Future<List<Movie>> searchMovies(String query, String lang) async{
    final response = await http.get(Uri.parse(TMDBApi.searchMovies(query, lang)));

    if(response.statusCode == 200){
      final data = json.decode(response.body);
      List movies = data["results"];
      return movies.map((json) => Movie.fromJson(json)).toList();
    }else{
      throw Exception("Failed to search movies");
    }
  }

  static Future<Movie?> fetchMovieDetail(int movieId, String lang) async{
    final response = await http.get(Uri.parse(TMDBApi.getMovieDetail(movieId, lang)));

    if(response.statusCode == 200){
      final data = json.decode(response.body);
      return Movie.fromJson(data);
    }else{
      throw Exception("Failed to load movies detail");
    }
  }

  static Future<List<Movie>> fetchNowPlaying(String lang) async{
    final response = await http.get(Uri.parse(TMDBApi.getNowPlaying(lang)));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List movies = data["results"];
      return movies.map((json) => Movie.fromJson(json)).toList();
    }else{
      throw Exception("Failed to load movies");
    }
  }

  static Future<List<Movie>> fetchUpComing(String lang) async{
    final response = await http.get(Uri.parse(TMDBApi.getUpComing(lang)));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List movies = data["results"];
      return movies.map((json) => Movie.fromJson(json)).toList();
    }else{
      throw Exception("Failed to load movies");
    }
  }

  static Future<List<Movie>> fetchTopRate(String lang) async{
    final response = await http.get(Uri.parse(TMDBApi.getTopRate(lang)));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List movies = data["results"];
      return movies.map((json) => Movie.fromJson(json)).toList();
    }else{
      throw Exception("Failed to load movies");
    }
  }

  static Future<String?> getMovieTrailer(int movieId, String lang) async{
    final response = await http.get(Uri.parse(TMDBApi.getMovieTrailer(movieId, lang)));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List videos = data["results"];

      final trailer = videos.firstWhere(
        (video) => video["type"] == "Trailer" && video["site"] == "YouTube",
        orElse: () => null
      );

      if (trailer != null) {
        return trailer["key"];
      }

      if (lang != "en-US") {
        return await getMovieTrailer(movieId, "en-US");
      }
      return null;
    }else{
      throw Exception("Failed to load trailer");
    }
  }

  static Future<List<Cast>> fetchMovieCast(int movieId) async{
    final url = Uri.parse(TMDBApi.getMovieCast(movieId));
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List castJson = data["cast"];
      return castJson.map((json) => Cast.fromJson(json)).toList();
    }else{
      throw Exception("Failed to load cast");
    }
  }
}