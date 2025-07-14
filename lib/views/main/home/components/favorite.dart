part of '../view.dart';

class FavoriteSection extends StatefulWidget {
  const FavoriteSection({super.key,});

  @override
  State<FavoriteSection> createState() => _FavoriteSectionState();
}

class _FavoriteSectionState extends State<FavoriteSection> {
  final showFavoriteMovie = KiwiContainer().resolve<ShowFavoriteMoviesBloc>()..add(ShowFavoriteMoviesEvent());

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: showFavoriteMovie,
        builder: (context, state) {
          if (state is ShowFavoriteMoviesFailedState) {
            return AppFailed(msg: state.msg);
          } else if (state is ShowFavoriteMoviesSuccessState) {
            if (state.list.isEmpty) {
              return SizedBox();
            }

            return Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Favorite Movies',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                        onPressed: () {
                          navigateTo(FavoriteMoviesView());
                        },
                        child: Text(
                          'See ALL',
                          style: TextStyle(color: Colors.yellow),
                        )),
                  ],
                ),
                SizedBox(
                  height: 100.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => SizedBox(width: 5.sp,),
                    itemCount:state.list.length,
                    itemBuilder: (context, index) =>
                        InkWell(
                          onTap: (){
                            navigateTo(DetailsMovieView(id: state.list[index].id));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: AppImage(
                                state.list[index].posterPath,
                                width: 100.w,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                  ),
                ),
              ],
            );
          }else{
            return AppLoading();
          }
        },

    );
  }
}
