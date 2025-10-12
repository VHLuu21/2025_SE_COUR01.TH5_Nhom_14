import 'package:cinenight_movie_app/core/theme/app_colors.dart';
import 'package:cinenight_movie_app/core/theme/app_fonts.dart';
import 'package:cinenight_movie_app/ui/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import '../../data/movie.dart';

class MovieHorizontalList extends StatelessWidget {
  final List<Movie> movies;

  const MovieHorizontalList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(top: 8, left: 17, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsScreen(movie: movie),
                      ),
                    );
                  },
                  child: Hero(
                    tag: movie.id,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: Offset(5, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          movie.posterPath != null
                              ? "https://image.tmdb.org/t/p/w500${movie.posterPath}"
                              : "https://via.placeholder.com/300x450?text=No+Image",
                          fit: BoxFit.cover,
                          width: 120,
                          height: 175,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 15),
                    SizedBox(width:2),
                    Text(
                      movie.voteAverage?.toStringAsFixed(1) ?? "N/A",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: AppFonts.roboto,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
