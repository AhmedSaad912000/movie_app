
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/features/favorites/bloc/show_favorite_movies_bloc.dart';
import 'package:movie_app/core/util/helper_methods.dart';
import 'package:movie_app/features/movie_details/view/view.dart';
import 'package:movie_app/features/top_rated_movies/view/view.dart';
import 'package:movie_app/features/upcoming_movies/view/view.dart';
import '../popular_movies/bloc/popular_movies_bloc.dart';
import '../top_rated_movies/bloc/top_rated_movies_bloc.dart';
import '../upcoming_movies/bloc/upcoming_movies_bloc.dart';
import '../../core/widgets/app_failed.dart';
import '../../core/widgets/app_image.dart';
import '../../core/widgets/app_loading.dart';
import '../favorites/view/view.dart';
part 'components/popular_movies.dart';
part'components/upcoming_movies.dart';
part'components/favorite.dart';
part'components/top_rated_movies.dart';
part'components/search_result.dart';
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: _isSearching
              ? TextFormField(
            controller: _searchController,
            autofocus: true,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Search movies...",
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          )
              : Center(
            child: Text(
              'Movie',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (_isSearching) {
                    _isSearching = false;
                    _searchController.clear();
                    _searchQuery = '';
                  } else {
                    _isSearching = true;
                  }
                });
              },
              icon: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: Colors.yellow,
                size: 30.sp,
              ),
            ),
          ],
        ),

        body: _searchQuery.trim().isNotEmpty
            ? SearchResultView(query: _searchQuery.trim())
            : SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              PopularMoviesSection(),
              UpcomingSection(),
              TopRatedMoviesSection(),
              FavoriteSection(),

            ],
          ),
        ),
      ),
    );
  }
}
