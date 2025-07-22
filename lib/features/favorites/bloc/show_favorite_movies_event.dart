part of 'show_favorite_movies_bloc.dart';
 class ShowFavoriteMoviesEvents {}
 class ShowFavoriteMoviesEvent extends ShowFavoriteMoviesEvents {}
class FilterShowFavoriteMoviesByGenreEvent extends ShowFavoriteMoviesEvents {
 final int genreId;
 FilterShowFavoriteMoviesByGenreEvent({required this.genreId});
}



