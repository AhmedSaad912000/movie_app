part of '../../../features/home/view.dart';

class UpcomingSection extends StatefulWidget {

  const UpcomingSection({
    super.key,

  });

  @override
  State<UpcomingSection> createState() => _UpcomingSectionState();
}

class _UpcomingSectionState extends State<UpcomingSection> {
  final bloc = KiwiContainer().resolve<UpcomingMovieBloc>()
    ..add(UpComingEvent());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Upcoming Movies',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
              ),
            ),
            Spacer(),
            TextButton(
                onPressed: () {
                  navigateTo(UpComingMoviesView());
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
            if (state is UpComingErrorState) {
              return AppFailed(msg: state.msg);
            } else if (state is UpComingSuccessState) {

              return SizedBox(
                height: 100.h,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    width: 10.w,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      navigateTo(DetailsMovieView(
                        id: state.list[index].id,
                      ));
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
                  itemCount: state.list.length,
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
