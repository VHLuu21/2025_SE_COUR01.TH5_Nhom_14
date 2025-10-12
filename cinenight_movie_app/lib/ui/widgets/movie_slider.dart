import 'dart:async';
import 'package:cinenight_movie_app/data/movie_service.dart';
import 'package:cinenight_movie_app/provider/movie_provider.dart';
import 'package:cinenight_movie_app/ui/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../data/movie.dart';
import '../../core/theme/app_colors.dart';

class MovieSlider extends StatefulWidget {
  const MovieSlider({super.key});

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);

    final lang = Provider.of<MovieProvider>(context, listen: false).language;
    _moviesFuture = MovieService.fetchNowPlaying(lang);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: _moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 250,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 250,
            child: Center(child: Text("Error: ${snapshot.error}")),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 250,
            child: Center(child: Text("No movies found")),
          );
        }

        final movies = snapshot.data!;

        // Tạo auto-slide
        _timer ??= Timer.periodic(const Duration(seconds: 3), (Timer timer) {
          if (_currentPage < movies.length - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }

          if (_pageController.hasClients) {
            _pageController.animateToPage(
              _currentPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });

        return Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsScreen(movie: movie),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          movie.posterPath != null
                              ? "https://image.tmdb.org/t/p/w500${movie.posterPath}"
                              : "https://via.placeholder.com/300x450?text=No+Image", // fallback
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        // Title + genre
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                movie.releaseDate ?? "Unknow",
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    193,
                                    255,
                                    255,
                                    255,
                                  ),
                                ),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        // Play icon
                        const Positioned(
                          right: 150,
                          bottom: 150,
                          child: Icon(
                            Icons.play_circle_rounded,
                            color: Color.fromARGB(196, 255, 255, 255),
                            size: 70,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Indicator
            Positioned(
              bottom: 5,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: movies.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: AppColors.button,
                    dotColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
