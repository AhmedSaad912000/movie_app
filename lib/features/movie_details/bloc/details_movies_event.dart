part of 'details_movies_bloc.dart';

 class DetailsMoviesEvents {}

class GetDetailsMovieEvent extends DetailsMoviesEvents{
 final int id;
  GetDetailsMovieEvent({required this.id});

}
