import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/core/widgets/app_failed.dart';
import 'package:movie_app/features/movie_details/view/view.dart';
import 'package:movie_app/features/genres/view/show_movie_sheet.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../../core/widgets/internet_aware_widget.dart';
import '../../../core/widgets/no_internet_widget.dart';
import '../../../core/widgets/searchAndFilterField.dart';
import '../../genres/bloc/genres_movies_bloc.dart';
import '../bloc/top_rated_movies_bloc.dart';
import '../../../core/util/helper_methods.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/app_loading.dart';

class TopRatedMoviesView extends StatefulWidget {
  const TopRatedMoviesView({super.key});

  @override
  State<TopRatedMoviesView> createState() => _TopRatedMoviesViewState();
}

class _TopRatedMoviesViewState extends State<TopRatedMoviesView> {
  Genre? selectedGenre;
  List<Genre> genres = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late final ScrollController _scrollController;
  final bloc = KiwiContainer().resolve<TopRatedMovieBloc>();
  final genresBloc = KiwiContainer().resolve<GenresMoviesBloc>();

  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          bloc.add(TopRatedEvent());
        }
      });
    bloc.add(RefreshRatedEvent());
    genresBloc.add(GetGenresEvent());
  }

  @override
  Widget build(BuildContext context) {
    return InternetAwareWidget(
      noInternetWidget:Scaffold(body: NoInternetWidget()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Top Rated',
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
          bloc: genresBloc,
          listener: (context, state) {
            if (state is GenresSuccessState) {
              genres = state.list
                  .map((movieType) =>
                      Genre(id: movieType.id, name: movieType.name))
                  .toList();
              setState(() {});
            }
          },
          child: BlocConsumer(
            listener: (context, state) {
              if (state is TopRatedSuccessState || state is TopRatedFailedState) {
                _refreshController.refreshCompleted();
                _refreshController.loadComplete();
              }
            },
            bloc: bloc,
            builder: (context, state) {
              if (state is TopRatedFailedState) {
                return AppFailed(msg: state.msg);
              } else if (state is TopRatedSuccessState) {
                final filteredList = state.list.where((movie) {
                  final title = movie.title.toLowerCase();
                  return title.contains(_searchQuery.toLowerCase());
                }).toList();
                return Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
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
                          bloc.add(FilterTopRatedMoviesByGenreEvent(genreId: genre.id));
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Expanded(
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: true,
                          enablePullUp: true,
                          onRefresh: () async {
                            bloc.add(RefreshRatedEvent());
                          },
                          onLoading: () async {
                            bloc.add(TopRatedEvent());
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
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      navigateTo(DetailsMovieView(
                                          id: filteredList[index].id));
                                    },
                                    child: AppImage(
                                      filteredList[index].posterPath,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
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
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return AppLoading();
              }
            },
          ),
        ),
      ),
    );
  }
}
