part of 'favorite_movies_bloc.dart';
 class AddFavoriteMoviesStates {}
 class AddFavoriteMoviesLoadingState extends AddFavoriteMoviesStates {}
 class AddFavoriteMoviesInitState extends AddFavoriteMoviesStates {}
 class AddFavoriteMoviesSuccessState extends AddFavoriteMoviesStates {
 final bool isFavs;
 AddFavoriteMoviesSuccessState({ required this.isFavs});
}
 class AddFavoriteMoviesFailedState extends AddFavoriteMoviesStates {
 final String msg;
 AddFavoriteMoviesFailedState({required this.msg});

}


