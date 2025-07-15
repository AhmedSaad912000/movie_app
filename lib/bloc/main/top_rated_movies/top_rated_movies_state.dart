part of 'top_rated_movies_bloc.dart';


class TopRatedStates{}
class TopRatedLoadingState extends TopRatedStates{}
class TopRatedSuccessState extends TopRatedStates{
  final List<MovieModel> list;
  final bool hasReachedMax;

  TopRatedSuccessState( {required this.list,required this.hasReachedMax});
}
class TopRatedFailedState extends TopRatedStates{
  final String msg;

  TopRatedFailedState({required this.msg});

}