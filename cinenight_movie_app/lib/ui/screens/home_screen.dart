import 'package:cinenight_movie_app/core/theme/app_colors.dart';
import 'package:cinenight_movie_app/data/movie.dart';
import 'package:cinenight_movie_app/data/movie_service.dart';
import 'package:cinenight_movie_app/provider/movie_provider.dart';
import 'package:cinenight_movie_app/ui/screens/seemore_screen.dart';
import 'package:cinenight_movie_app/ui/widgets/animated_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ui/widgets/movie_slider.dart';
import '../widgets/movie_horizontal_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<MovieProvider>().language;
    return Scaffold(
      backgroundColor: AppColors.background2,
      body: SingleChildScrollView(
        //Phần slider
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: MovieSlider(),
            ),

            const SizedBox(height: 30),
            //Phần list view trendings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedText(
                    text: "trendings".tr(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  //Thêm sự kiện khi nhấn vào see more
                  GestureDetector(
                    onTap: () async {
                      final movies = await MovieService.fetchUpComing(lang);
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
                    child: AnimatedText(
                      text: "see_more".tr(),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 93, 93, 93),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Lấy data từ API nếu thành công sẽ truyền vào snapshot.data sau đó truyền vào MovieHorizontalList
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
            //Phần list view populars
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedText(
                    text: "popular".tr(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  //Thêm sự kiện khi nhấn vào see more
                  GestureDetector(
                    onTap: () async{
                      final movies = await MovieService.fetchUpComing(lang);
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
                    child: AnimatedText(
                      text: "see_more".tr(),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 93, 93, 93),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
             //Lấy data từ API nếu thành công sẽ truyền vào snapshot.data sau đó truyền vào MovieHorizontalList
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

            const SizedBox(height: 15),
            //Phần list view top rated
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedText(
                    text: "top_rate".tr(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  //Thêm sự kiện khi nhấn vào see more
                  GestureDetector(
                    onTap: () async{
                      final movies = await MovieService.fetchTopRate(lang);
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
                    child: AnimatedText(
                      text: "see_more".tr(),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 93, 93, 93),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
             //Lấy data từ API nếu thành công sẽ truyền vào snapshot.data sau đó truyền vào MovieHorizontalList
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
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
