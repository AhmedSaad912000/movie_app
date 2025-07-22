import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import 'package:movie_app/features/movie_details/bloc/similar_movies/similar_movie_bloc.dart';

import '../../../../core/util/helper_methods.dart';
import '../../../../core/widgets/app_failed.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/app_loading.dart';
import '../view.dart';

class SimilarMoviesSection extends StatefulWidget{
  final int id;
  const SimilarMoviesSection({super.key, required this.id});

  @override
  State<SimilarMoviesSection> createState() => _SimilarMoviesSectionState();
}

class _SimilarMoviesSectionState extends State<SimilarMoviesSection> {
  @override
  void initState() {
    super.initState();
    similarBloc.add(SimilarMovieEvent(id: widget.id));
  }
  final similarBloc = KiwiContainer().resolve<SimilarMovieBloc>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Similar Movies ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: 16.h,),
        BlocBuilder(
          bloc: similarBloc,
          builder: (context, state) {
            if (state is SimilarMovieFailedState) {
              return AppFailed(msg: state.msg);
            } else if (state
            is SimilarMovieSuccessState) {
              return SizedBox(
                height: 100.h,
                child: ListView.separated(
                  padding:
                  EdgeInsets.only(bottom: 20.h),
                  itemCount: state.list.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(
                        width: 10.w,
                      ),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      InkWell(
                        onTap: (){
                          navigateTo(DetailsMovieView(id:state.list[index].id));
                        },
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.w),
                          child: AppImage(
                            state.list[index].posterPath,
                            width: 100.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                ),
              );
            } else {
              return AppLoading();
            }
          },
        ),
      ],
    );
  }
}