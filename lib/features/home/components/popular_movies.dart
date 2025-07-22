part of '../view.dart';

class PopularMoviesSection extends StatefulWidget {

  const PopularMoviesSection({super.key, });

  @override
  State<PopularMoviesSection> createState() => _PopularMoviesSectionState();
}

class _PopularMoviesSectionState extends State<PopularMoviesSection> {
  int _currentIndex = 0;

  final bloc = KiwiContainer().resolve<PoplarMoviesBloc>()..add(GetPopularMovieEvent());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Movies',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        BlocBuilder(
          bloc: bloc,
          builder: (context, state) {
            if (state is PopularFailedState) {
              return AppFailed(msg: state.msg);
            } else if (state is PopularSuccessState) {
              return CarouselSlider.builder(
                itemCount: state.list.length,
                itemBuilder: (context, index, realIndex) => InkWell(
                  onTap: (){
                    navigateTo(DetailsMovieView(id: state.list[index].id));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      _currentIndex == index ? 16.r : 10.r,
                    ),
                    child: AppImage(
                      state.list[index].posterPath,
                    ),
                  ),
                ),
                options: CarouselOptions(
                  onPageChanged: (index,reason){
                    _currentIndex=index;
                    setState(() {});
                  },
                  autoPlay: true,
                 enlargeCenterPage: true,
                  height: 400.h,
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
