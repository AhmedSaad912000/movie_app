part of 'details_movies_bloc.dart';

 class DetailsMoviesStates {}
 class DetailsMovieStateLoading extends DetailsMoviesStates {


 }
 class DetailsMovieStateSuccess extends DetailsMoviesStates {
  DetailsMovieData model;
  DetailsMovieStateSuccess({required this.model});
 }
 class DetailsMovieStateFailed extends DetailsMoviesStates {
 final String msg;

  DetailsMovieStateFailed({ required this.msg});

 }
