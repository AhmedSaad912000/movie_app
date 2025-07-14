part of 'similar_movie_bloc.dart';


class SimilarMovieStates{}
class SimilarMovieLoadingState extends SimilarMovieStates{}
class SimilarMovieSuccessState extends SimilarMovieStates{
  final List<SimilarMovieModel> list;

  SimilarMovieSuccessState({required this.list});
}
class SimilarMovieFailedState extends SimilarMovieStates{
  final String msg;

  SimilarMovieFailedState({required this.msg});

}