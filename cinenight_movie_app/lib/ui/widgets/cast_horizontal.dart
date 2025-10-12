import 'package:cinenight_movie_app/core/theme/app_colors.dart';
import 'package:cinenight_movie_app/data/cast.dart';
import 'package:flutter/material.dart';

class CastHorizontal extends StatelessWidget {
  final List<Cast> casts;

  const CastHorizontal({super.key, required this.casts});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: casts.length,
        itemBuilder: (context, index) {
          final cast = casts[index];
          return SizedBox(
            width: 130,
            height: 200,
           
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    cast.profilePath != null
                        ? "https://image.tmdb.org/t/p/w200${cast.profilePath}"
                        : "https://via.placeholder.com/100x100?text=No+Image",
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 5,),
                Text(
                  cast.name,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
