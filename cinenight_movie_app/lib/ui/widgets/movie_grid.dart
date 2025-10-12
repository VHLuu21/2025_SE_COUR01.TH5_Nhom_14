import 'package:cinenight_movie_app/data/movie.dart';
import 'package:cinenight_movie_app/ui/screens/detail_screen.dart';
import 'package:flutter/material.dart';

class MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  const MovieGrid({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: movies.length,
      padding: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 80),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailsScreen(movie: movie)),
            );
          },
          child: Hero(
            tag: movie.id,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: Offset(1, 1),
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
