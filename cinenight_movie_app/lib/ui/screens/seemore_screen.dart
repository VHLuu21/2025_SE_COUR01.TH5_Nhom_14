
import 'package:cinenight_movie_app/data/movie.dart';
import 'package:cinenight_movie_app/ui/widgets/movie_grid.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SeemoreScreen extends StatelessWidget {
  final String title;
  final List<Movie> movies;

  const SeemoreScreen({super.key, required this.title, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background2,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.message,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MovieGrid(movies: movies),
      ),
    );
  }
}
