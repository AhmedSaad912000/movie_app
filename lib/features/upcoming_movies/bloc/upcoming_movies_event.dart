part of 'upcoming_movies_bloc.dart';
class UpComingEvents {}
class UpComingEvent extends UpComingEvents{}
class RefreshUpcomingEvent extends UpComingEvents {}
class FilterUpcomingMoviesByGenreEvent extends UpComingEvents {
  final int genreId;
  FilterUpcomingMoviesByGenreEvent({required this.genreId});
}
