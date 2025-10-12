class TMDBApi {
  static const String apiKey = "43bc0beea3543d12a5f97c1d7438fc04";
  static const String baseUrl = "https://api.themoviedb.org/3";
  static const String imageBaseUrl = "https://image.tmdb.org/t/p/w500";

  //Enpoint popular
  static String getPopularMovies(String lang) =>
      "$baseUrl/movie/popular?api_key=$apiKey&language=$lang&page=1";
  
  static String getNowPlaying(String lang) =>
      "$baseUrl/movie/now_playing?api_key=$apiKey&language=$lang&page=1";
  
  static String getUpComing(String lang) =>
      "$baseUrl/movie/upcoming?api_key=$apiKey&language=$lang&page=1";
  
  static String getTopRate(String lang) =>
      "$baseUrl/movie/top_rated?api_key=$apiKey&language=$lang&page=1";

  static String searchMovies(String query, String lang) =>
      "$baseUrl/search/movie?api_key=$apiKey&language=$lang&query=$query&page=1&include_adult=false";

  static String getMovieDetail(int movieId, String lang) =>
      "$baseUrl/movie/$movieId?api_key=$apiKey&language=$lang";

  static String getMovieTrailer(int movieId, String lang) =>
      "$baseUrl/movie/$movieId/videos?api_key=$apiKey&language=$lang";

  static String getMovieCast(int movieId) =>
  "$baseUrl/movie/$movieId/credits?api_key=$apiKey&language=en-US";
}
