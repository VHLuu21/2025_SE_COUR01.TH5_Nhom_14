import 'package:cinenight_movie_app/data/favorite_service.dart';
import 'package:cinenight_movie_app/data/movie_service.dart';
import 'package:cinenight_movie_app/data/wishlist_service.dart';
import 'package:flutter/material.dart';
import '../data/movie.dart';

class MovieProvider with ChangeNotifier {
  final List<Movie> _favorites = [];
  final List<Movie> _wishlist = [];

  List<Movie> get favorites => _favorites;
  List<Movie> get wishlist => _wishlist;

  String _language = "en-US";
  String get language => _language;

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  bool isFavorite(Movie movie) => _favorites.any((m) => m.id == movie.id);
  bool isInWishlist(Movie movie) => _wishlist.any((m) => m.id == movie.id);

  Future<void> loadWishlist(int userId) async {
    final wishlistIds = await WishlistService.getWishlist(userId);
    _wishlist.clear();
    for (final id in wishlistIds) {
      final movie = await MovieService.fetchMovieDetail(id, _language);
      if (movie != null) {
        _wishlist.add(movie);
      }
    }
    notifyListeners();
  }

  void toggleWishlist(Movie movie, int userId) async {
    if (isInWishlist(movie)) {
      _wishlist.removeWhere((m) => m.id == movie.id);
      await WishlistService.removeFromWishlist(userId, movie.id);
    } else {
      _wishlist.add(movie);
      await WishlistService.addToWishlist(userId, movie.id);
    }
    notifyListeners();
  }

    Future<void> loadFavorite(int userId) async {
    final favoritesIds = await FavoriteService.getFavorite(userId);
    _favorites.clear();
    for (final id in favoritesIds) {
      final movie = await MovieService.fetchMovieDetail(id, _language);
      if (movie != null) {
        _favorites.add(movie);
      }
    }
    notifyListeners();
  }

    void toggleFavorite(Movie movie, int userId) async {
    if (isFavorite(movie)) {
      _favorites.removeWhere((m) => m.id == movie.id);
      await FavoriteService.removeFromFavorite(userId, movie.id);
    } else {
      _favorites.add(movie);
      await FavoriteService.addToFavorite(userId, movie.id);
    }
    notifyListeners();
  }
}
