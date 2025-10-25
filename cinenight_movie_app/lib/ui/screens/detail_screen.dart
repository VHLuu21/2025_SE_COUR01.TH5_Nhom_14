import 'package:cinenight_movie_app/core/theme/app_colors.dart';
import 'package:cinenight_movie_app/data/movie_service.dart';
import 'package:cinenight_movie_app/data/userpref.dart';
import 'package:cinenight_movie_app/provider/movie_provider.dart';
import 'package:cinenight_movie_app/ui/screens/trailer_screen.dart';
import 'package:cinenight_movie_app/ui/widgets/cast_horizontal.dart';
import 'package:cinenight_movie_app/ui/widgets/movie_horizontal_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_fonts.dart';
import '../../data/movie.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  final Movie movie;
  const DetailsScreen({super.key, required this.movie});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Movie? detailedMovie;
  bool isLoading = true;
  int? userId;

  @override
  void initState() {
    super.initState();
    _initUser();
    _loadMovieDetail();
  }

  Future<void> _initUser() async {
    userId = (await Userpref.getid())!;
    setState(() {});
  }

  Future<void> _loadMovieDetail() async {
    final lang = context.read<MovieProvider>().language;
    try {
      final movie = await MovieService.fetchMovieDetail(widget.movie.id, lang);
      setState(() {
        detailedMovie = movie ?? widget.movie;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        detailedMovie = widget.movie;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final lang = movieProvider.language;
    final movie = detailedMovie ?? widget.movie;
    final isWishlist = movieProvider.isInWishlist(movie);
    final isFavorite = movieProvider.isFavorite(movie);

    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background2,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background2,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster phim
            Stack(
              children: [
                Hero(
                  tag: widget.movie.id,
                  child: Image.network(
                    movie.posterPath != null
                        ? "https://image.tmdb.org/t/p/w500${movie.posterPath}"
                        : "https://via.placeholder.com/300x450?text=No+Image",
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                  ),
                ),

                // Overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.black.withValues(alpha: 0.9),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Back button
                Positioned(
                  top: 30,
                  left: 12,
                  child: CircleAvatar(
                    backgroundColor: AppColors.button2,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                // Tiêu đề + Actions + Play
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: AppFonts.montserrat,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              final trailerKey =
                                  await MovieService.getMovieTrailer(
                                    movie.id,
                                    lang,
                                  );
                              if (trailerKey != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TrailerScreen(youtubeKey: trailerKey),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("No trailer available"),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                            label: Text(
                              "play".tr(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.button2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: userId == null
                                ? null
                                : () {
                                    movieProvider.toggleWishlist(
                                      movie,
                                      userId!,
                                    );
                                  },
                            icon: Icon(
                              isWishlist ? Icons.check : Icons.add,
                              color: isWishlist ? Colors.green : Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: userId == null
                                ? null
                                : () {
                                    movieProvider.toggleFavorite(
                                      movie,
                                      userId!,
                                    );
                                  },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            //Thông tin phim
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage?.toStringAsFixed(1) ?? "N/A",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    movie.releaseDate ?? "Unknown",
                    style: const TextStyle(
                      fontFamily: AppFonts.montserrat,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    "over_view".tr(),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.roboto,
                    ),
                  ),
                  Text(
                    movie.overview ?? "No description available",
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppFonts.roboto,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            //Danh sách cast
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 10),
              child: Text(
                "cast".tr(),
                style: const TextStyle(
                  color: AppColors.button2,
                  fontFamily: AppFonts.montserrat,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder(
              future: MovieService.fetchMovieCast(movie.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No casts available"));
                } else {
                  return CastHorizontal(casts: snapshot.data!);
                }
              },
            ),
            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "recommendation".tr(),
                style: const TextStyle(
                  color: AppColors.button2,
                  fontFamily: AppFonts.montserrat,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            FutureBuilder(
              future: MovieService.fetchTopRate(lang),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No movie available");
                } else {
                  return MovieHorizontalList(movies: snapshot.data!);
                }
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
