import 'package:cinenight_movie_app/core/theme/app_colors.dart';
import 'package:cinenight_movie_app/core/theme/app_fonts.dart';
import 'package:cinenight_movie_app/data/movie.dart';
import 'package:cinenight_movie_app/data/userpref.dart';
import 'package:cinenight_movie_app/provider/movie_provider.dart';
import 'package:cinenight_movie_app/ui/screens/detail_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>{
  bool _isLoading = true;
  @override
  void initState(){
    super.initState();
    _loadWishList();
    _loadFavorite();
  }

  // Hàm load wishlish theo id đang đăng nhập
  Future<void> _loadWishList() async{
    final userid = await Userpref.getid();
    if(userid == null){
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final provider = Provider.of<MovieProvider>(context, listen: false);
    await provider.loadWishlist(userid);
    setState(() {
      _isLoading = false;
    });
  }

  // Hàm load favorite theo id đang đăng nhập
  Future<void> _loadFavorite() async{
    final userid = await Userpref.getid();
    if(userid == null){
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (!mounted) return;
    final provider = Provider.of<MovieProvider>(context, listen: false);
    await provider.loadFavorite(userid);
    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background2,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "my_movies".tr(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 27,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.background2,
          bottom: TabBar(
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 4, color: AppColors.button2),
              insets: EdgeInsets.symmetric(horizontal: 110),
            ),
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: "wishlist".tr()),
              Tab(text: "favorite".tr()),
            ],
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            labelColor: AppColors.textPrimary,
            unselectedLabelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: TabBarView(
          children: [
            _MovieList(type: "wishlist", isLoading: _isLoading,),
            _MovieList(type: "favorite", isLoading: _isLoading,),
          ],
        ),
      ),
    );
  }
}

class _MovieList extends StatelessWidget {
  final String type;
  final bool isLoading;
  const _MovieList({required this.type, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context);
    final List<Movie> movies = type == "wishlist"
        ? provider.wishlist
        : provider.favorites;

    if(isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (movies.isEmpty) {
      return Center(
        child: Text("not_here".tr(), style: TextStyle(color: Colors.black)),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(18),
      child: GridView.builder(
        itemCount: movies.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final movie = movies[index];
          final posterUrl = movie.posterPath != null
              ? "https://image.tmdb.org/t/p/w500${movie.posterPath}"
              : "https://via.placeholder.com/300x450?text=No+Image";
          return SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    tag: movie.title,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.7),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: Offset(7, 7),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          posterUrl,
                          height: 220,
                          width: 158,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  movie.title,
                  style: TextStyle(
                    fontFamily: AppFonts.montserrat,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.button2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
