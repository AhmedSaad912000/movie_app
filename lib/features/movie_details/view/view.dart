import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import 'package:movie_app/features/movie_details/bloc/details_movies_bloc.dart';
import 'package:movie_app/features/add_favorite/bloc/favorite_movies_bloc.dart';
import 'package:movie_app/core/util/helper_methods.dart';
import 'package:movie_app/core/widgets/app_failed.dart';
import 'package:movie_app/core/widgets/app_loading.dart';
import 'package:movie_app/features/home/view.dart';
import '../../add_favorite/view/add_favorite.dart';
import '../../favorites/bloc/show_favorite_movies_bloc.dart';
import '../bloc/similar_movies/similar_movie_bloc.dart';
import '../../../core/widgets/app_image.dart';
import 'components/similar_movies_section.dart';

class DetailsMovieView extends StatefulWidget {
  final int id;

  const DetailsMovieView({super.key, required this.id});

  @override
  State<DetailsMovieView> createState() => _DetailsMovieState();
}

class _DetailsMovieState extends State<DetailsMovieView> {
  @override
  void initState() {
    super.initState();
    bloc.add(GetDetailsMovieEvent(id: widget.id));
  }

  double normalizeRating(double rating) {
    return (rating * 2).round() / 2;
  }
  final bloc = KiwiContainer().resolve<DetailsMoviesBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Row(
          children: [
            SizedBox(
              width: 8.w,
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: Icon(Icons.arrow_back),
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                (states) => Colors.white,
              )),
              color: Colors.yellow,
            ),
          ],
        ),
        actions: [
          FavoriteButton(movieId: widget.id),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          if (state is DetailsMovieStateFailed) {
            return AppFailed(msg: state.msg);
          } else if (state is DetailsMovieStateSuccess) {
            return CustomScrollView(
              slivers: [

                SliverAppBar(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.r),
                      topRight: Radius.circular(40.r),
                    ),
                  ),
                  automaticallyImplyLeading: false,
                  expandedHeight: 250.h,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: AppImage(
                      state.model.backdropPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                           ClipRRect(
                              borderRadius: BorderRadius.circular(120.r),
                              child: AppImage(
                                state.model.posterPath,
                                height: 100.h,
                                width: 100.w,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.model.title,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Container(
                                    padding: EdgeInsets.all(6.w),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.yellowAccent, width: 3.w),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Text(
                                      state.model.genres.map((e) => e.name).join(" "),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    state.model.releaseDate,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Row(
                                    children: [
                                      RatingBar.builder(
                                        initialRating:
                                        normalizeRating(state.model.voteAverage / 2),
                                        ignoreGestures: true,
                                        allowHalfRating: true,
                                        itemSize: 25.sp,
                                        itemPadding: EdgeInsets.only(right: 5.w),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        onRatingUpdate: (_) {},
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        state.model.voteAverage.round().toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.yellow,
                                            fontSize: 15.sp),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Overview',
                          style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          state.model.overview,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        SimilarMoviesSection(id: widget.id),
                      ],
                    ),
                  ),
                )
              ],
            );

          } else {
            return AppLoading();
          }
        },
      ),
    );
  }
}
