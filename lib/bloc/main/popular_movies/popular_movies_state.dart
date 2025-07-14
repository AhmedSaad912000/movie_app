part of 'popular_movies_bloc.dart';
class PopularMoviesStates{}
class PopularLoadingState extends PopularMoviesStates{}
class PopularSuccessState extends PopularMoviesStates{
  final  List<MoviePopularModel> list;
  PopularSuccessState({required this.list});

}
class PopularFailedState extends PopularMoviesStates{
  final String msg;
  PopularFailedState({required this.msg});

}