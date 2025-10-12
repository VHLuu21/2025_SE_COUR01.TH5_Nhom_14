import 'dart:async';
import 'package:cinenight_movie_app/data/movie.dart';
import 'package:cinenight_movie_app/data/movie_service.dart';
import 'package:cinenight_movie_app/provider/movie_provider.dart';
import 'package:cinenight_movie_app/ui/screens/seemore_screen.dart';
import 'package:cinenight_movie_app/ui/widgets/movie_grid.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../widgets/movie_horizontal_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = "";
  List<Movie> searchResults = [];
  bool isLoading = false;
  Timer? _debounce;

  // Xử lí sự kiện nhập, không gọi API liên tục, khi tạm dừng nhập sẽ gửi request 
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchMovies(value);
    });
  }

  // Hàm tìm kiếm movie
  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
      return;
    }

    setState(() => isLoading = true);

    try {
      final lang = context.read<MovieProvider>().language;
      final results = await MovieService.searchMovies(query, lang);
      print("Search query: $query, results: ${results.length}");
      setState(() {
        searchResults = results;
        isLoading = false;
      });
      debugPrint("Search results: ${results.length}");
    } catch (e) {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
      debugPrint("Search error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<MovieProvider>().language;
    return Scaffold(
      backgroundColor: AppColors.background2,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40,
            bottom: 8,
            left: 10,
            right: 10,
          ),
          child: TextField(
            onChanged: (value) {
              setState(() => query = value);
              _onSearchChanged(value);
            },
            style: TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: "search".tr(),
              hintStyle: TextStyle(color: Color.fromARGB(179, 47, 46, 46)),
              filled: true,
              fillColor: AppColors.backgroundfield,
              prefixIcon: Icon(Icons.search, color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      body: query.isEmpty
          // Mặc định hiển thị list như Home
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "recommendation".tr(),
                          style: TextStyle(
                            fontFamily: AppFonts.montserrat,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final movies = await MovieService.fetchUpComing(
                              lang,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SeemoreScreen(
                                  title: "recommendation".tr(),
                                  movies: movies,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "see_more".tr(),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppFonts.roboto,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<List<Movie>>(
                    future: MovieService.fetchNowPlaying(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text("No movies found");
                      }
                      return MovieHorizontalList(movies: snapshot.data!);
                    },
                  ),

                  const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "trendings".tr(),
                          style: TextStyle(
                            fontFamily: AppFonts.montserrat,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final movies = await MovieService.fetchUpComing(
                              lang,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SeemoreScreen(
                                  title: "trending_more".tr(),
                                  movies: movies,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "see_more".tr(),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppFonts.roboto,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<List<Movie>>(
                    future: MovieService.fetchUpComing(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text("No movies found");
                      }
                      return MovieHorizontalList(movies: snapshot.data!);
                    },
                  ),

                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "top_rate".tr(),
                          style: TextStyle(
                            fontFamily: AppFonts.montserrat,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final movies = await MovieService.fetchUpComing(
                              lang,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SeemoreScreen(
                                  title: "top_rate_more".tr(),
                                  movies: movies,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "see_more".tr(),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppFonts.roboto,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<List<Movie>>(
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
                        return const Text("No movies found");
                      }
                      return MovieHorizontalList(movies: snapshot.data!);
                    },
                  ),

                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "popular".tr(),
                          style: TextStyle(
                            fontFamily: AppFonts.montserrat,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final movies = await MovieService.fetchUpComing(
                              lang,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SeemoreScreen(
                                  title: "popular_more".tr(),
                                  movies: movies,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "see_more".tr(),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppFonts.roboto,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<List<Movie>>(
                    future: MovieService.fetchPopularMovies(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text("No movies found");
                      }
                      return MovieHorizontalList(movies: snapshot.data!);
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            )
          // Nếu có query thì show kết quả
          : isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : query.isNotEmpty
          ? (searchResults.isNotEmpty
                ? MovieGrid(movies: searchResults)
                : const Center(
                    child: Text(
                      "No movie found",
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
          : const SizedBox.shrink(),
    );
  }
}
