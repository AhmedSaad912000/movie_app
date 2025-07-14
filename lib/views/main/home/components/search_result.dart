part of '../view.dart';

class SearchResultView extends StatefulWidget {
  final String query;

  const SearchResultView({super.key, required this.query});

  @override
  State<SearchResultView> createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<SearchResultView> {
  late final PoplarMoviesBloc popularBloc;
  late final TopRatedMovieBloc topRatedBloc;
  late final UpcomingMovieBloc upcomingBloc;
  late final ShowFavoriteMoviesBloc favBloc;

  @override
  void initState() {
    super.initState();
    popularBloc = KiwiContainer().resolve<PoplarMoviesBloc>()
      ..add(GetPopularMovieEvent());
    topRatedBloc = KiwiContainer().resolve<TopRatedMovieBloc>()
      ..add(TopRatedEvent());
    upcomingBloc = KiwiContainer().resolve<UpcomingMovieBloc>()
      ..add(UpComingEvent());
    favBloc = KiwiContainer().resolve<ShowFavoriteMoviesBloc>()
      ..add(ShowFavoriteMoviesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PoplarMoviesBloc, PopularMoviesStates>(
          bloc: popularBloc,
          listener: (context, state) => setState(() {}),
        ),
        BlocListener<TopRatedMovieBloc, TopRatedStates>(
          bloc: topRatedBloc,
          listener: (context, state) => setState(() {}),
        ),
        BlocListener<UpcomingMovieBloc, UpComingStates>(
          bloc: upcomingBloc,
          listener: (context, state) => setState(() {}),
        ),
        BlocListener<ShowFavoriteMoviesBloc, ShowFavoriteMoviesStates>(
          bloc: favBloc,
          listener: (context, state) => setState(() {}),
        ),
      ],
      child: _buildSearchResults(),
    );
  }

  Widget _buildSearchResults() {
    List<dynamic> collected = [];

    if (popularBloc.state is PopularSuccessState) {
      collected.addAll((popularBloc.state as PopularSuccessState).list);
    }
    if (topRatedBloc.state is TopRatedSuccessState) {
      collected.addAll((topRatedBloc.state as TopRatedSuccessState).list);
    }
    if (upcomingBloc.state is UpComingSuccessState) {
      collected.addAll((upcomingBloc.state as UpComingSuccessState).list);
    }
    if (favBloc.state is ShowFavoriteMoviesSuccessState) {
      collected.addAll((favBloc.state as ShowFavoriteMoviesSuccessState).list);
    }
    final filtered = collected
        .where((movie) =>
            movie.title.toLowerCase().contains(widget.query.toLowerCase()))
        .toList();
    final uniqueMovies =
        {
          for (var movie in filtered) movie.id: movie}.values.toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: uniqueMovies.isEmpty
          ? Center(
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
      )
          : ListView.separated(
              itemCount: uniqueMovies.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final movie = uniqueMovies[index];
                return Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: AppImage(movie.posterPath, width: 50.w),
                    title: Text(movie.title,
                        style: TextStyle(color: Colors.white)),
                    onTap: () => navigateTo(DetailsMovieView(id: movie.id)),
                  ),
                );
              },
            ),
    );
  }
}
