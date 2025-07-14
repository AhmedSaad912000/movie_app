part of 'show_favorite_movies_bloc.dart';
 class ShowFavoriteMoviesStates {}
final class ShowFavoriteMoviesLoadingState extends ShowFavoriteMoviesStates {}
final class ShowFavoriteMoviesSuccessState extends ShowFavoriteMoviesStates {
   final List<ShowFavoriteMovieModel> list;

   ShowFavoriteMoviesSuccessState( {required this.list});
}
final class ShowFavoriteMoviesFailedState extends ShowFavoriteMoviesStates {
   final String msg;

  ShowFavoriteMoviesFailedState({required this.msg});
}
