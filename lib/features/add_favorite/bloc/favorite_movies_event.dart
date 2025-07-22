part of 'favorite_movies_bloc.dart';

 class AddFavoriteMoviesEvents {}
class AddFavoriteEvent extends AddFavoriteMoviesEvents {
  final int id;
  final bool isFavs;
  AddFavoriteEvent( {required this.id,required this.isFavs });
}







