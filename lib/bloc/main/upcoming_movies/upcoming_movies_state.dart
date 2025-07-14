part of 'upcoming_movies_bloc.dart';


class UpComingStates{}
class UpComingLoadingState extends UpComingStates{}
class UpComingSuccessState extends UpComingStates{
  final List<MovieUpComingModel> list;
  final bool hasReachedMax;

  UpComingSuccessState({  required this.list,required this.hasReachedMax});
}
class UpComingErrorState extends UpComingStates{
  final String msg;
  UpComingErrorState({required this.msg});

}