import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/features/upcoming_movies/bloc/upcoming_movies_bloc.dart';
import 'package:movie_app/core/widgets/app_failed.dart';
import 'package:movie_app/features/movie_details/view/view.dart';
import 'package:movie_app/features/home/view.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../../core/widgets/searchAndFilterField.dart';
import '../../genres/bloc/genres_movies_bloc.dart';
import '../../../core/util/helper_methods.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/app_loading.dart';
import '../../genres/view/show_movie_sheet.dart';

class UpComingMoviesView extends StatefulWidget {
  const UpComingMoviesView({super.key});

  @override
  State<UpComingMoviesView> createState() => _UpComingMoviesViewState();
}

class _UpComingMoviesViewState extends State<UpComingMoviesView> {
  Genre? selectedGenre;
  List<Genre> genres = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late final ScrollController _scrollController;
  final bloc = KiwiContainer().resolve<UpcomingMovieBloc>();
  final genresBloc = KiwiContainer().resolve<GenresMoviesBloc>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          bloc.add(UpComingEvent());
        }
      });
    bloc.add(RefreshUpcomingEvent());
    genresBloc.add(GetGenresEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text(
          'UpComing',
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
        child: BlocConsumer(
          listener: (context, state) {
            if (state is UpComingSuccessState || state is UpComingErrorState) {
              _refreshController.refreshCompleted();
              _refreshController.loadComplete();
            }
          },
          bloc: bloc,
          builder: (context, state) {
            if (state is UpComingErrorState) {
              return AppFailed(msg: state.msg);
            } else if (state is UpComingSuccessState) {
              final filteredList = state.list.where((movie) {
                return movie.title
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
              }).toList();
              return Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(children: [
                  SearchAndFilterField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    genres: genres,
                    selectedGenreName: selectedGenre?.name,
                    onSelectedGenre: (genre) {
                      setState(() {
                        selectedGenre = genre;
                      });
                      bloc.add(FilterUpcomingMoviesByGenreEvent(genreId: genre.id));
                    },
                  ),

                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                      child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    controller: _refreshController,
                    onRefresh: () async {
                      bloc.add(RefreshUpcomingEvent());
                      await Future.delayed(Duration(milliseconds: 500));
                      _refreshController.refreshCompleted();
                      setState(() {});
                    },
                    onLoading: () async {
                      bloc.add(UpComingEvent());
                      await Future.delayed(Duration(milliseconds: 500));
                      _refreshController.loadComplete();
                      setState(() {});
                    },
                    child: filteredList.isNotEmpty
                        ? GridView.builder(
                            controller: _scrollController,
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.sp),
                                ),
                              ],
                            ),
                          ),
                  ))
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
}
