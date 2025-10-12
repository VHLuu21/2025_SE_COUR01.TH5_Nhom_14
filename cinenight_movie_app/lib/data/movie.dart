class Movie {
  final int id;
  final String title; //Ten film
  final String? posterPath; //Anh poster
  final String? overview; //The loai
  final String? releaseDate;
  final double? voteAverage;

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.overview,
    this.releaseDate,
    this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json["id"],
      title: json["title"] ?? "",
      posterPath: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500${json['poster_path']}"
          : "https://via.placeholder.com/500x750?text=No+Image",
      overview: json["overview"],
      releaseDate: json["release_date"] ?? "Unknow",
      voteAverage: (json["vote_average"] is int)
          ? (json["vote_average"] as int).toDouble()
          : json["vote_average"]?.toDouble(),
    );
  }
}
