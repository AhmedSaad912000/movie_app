import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/core/widgets/searchAndFilterField.dart';
import 'package:movie_app/features/favorites/bloc/show_favorite_movies_bloc.dart';
import 'package:movie_app/core/widgets/app_failed.dart';
import 'package:movie_app/features/movie_details/view/view.dart';
import 'package:movie_app/features/home/view.dart';
import 'package:movie_app/features/genres/view/show_movie_sheet.dart';
import '../../genres/bloc/genres_movies_bloc.dart';
import '../../../core/util/helper_methods.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/app_loading.dart';

class FavoriteMoviesView extends StatefulWidget {
  const FavoriteMoviesView({super.key});

  @override
  State<FavoriteMoviesView> createState() => _FavoriteMoviesViewState();
}

class _FavoriteMoviesViewState extends State<FavoriteMoviesView> {
  Genre? selectedGenre;
  List<Genre> genres = [];
  final TextEditingController _searcherController = TextEditingController();
  String _searchQuary = "";
  final bloc = KiwiContainer().resolve<ShowFavoriteMoviesBloc>()
    ..add(ShowFavoriteMoviesEvent());
  final genresBloc = KiwiContainer().resolve<GenresMoviesBloc>()
    ..add(GetGenresEvent());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Favorite',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.yellow,
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
            (states) => Colors.white,
          )),
        ),
      ),
      body: BlocListener(
        listener: (context, state) {
          if (state is GenresSuccessState) {
            genres = state.list
                .map((movieType) =>
                    Genre(id: movieType.id, name: movieType.name))
                .toList();
            setState(() {});
          }
        },
        bloc: genresBloc,
        child: BlocBuilder(
          bloc: bloc,
          builder: (context, state) {
            if (state is ShowFavoriteMoviesFailedState) {
              return AppFailed(msg: state.msg);
            } else if (state is ShowFavoriteMoviesSuccessState) {
              final filteredList = state.list.where((movie) {
                final title = movie.title.toLowerCase();
                return title.contains(_searchQuary.toLowerCase());
              }).toList();
              return Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(children: [
                  SearchAndFilterField(
                    controller: _searcherController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuary = value;
                      });
                    },
                    genres: genres,
                    selectedGenreName: selectedGenre?.name,
                    onSelectedGenre: (genre) {
                      setState(() {
                        selectedGenre = genre;
                      });
                      bloc.add(FilterShowFavoriteMoviesByGenreEvent(genreId: genre.id));
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    child: filteredList.isNotEmpty
                        ? GridView.builder(
                            itemCount: filteredList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8.h,
                                    crossAxisSpacing: 16.w),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  navigateTo(DetailsMovieView(
                                      id: filteredList[index].id));
                                },
                                child: AppImage(
                                  filteredList[index].posterPath,
                                  fit: BoxFit.fill,
                                ),
                              );
                            })
                        : Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50.h,
                                ),
                                Lottie.asset(
                                  "assets/lottie/movie_not_found.json",
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                Text(
                                  " Not Found",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.sp),
                                ),
                              ],
                            ),
                          ),
                  )
                ]),
              );
            } else {
              return AppLoading();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    KiwiContainer().resolve<ShowFavoriteMoviesBloc>()..add(ShowFavoriteMoviesEvent());
  }
}
