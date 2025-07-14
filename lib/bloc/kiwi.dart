import 'package:kiwi/kiwi.dart';
import 'package:movie_app/bloc/main/details_movies/details_movies_bloc.dart';
import 'package:movie_app/bloc/main/favorite_movies/favorite_movies_bloc.dart';
import 'package:movie_app/bloc/main/similar_movie/similar_movie_bloc.dart';
import 'package:movie_app/bloc/main/top_rated_movies/top_rated_movies_bloc.dart';
import 'main/genres_movies/genres_movies_bloc.dart';
import 'main/popular_movies/popular_movies_bloc.dart';
import 'main/show_favorite_movies/show_favorite_movies_bloc.dart';
import 'main/upcoming_movies/upcoming_movies_bloc.dart';

void initKiwi(){
  final container=KiwiContainer();
  container.registerFactory((container) => PoplarMoviesBloc());
  container.registerFactory((container) =>UpcomingMovieBloc());
  container.registerFactory((container) =>TopRatedMovieBloc());
  container.registerFactory((container) =>DetailsMoviesBloc());
  container.registerFactory((container) =>SimilarMovieBloc());
  container.registerFactory((container) =>AddFavoriteMoviesBloc());
  container.registerSingleton((container) =>ShowFavoriteMoviesBloc());
  container.registerSingleton((container) =>GenresMoviesBloc());
}