part of '../../../features/home/view.dart';

class TopRatedMoviesSection extends StatefulWidget {
  const TopRatedMoviesSection({
    super.key,
  });

  @override
  State<TopRatedMoviesSection> createState() => _TopRatedMoviesSectionState();
}

class _TopRatedMoviesSectionState extends State<TopRatedMoviesSection> {
  final bloc = KiwiContainer().resolve<TopRatedMovieBloc>()
    ..add(TopRatedEvent());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'TopRatedMovies ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
              ),
            ),
            Spacer(),
            TextButton(
                onPressed: () {
                  navigateTo(TopRatedMoviesView());
                },
                child: Text(
                  'See ALL',
                  style: TextStyle(color: Colors.yellow),
                )),
          ],
        ),
        BlocBuilder(
          bloc: bloc,
          builder: (context, state) {
            if (state is TopRatedFailedState) {
              return AppFailed(msg: state.msg);
            } else if (state is TopRatedSuccessState) {

              return SizedBox(
                height: 100.h,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    width: 5.w,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      navigateTo(DetailsMovieView(id: state.list[index].id));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
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
                  itemCount:  state.list.length,
                ),
              );
            } else {
              return AppLoading();
            }
          },
        )
      ],
    );
  }
}
