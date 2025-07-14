part of 'top_rated_movies_bloc.dart';
class TopRatedEvents {}
class TopRatedEvent extends TopRatedEvents{}
class RefreshRatedEvent extends TopRatedEvents{}
class FilterTopRatedMoviesByGenreEvent extends TopRatedEvents {
  final int genreId;
  FilterTopRatedMoviesByGenreEvent({required this.genreId});
}